import Vapor
import HTTP

/// The routes controller for interacting with team members.
public final class MemberController: RouteCollection, EmptyInitializable {
    
    /// This init method is so the `MemberController` can conform to the `EmptyInitializable` protocol.
    public init() {}
    
    // MARK: - Configuration
    
    /// Used for adding the routes in a `RouteCollection` to a route builder.
    /// This method is called by the `routeBuilder.collection` method.
    public func build(_ builder: RouteBuilder) throws {
        // The route builder for routes with the path `/teams/:int/users/...`
        let team = builder.grouped(Int.parameter, "users")
        
        // The route builder for routes with the path `/teams/users/...`
        let user = builder.grouped("users")
        
        
        // Create a route at the path `/teams/:int/users/:int` using the `.get` method as the handler.
        team.get(Int.parameter, handler: get)
        
        // Create a route at the path `/teams/:int/users` using the `.post` method as the handler.
        team.post(handler: post)
        
        // Create a route at the path `/teams/:int/users/:int` using the `.delete` method as the handler.
        team.delete(Int.parameter, handler: delete)
        
        
        // Create a route at the path `/teams/users/:int/teams` using the `.teams` method as the handler.
        user.get(Int.parameter, "teams", handler: teams)
    }
    
    // MARK: - Routes
    // /teams
    
    /// Adds a new member to a team.
    public func post(_ request: Request)throws -> ResponseRepresentable {
        // Verifiy that the user adding the member is a team admin.
        try TeamController.assertAdmin(request)
        
        // Get the ID of the team to add the user to from the route path parameter.
        let teamID = try request.parameters.next(Int.self)
        
        // Verify that the user adding the member is part of the team they are adding the member to.
        try TeamController.assertTeam(teamID, with: request)
        
        // Make sure that a team with the ID passed in exists.
        guard let _ = try Team.find(teamID) else {
            throw Abort(.notFound, reason: "No team exists with the ID of '\(teamID)'")
        }
        
        // Get the information for creating the member from the request body.
        guard let newStatus = request.data["new_status"]?.int,
              let userID = request.data["user_id"]?.int else {
                throw Abort(.badRequest, reason: "Missing status or user ID for new member")
        }
        
        // Create the member and save it.
        let member = try TeamMember(userID: userID, teamID: teamID, status: newStatus)
        try member.save()
        
        // Return the JSON from the new member.
        return try member.makeJSON()
    }
    
    /// Get a member for a team by its ID.
    public func get(_ request: Request)throws -> ResponseRepresentable {
        return try memberAndTeam(from: request).member.makeJSON()
    }
    
    /// Remove a member from a team.
    public func delete(_ request: Request)throws -> ResponseRepresentable {
        
        // Verify that the user removing the member has an admin status in the team they are removing the member from.
        try TeamController.assertAdmin(request)
        
        // Get the member to remove and delete it from the database.
        let member = try memberAndTeam(from: request).member
        try member.delete()
        
        // Return a 200 status and a confirmation message with the ID of the member that was deleted.
        return try JSON(node: [
            "status": Status.ok.statusCode,
            "message": "Member with the ID '\(member.id?.wrapped.string ?? "null")' was removed from team"
            ])
    }
    
    // /users
    
    /// Get all the teams the user is a member of.
    public func teams(_ request: Request)throws -> ResponseRepresentable {
        
        // Get the ID of the user to get the teams for from the route path parameter.
        let userID = try request.parameters.next(Int.self)
        
        // Get the member from the database based on its user ID.
        guard let member = try TeamMember.makeQuery().filter("userId", userID).first() else {
            throw Abort(.notFound, reason: "No entries found for user ID '\(userID)'")
        }
        
        // Return all the member's teams in JSON format.
        return try member.teams().all().makeJSON()
    }
    
    // MARK: - Helpers
    
    /// Get the member and the team with the IDs in a route's parameters.
    ///
    /// - parameter request: The request with the route parameters to get the member and team.
    public func memberAndTeam(from request: Request)throws -> (member: TeamMember, team: Team) {
        // Get the team ID and member ID from the route parameters.
        let teamID = try request.parameters.next(Int.self)
        let memberID = try request.parameters.next(Int.self)
        
        // Verfiy that the member is part of the team that was pulled from the route parameters
        try TeamController.assertTeam(teamID, with: request)
        
        // Get the team based on the ID.
        guard let team = try Team.find(teamID) else {
            throw Abort(.notFound, reason: "No team exists with the ID of '\(teamID)'")
        }
        
        // Get the member from the team with the ID.
        guard let member = try team.members().find(memberID) else {
            throw Abort(.notFound, reason: "No member with the ID of '\(memberID)' exists in the specified team")
        }
        
        // Return the member and team.
        return (member: member, team: team)
    }
}
