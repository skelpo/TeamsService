import Vapor
import JWTProvider
import JWT

extension Droplet {
    func setupRoutes() throws {
        guard let jwkUrl: String = self.config["app", "jwks_url"]?.string else {
            fatalError("Missing 'jwks_url' value in app config")
        }
        let expirationClaim = ExpirationTimeClaim()
        let jwtMiddleware = PayloadAuthenticationMiddleware<Member>(jwkUrl, [expirationClaim], Member.self)
        
        let api = self.grouped(APIErrorMiddleware(), jwtMiddleware)
        
        TeamController(builder: api).configureRoutes()
        MemberController(builder: api).configureRoutes()
    }
}
