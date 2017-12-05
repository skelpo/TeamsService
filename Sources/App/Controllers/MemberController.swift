import Vapor

public final class MemberController {
    public let builder: RouteBuilder
    
    // MARK: - Configuration
    
    public init(builder: RouteBuilder) {
        self.builder = builder.grouped(Int.parameter, "users")
    }
    
    public func configureRoutes() {
        builder.get(Int.parameter, handler: get)
        builder.delete(Int.parameter, handler: delete)
    }
    
    // MARK: - Routes
    
    public func get(_ request: Request)throws -> ResponseRepresentable {
        return try memberAndTeam(from: request).member.makeJSON()
    }
    
    public func delete(_ request: Request)throws -> ResponseRepresentable {
        guard let status = request.data["status"]?.int,
            MemberStatus(rawValue: status) == .admin else {
                throw Abort(.forbidden, reason: "User doers not have required privileges")
        }
        let member = try memberAndTeam(from: request).member
        try member.delete()
        
        return Response(status: .ok)
    }
    
    // MARK: - Helpers
    
    public func memberAndTeam(from request: Request)throws -> (member: Member, team: Team) {
        let teamID = try request.parameters.next(Int.self)
        let memberID = try request.parameters.next(Int.self)
        
        guard let team = try Team.find(teamID) else {
            throw Abort(.badRequest, reason: "No team exists with the ID of '\(teamID)'")
        }
        guard let member = try team.members.find(memberID) else {
            throw Abort(.badRequest, reason: "No member with the ID of '\(memberID)' exists in the specified team")
        }
        return (member: member, team: team)
    }
}
