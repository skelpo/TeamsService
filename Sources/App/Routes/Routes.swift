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
        // This method requires the controllers to conform to the `RouteCollection` and `EmptyInitializable` protocols.
        try api.collection(TeamController.self)
        try api.collection(MemberController.self)
        
        // Create a route at the path `/teams/health` using a closure for the handler.
        // This route is used by the AWS E2C instance to check the health of the server.
        // We are registering the route here because we can't have it behind an authentication layer.
        self.get("teams", "health") { request in
            return "all good"
        }
    }
}
