import Vapor
import HTTP
import SkelpoMiddleware

public final class TeamController {
    let builder: RouteBuilder
    
    // MARK: - Configuration
    
    public init(builder: RouteBuilder) {
        self.builder = builder.grouped("teams")
    }
    
    public func configureRoutes() {
        builder.get(handler: all)
        builder.post(handler: post)
        builder.get(Int.parameter, handler: getWithID)
        builder.delete(Int.parameter, handler: delete)
    }
    
    // MARK: - Route
    
    public func post(_ request: Request)throws -> ResponseRepresentable {
        try TeamController.assertAdmin(request)
        guard let name = request.data["name"]?.string else {
            throw Abort(.badRequest, reason: "Missing name paramater in request data")
        }
        let team = Team(name: name)
        try team.save()
        
        return try team.makeJSON()
    }
    
    public func all(_ request: Request)throws -> ResponseRepresentable {
        return try Team.all().makeJSON()
    }
    
    public func getWithID(_ request: Request)throws -> ResponseRepresentable {
        let id = try request.parameters.next(Int.self)
        guard let team = try Team.find(id)?.makeJSON() else {
            throw Abort(.notFound, reason: "No team exists with the id of '\(id)'")
        }
        return team
    }
    
    public func delete(_ request: Request)throws -> ResponseRepresentable {
        try TeamController.assertAdmin(request)
        let teamID = try request.parameters.next(Int.self)
        guard let team = try Team.find(teamID) else {
            throw Abort(.notFound, reason: "No team exists with the ID of '\(teamID)'")
        }
        try TeamMember.makeQuery().filter("team_id", team.id).delete()
        try team.delete()
        
        return try JSON(node: [
                "status": Status.ok.statusCode,
                "message": "Team '\(team.name)' was deleted"
            ])
    }
    
    // MARK: - Helpers
    
    @discardableResult
    static public func assertTeam(_ team: Int, with request: Request)throws -> [Int] {
        let teams = try request.teams()
        guard teams.contains(team) else {
            throw Abort(.notFound, reason: "Team not found for user")
        }
        return teams
    }
    
    static public func assertAdmin(_ request: Request)throws {
        guard let status = request.data["status"]?.int,
            MemberStatus(rawValue: status) == .admin else {
                throw Abort(.forbidden, reason: "User doers not have required privileges")
        }
    }
}
