import Vapor
import HTTP
import JWTProvider
import JWT
import AuthProvider

public final class JWTAuthenticationMiddleware: Middleware {
    private(set) var signers: SignerMap
    let url: String
    let claims: [Claim]
    let client: ClientFactoryProtocol
    
    public init(url: String, claims: [Claim] = []) {
        self.url = url
        self.claims = claims
        
        self.signers = SignerMap()
        self.client = EngineClientFactory()
    }
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        return Response(status: .ok)
    }
    
    private func signer(for jwt: JWT) throws -> Signer {
        guard let kid = jwt.keyIdentifier else {
            throw JWTProviderError.noVerifiedJWT
        }
        
        if let signer = self.signers[kid] {
            return signer
        }
        
        guard let jwks = try self.client.get(url).json else {
            throw JWTProviderError.noJWTSigner
        }
        
        self.signers = try SignerMap(jwks: jwks)
        
        guard let signer = self.signers[kid] else {
            throw JWTProviderError.noJWTSigner
        }
        
        return signer
    }
}
