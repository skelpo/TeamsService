import Routing
import Vapor

final class Router: RouteCollection {
    let app: Application

    init(app: Application) {
        self.app = app
    }
    
    func boot(router: Router) throws {}
}
