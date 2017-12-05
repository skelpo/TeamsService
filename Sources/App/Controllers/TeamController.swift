import Vapor

public final class TeamController {
    let builder: RouteBuilder
    
    public init(drop: Droplet) {
        self.builder = drop.grouped("teams").grouped(APIErrorMiddleware())
    }
    
    public func configureRoutes() {
        builder.get(handler: all)
        builder.get(Int.parameter, handler: getWithID)
        
        MemberController(builder: builder).configureRoutes()
    }
    
    public func all(_ request: Request)throws -> ResponseRepresentable {
        return try Team.all().makeJSON()
    }
    
    public func getWithID(_ request: Request)throws -> ResponseRepresentable {
        let id = try request.parameters.next(Int.self)
        guard let team = try Team.find(id)?.makeJSON() else {
            throw Abort(.badRequest, reason: "No team exists with the id of '\(id)'")
        }
        return team
    }
}
