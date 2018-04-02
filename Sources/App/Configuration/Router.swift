import Routing
import Vapor
import SkelpoMiddleware

// Register the application's routes with the router.
public func routes(_ router: Router)throws {

    // Create a route group with middleware for:
    // 1. Converting errors to JSON
    // 2. Authenticating a user with a JWT token
    // 3. Getting the team IDs from the JWT payload
    let api = router.grouped(
        APIErrorMiddleware(),
        JWTAuthenticationMiddleware<Payload>(),
        TeamIDMiddleware<Payload>()
    ).grouped(DynamicPathComponent.anything, "teams")
    
    // Configure the routes in the `TeamController` and `MemberController` with the `api` route group.
    // This method requires the controllers to conform to the `RouteCollection` and `EmptyInitializable` protocols.
    try api.register(collection: TeamController())
    try api.register(collection: MemberController())
    
    // Create a route at the path `/teams/health` using a closure for the handler.
    // This route is used by the AWS E2C instance to check the health of the server.
    // We are registering the route here because we can't have it behind an authentication layer.
    router.get(DynamicPathComponent.anything, "teams", "health") { request in
        return "all good"
    }
}
