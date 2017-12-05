import Vapor

extension Droplet {
    func setupRoutes() throws {
        TeamController(drop: self).configureRoutes()
    }
}
