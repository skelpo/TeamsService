import Vapor
import JWTProvider
import JWT
import AuthMiddleware
import APIMiddleware

extension Droplet {
    func setupRoutes() throws {
        guard let jwkUrl: String = self.config["app", "jwks_url"]?.string else {
            fatalError("Missing 'jwks_url' value in app config")
        }
        
        let api = self.grouped(APIErrorMiddleware(), JWTAuthenticationMiddleware(url: jwkUrl, claims: [ExpirationTimeClaim()]))
        
        TeamController(builder: api).configureRoutes()
        MemberController(builder: api).configureRoutes()
    }
}
