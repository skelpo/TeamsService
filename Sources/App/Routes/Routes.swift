import Vapor
import JWTProvider
import JWT
import SkelpoMiddleware

extension Droplet {
    func setupRoutes() throws {
        // Get the `jwks_url` key from `app.json` as a `String`.
        guard let jwkUrl: String = self.config["app", "jwks_url"]?.string else {
            fatalError("Missing 'jwks_url' value in app config")
        }
        
        // Create a route group with middleware for:
        // 1. Converting errors to JSON
        // 2. Authenticating a user with a JWT token
        // 3. Getting the team IDs from the JWT payload
        let api = self.grouped(
            APIErrorMiddleware(),
            JWTAuthenticationMiddleware(url: jwkUrl, claims: [ExpirationTimeClaim()]),
            TeamIDMiddleware()
        ).grouped("teams")
        
        // Configure the routes in the `TeamController` and `MemberController` with the `api` route group.
        // These use custom methods. There are other ways to do this.
        try api.collection(TeamController())
        try api.collection(MemberController.self)
    }
}
