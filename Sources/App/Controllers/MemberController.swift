import Vapor
import HTTP

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
        
        user.get(handler: users)
        user.get(Int.parameter, "teams", handler: teams)
        user.get(Int.parameter, "member-id", handler: memberID)
    }
    
    // MARK: - Routes
    // /teams
    
    public func post(_ request: Request)throws -> ResponseRepresentable {
        try TeamController.assertAdmin(request)
        let teamID = try request.parameters.next(Int.self)
        guard let team = try Team.find(teamID) else {
            throw Abort(.notFound, reason: "No team exists with the ID of '\(teamID)'")
        }
        guard let newStatus = request.data["new_status"]?.int,
              let userID = request.data["user_id"]?.int else {
                throw Abort(.badRequest, reason: "Missing status or user ID for new member")
        }
        let member: Member
        
        if let found = try Member.makeQuery().filter("user_id", userID).first() {
            member = found
        } else {
            member = try Member(userID: userID, status: newStatus)
        }
        
        try team.members.add(member)
        return try member.makeJSON()
    }
    
    public func get(_ request: Request)throws -> ResponseRepresentable {
        return try memberAndTeam(from: request).member.makeJSON()
    }
    
    public func delete(_ request: Request)throws -> ResponseRepresentable {
        try TeamController.assertAdmin(request)
        let member = try memberAndTeam(from: request).member
        try MemberTeam.makeQuery().filter("member_id", member.id).all().forEach({try $0.delete()})
        try member.delete()
        
        return try JSON(node: [
            "status": Status.ok.statusCode,
            "message": "Member with the ID '\(member.id?.wrapped.string ?? "null")' was deleted"
            ])
    }
    
    // /users
    
    public func users(_ request: Request)throws -> ResponseRepresentable {
        return try TeamMember.all().makeJSON()
    }
    
    public func teams(_ request: Request)throws -> ResponseRepresentable {
        let userID = try request.parameters.next(Int.self)
        guard let member = try TeamMember.makeQuery().filter("user_id", userID).first() else {
            throw Abort(.notFound, reason: "No entries found for user ID '\(userID)'")
        }
        
        return try member.teams().all().makeJSON()
    }
    
    public func memberID(_ request: Request)throws -> ResponseRepresentable {
        let userID = try request.parameters.next(Int.self)
        guard let member = try Member.makeQuery().filter("user_id", userID).first() else {
            throw Abort(.notFound, reason: "No entries found for user ID '\(userID)'")
        }
        guard let memberID = member.id?.wrapped.int else {
            throw Abort(.notFound, reason: "No entries found for user ID '\(userID)'")
        }
        
        return try JSON(node: [
                "member_id": memberID,
                "member": member
            ])
    }
    
    // MARK: - Helpers
    
    public func memberAndTeam(from request: Request)throws -> (member: Member, team: Team) {
        let teamID = try request.parameters.next(Int.self)
        let memberID = try request.parameters.next(Int.self)
        
        guard let team = try Team.find(teamID) else {
            throw Abort(.notFound, reason: "No team exists with the ID of '\(teamID)'")
        }
        guard let member = try team.members.find(memberID) else {
            throw Abort(.notFound, reason: "No member with the ID of '\(memberID)' exists in the specified team")
        }
        return (member: member, team: team)
    }
}
