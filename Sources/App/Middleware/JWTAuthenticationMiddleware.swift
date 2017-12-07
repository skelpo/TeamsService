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
}
