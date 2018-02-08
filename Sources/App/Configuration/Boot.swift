import Routing
import Vapor

/// Not sure why they called this function `boot`.
/// This function actually registers the routes with
/// the application's router.
public func boot(_ app: Application) throws {
    
    // Get the router service held by the app.
    let router = try app.make(Router.self)
    
    // Initialize the app's route register.
    let routes = Routes(app: app)
    
    // Register the routes with the application's router.
    try router.register(collection: routes)
}
