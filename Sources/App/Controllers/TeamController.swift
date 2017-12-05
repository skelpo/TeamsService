import Vapor

public final class TeamController {
    let builder: RouteBuilder
    
    // MARK: - Configuration
    
    public init(drop: Droplet) {
        self.builder = drop.grouped("teams").grouped(APIErrorMiddleware())
    }
    
    public func configureRoutes() {
        builder.get(handler: all)
        builder.post(handler: post)
        builder.get(Int.parameter, handler: getWithID)
        builder.delete(Int.parameter, handler: delete)
        
        MemberController(builder: builder).configureRoutes()
    }
    
    // MARK: - Route
    
    public func post(_ request: Request)throws -> ResponseRepresentable {
        try TeamController.assertAdmin(request)
        guard let name = request.data["name"]?.string else {
            throw Abort(.badRequest, reason: "Missing name paramater in request data")
        }
        let members = (request.data["members"]?.array ?? []).map({$0.int ?? -1})
        let team = Team(name: name)
        try team.save()
        try team.add(members: members)
        
        return Response(status: .ok)
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
    
    public func delete(_ request: Request)throws -> ResponseRepresentable {
        try TeamController.assertAdmin(request)
        let teamID = try request.parameters.next(Int.self)
        guard let team = try Team.find(teamID) else {
            throw Abort(.badRequest, reason: "No team exists with the ID of '\(teamID)'")
        }
        try MemberTeam.makeQuery().filter("team_id", team.id).all().forEach({try $0.delete()})
        try team.delete()
        
        return Response(status: .ok)
    }
    
    // MAR: - Helpers
    
    static public func assertAdmin(_ request: Request)throws {
        guard let status = request.data["status"]?.int,
            MemberStatus(rawValue: status) == .admin else {
                throw Abort(.forbidden, reason: "User doers not have required privileges")
        }
    }
}
