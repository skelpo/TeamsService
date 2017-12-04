import Vapor

public final class TeamController {
    let builder: RouteBuilder
    
    public init(drop: Droplet) {
        self.builder = drop.grouped("teams")
    }
    
    public func configureRoutes() {
        builder.get(handler: all)
    }
    
    public func all(_ request: Request)throws -> ResponseRepresentable {
        return try Team.all().makeJSON()
    }
}
