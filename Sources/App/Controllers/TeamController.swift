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
        builder.get(handler: health)
        builder.get(handler: all)
        builder.post(handler: post)
        builder.get(Int.parameter, handler: getWithID)
        builder.delete(Int.parameter, handler: delete)
    }
    
    // MARK: - Route
    
    public func health(_ request: Request)throws -> ResponseRepresentable {
        return "all good"
    }
    
    public func post(_ request: Request)throws -> ResponseRepresentable {
        try TeamController.assertAdmin(request)
        guard let name = request.data["name"]?.string else {
            throw Abort(.badRequest, reason: "Missing 'name' paramater in request data")
        }
        let team = Team(name: name)
        try team.save()
        
        guard let teamID = team.id?.wrapped.int else {
            throw Abort(.internalServerError, reason: "Team was not saved to the database")
        }
        let userID: Int = try request.payload().get("id")
        let member = TeamMember(userID: userID, teamID: teamID, status: .admin)
        try member.save()
        
        return try team.makeJSON()
    }
    
    public func all(_ request: Request)throws -> ResponseRepresentable {
        let ids = try request.teams()
        let teams = try Team.makeQuery().filter("id", in: ids).all()
        return try teams.makeJSON()
    }
    
    public func getWithID(_ request: Request)throws -> ResponseRepresentable {
        let id = try request.parameters.next(Int.self)
        try TeamController.assertTeam(id, with: request)
        
        guard let team = try Team.find(id)?.makeJSON() else {
            throw Abort(.notFound, reason: "No team exists with the id of '\(id)'")
        }
        return team
    }
    
    public func delete(_ request: Request)throws -> ResponseRepresentable {
        try TeamController.assertAdmin(request)
        let teamID = try request.parameters.next(Int.self)
        try TeamController.assertTeam(teamID, with: request)
        
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
