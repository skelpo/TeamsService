import Vapor

public final class TeamController {
    let builder: RouteBuilder
    
    // MARK: - Configuration
    
    public init(drop: Droplet) {
        self.builder = drop.grouped("teams").grouped(APIErrorMiddleware())
    }
    
    public func configureRoutes() {
        builder.get(handler: all)
        builder.get(Int.parameter, handler: getWithID)
        builder.delete(Int.parameter, handler: delete)
        
        MemberController(builder: builder).configureRoutes()
    }
    
    // MARK: - Route
    
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
    
    public func delete(_ request: Request)throws -> ResponseRepresentable {
        guard let status = request.data["status"]?.int,
            MemberStatus(rawValue: status) == .admin else {
                throw Abort(.forbidden, reason: "User doers not have required privileges")
        }
        let teamID = try request.parameters.next(Int.self)
        guard let team = try Team.find(teamID) else {
            throw Abort(.badRequest, reason: "No team exists with the ID of '\(teamID)'")
        }
        try team.delete()
        
        return Response(status: .ok)
    }
}
