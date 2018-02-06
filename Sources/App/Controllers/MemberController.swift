import Vapor
import HTTP

/// The routes controller for interacting with team members.
final class MemberController: RouteCollection {
    
    // MARK: - Configuration

    /// Used for adding the routes in a `RouteCollection` to a route builder.
    /// This method is called by the `routeBuilder.collection` method.
    func boot(router: Router) throws {
        // The route builder for routes with the path `/teams/:int/members/...`
        let team = router.grouped(Int.parameter, "members")
        
        // Create a route at the path `/teams/:int/members` using the `.post` method as the handler.
        team.post(use: post)
        
        // Create a route at the path `/teams/:int/members` using the `.get` method as the handler.
        team.get(use: get)
    }
    
    // MARK: - Routes
    // /teams
    
    /// Adds a new member to a team.
    func post(_ request: Request)throws -> Future<TeamMember> {
        // Get the ID of the team to add the user to from the route path parameter.
        let teamID = try request.parameter(Int.self)
        
        // Verifiy that the user adding the member is a team admin.
        return try TeamController.assertAdmin(request).flatMap(to: Team?.self, { _ in
            
            // Verify that the user adding the member is part of the team they are adding the member to.
            try TeamController.assertTeam(teamID, with: request)
            
            // Make sure that a team with the ID passed in exists.
            return Team.find(teamID, on: request)
        }).unwrap(
            or: Abort(.notFound, reason: "No team exists with the ID of '\(teamID)'")
        ).flatMap(to: MemberData.self, { (team) in
            
            // Get the information for creating the member from the request body.
            return try request.content.decode(MemberData.self)
        }).flatMap(to: TeamMember.self, { (memberData) in
            
            // Create the member and save it.
            let member = try TeamMember(userID: memberData.userId, teamID: teamID, status: memberData.newStatus)
            return member.save(on: request)
        })
    }
    
    /// Gets all the members of a team.
    func get(_ request: Request)throws -> Future<[TeamMember]> {
        // Get the route parameter, which is the ID of the team we are getting the members from.
        let id = try request.parameter(Int.self)

        // Get the team with the ID from the route. If the user doesn't exist, abort.
        return Team.find(id, on: request).unwrap(
            or: Abort(.notFound, reason: "No team exists with the ID of '\(id)'")
        ).flatMap(to: [TeamMember].self, { (team) in
            
            // Get all the members belonging to a team and return them from the route.
            return try team.members(queriedWith: request).all()
        })
    }
    
    // /users
    
    // MARK: - Helpers
}

//    func build(_ builder: RouteBuilder) throws {
//        // The route builder for routes with the path `/teams/:int/members/...`
//        let team = builder.grouped(Int.parameter, "members")
//        
//        // The route builder for routes with the path `/teams/members/...`
//        let user = builder.grouped("member")
//        
//        // Create a route at the path `/teams/:int/members/:int` using the `.getById` method as the handler.
//        team.get(Int.parameter, handler: getById)
//        
//        // Create a route at the path `/teams/:int/members/:int` using the `.delete` method as the handler.
//        team.delete(Int.parameter, handler: delete)
//        
//        
//        // Create a route at the path `/teams/members/:int/teams` using the `.teams` method as the handler.
//        user.get(Int.parameter, "teams", handler: teams)
//    }
//    
//    /// Get a member for a team by its ID.
//    func getById(_ request: Request)throws -> ResponseRepresentable {
//        return try memberAndTeam(from: request).member.makeJSON()
//    }
//    
//    /// Remove a member from a team.
//    func delete(_ request: Request)throws -> ResponseRepresentable {
//        
//        // Verify that the user removing the member has an admin status in the team they are removing the member from.
//        try TeamController.assertAdmin(request)
//        
//        // Get the member to remove and delete it from the database.
//        let member = try memberAndTeam(from: request).member
//        try member.delete()
//        
//        // Return a 200 status and a confirmation message with the ID of the member that was deleted.
//        return try JSON(node: [
//            "status": Status.ok.statusCode,
//            "message": "Member with the ID '\(member.id?.wrapped.string ?? "null")' was removed from team"
//            ])
//    }
//    
//
//    
//    /// Get all the teams the user is a member of.
//    func teams(_ request: Request)throws -> ResponseRepresentable {
//        
//        // Get the ID of the user to get the teams for from the route path parameter.
//        let userID = try request.parameters.next(Int.self)
//        
//        // Get the member from the database based on its user ID.
//        guard let member = try TeamMember.makeQuery().filter("userId", userID).first() else {
//            throw Abort(.notFound, reason: "No entries found for user ID '\(userID)'")
//        }
//        
//        // Return all the member's teams in JSON format.
//        return try member.teams().all().makeJSON()
//    }
//    
//
//    
//    /// Get the member and the team with the IDs in a route's parameters.
//    ///
//    /// - parameter request: The request with the route parameters to get the member and team.
//    func memberAndTeam(from request: Request)throws -> (member: TeamMember, team: Team) {
//        // Get the team ID and member ID from the route parameters.
//        let teamID = try request.parameters.next(Int.self)
//        let memberID = try request.parameters.next(Int.self)
//        
//        // Verfiy that the member is part of the team that was pulled from the route parameters
//        try TeamController.assertTeam(teamID, with: request)
//        
//        // Get the team based on the ID.
//        guard let team = try Team.find(teamID) else {
//            throw Abort(.notFound, reason: "No team exists with the ID of '\(teamID)'")
//        }
//        
//        // Get the member from the team with the ID.
//        guard let member = try team.members().find(memberID) else {
//            throw Abort(.notFound, reason: "No member with the ID of '\(memberID)' exists in the specified team")
//        }
//        
//        // Return the member and team.
//        return (member: member, team: team)
//    }
//}

