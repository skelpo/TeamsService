import Routing
import Vapor

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
        try router.register(collection: MemberController())
    }
}
