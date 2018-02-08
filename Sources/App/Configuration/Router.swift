import Routing
import Vapor
import SkelpoMiddleware

/// The main route collection for the application.
/// It is used to register the app's routes with the router.
final class Routes: RouteCollection {
    
    /// The application that the routes are added to.
    let app: Application

    /// Creates a new `Routes` collection and injects the app that created the router.
    init(app: Application) {
        self.app = app
    }
    
    /// Adds the controllers' routes to the router.
    func boot(router: Router) throws {
        // TODO: - Add `JWTAuthenticationMiddleware` to api route group.
        
        // Create a route group with middleware for:
        // 1. Converting errors to JSON
        // 2. Authenticating a user with a JWT token
        // 3. Getting the team IDs from the JWT payload
        let api = router.grouped(
            APIErrorMiddleware(),
            TeamIDMiddleware()
        ).grouped("*", "teams")
        
        // Configure the routes in the `TeamController` and `MemberController` with the `api` route group.
        // This method requires the controllers to conform to the `RouteCollection` and `EmptyInitializable` protocols.
        try api.register(collection: TeamController())
        try api.register(collection: MemberController())
        
        // Create a route at the path `/teams/health` using a closure for the handler.
        // This route is used by the AWS E2C instance to check the health of the server.
        // We are registering the route here because we can't have it behind an authentication layer.
        router.get("*", "teams", "health") { request in
            return "all good"
        }
    }
}
