import Vapor

extension Droplet {
    func setupRoutes() throws {
        let api = self.grouped(APIErrorMiddleware())
        TeamController(builder: api).configureRoutes()
        MemberController(builder: api).configureRoutes()
    }
}
