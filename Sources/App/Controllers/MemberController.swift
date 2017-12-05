import Vapor

public final class MemberController {
    public let team: RouteBuilder
    public let user: RouteBuilder
    
    // MARK: - Configuration
    
    public init(builder: RouteBuilder) {
        self.team = builder.grouped("teams", Int.parameter, "users")
        self.user = builder.grouped("users")
    }
    
    public func configureRoutes() {
        team.get(Int.parameter, handler: get)
        team.post(handler: post)
        team.delete(Int.parameter, handler: delete)
    }
    
    // MARK: - Routes
    // /teams
    
    public func post(_ request: Request)throws -> ResponseRepresentable {
        try TeamController.assertAdmin(request)
        let teamID = try request.parameters.next(Int.self)
        guard let team = try Team.find(teamID) else {
            throw Abort(.badRequest, reason: "No team exists with the ID of '\(teamID)'")
        }
        guard let newStatus = request.data["new_status"]?.int,
              let userID = request.data["user_id"]?.int else {
                throw Abort(.badRequest, reason: "Missing status or user ID for new member")
        }
        
        let member = try Member(userID: userID, status: newStatus)
        try member.save()
        try team.members.add(member)
        
        return Response(status: .ok)
    }
    
    public func get(_ request: Request)throws -> ResponseRepresentable {
        return try memberAndTeam(from: request).member.makeJSON()
    }
    
    public func delete(_ request: Request)throws -> ResponseRepresentable {
        try TeamController.assertAdmin(request)
        let member = try memberAndTeam(from: request).member
        try MemberTeam.makeQuery().filter("member_id", member.id).all().forEach({try $0.delete()})
        try member.delete()
        
        return Response(status: .ok)
    }
    
    // /users
    
    
    
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
