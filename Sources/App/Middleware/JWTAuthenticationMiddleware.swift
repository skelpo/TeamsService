import Vapor
import HTTP
import JWTProvider
import JWT

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
            // The token doesn't include a kid
            throw JWTProviderError.noVerifiedJWT
        }
        
        // We don't have any signer cached with that kid, but we have a jwks url
        // Get remote jwks.json
        guard let jwks = try self.client.get(url).json else {
            throw JWTProviderError.noJWTSigner
        }
        
        // Update cache
        self.signers = try SignerMap(jwks: jwks)
        
        // Search again
        guard let signer = self.signers[kid] else {
            throw JWTProviderError.noJWTSigner
        }
        
        return signer
    }
}
