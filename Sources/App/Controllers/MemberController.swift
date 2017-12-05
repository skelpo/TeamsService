import Vapor

public final class MemberController {
    public let builder: RouteBuilder
    
    public init(builder: RouteBuilder) {
        self.builder = builder.grouped(Int.parameter, "users")
    }
    
    public func configureRoutes() {
        builder.get(Int.parameter, handler: get)
    }
    
    public func get(_ request: Request)throws -> ResponseRepresentable {
        let teamID = try request.parameters.next(Int.self)
        let memberID = try request.parameters.next(Int.self)
        
        guard let team = try Team.find(teamID) else {
            throw Abort(.badRequest, reason: "No team exists with the ID of '\(teamID)'")
        }
        guard let member = try team.members.find(memberID) else {
            throw Abort(.badRequest, reason: "No member with the ID of '\(memberID)' exists in the specified team")
        }
        
        return try member.makeJSON()
    }
}
