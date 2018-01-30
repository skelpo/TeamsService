import Routing
import Vapor

final class Routes: RouteCollection {
    let app: Application

    init(app: Application) {
        self.app = app
    }
    
    func boot(router: Router) throws {
        try router.register(collection: MemberController())
    }
}
