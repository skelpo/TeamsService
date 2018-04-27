import Vapor
import SkelpoMiddleware
import Fluent

/// The route controller for interacting with the teams.
final class TeamController: RouteCollection {
    // MARK: - Configuration

    /// Used for adding the routes in a `RouteCollection` to a route builder.
    /// This method is called by the `routeBuilder.collection` method.
    func boot(router: Router) throws {
        // Create a route at the path `/teams` using `.post` as the route handler.
        router.post(use: post)
        
        // Create a route at the path `/teams` using `.all` as the route handler.
        router.get(use: all)
        
        // Create a route at the path `/teams/:int` using `.getWithID` as the route handler.
        router.get(Int.parameter, use: getWithID)
        
        // Create a route at the path `/teams/:int` using `.delete` as the route handler.
        router.delete(Int.parameter, use: delete)
    }
    
    // MARK: - Routes

    /// The route handler for creating a new team.
    func post(_ request: Request)throws -> Future<TeamCreatedResponse> {
        
        // Decode the request's body to a `Team` object.
        return try request.content.decode(Team.self).flatMap(to: Team.self, { (team) in
            // Save the team to the data base and continue to the next promise closure.
            return team.save(on: request)
        }).flatMap(to: Team.self, { (team) in
            // Get the team's database ID.
            guard let teamId = team.id else {
                
                // The save somehow failed. Abort.
                throw Abort(.internalServerError, reason: "Team was not saved to the database")
            }
            
            // Get the ID of the user that made the request from the access token's payload
            let user = try request.payload(as: Payload.self).id
            
            // Store the new team ID with the rest of the IDs,
            // so the user doesn't have to re-authenticate to access the team
            var teams = try request.teams()
            teams.append(teamId)
            try request.teams(teams)
            
            // Create and save the user as an admin member of the new team.
            let member = TeamMember(userID: user, teamID: teamId, status: .admin)
            return member.save(on: request).transform(to: team)
        }).map(to: TeamCreatedResponse.self, { (team) in
            
            // Return the team that was created and a human readable message requesting the client to re-authenticate.
            return TeamCreatedResponse(message: "You should re-authenticate so you can access the team you just created", team: team)
        })
    }
    
    /// A route handler for getting all the teams a user belongs to.
    func all(_ request: Request)throws -> Future<[Team]> {
        // Get the IDs of the teams the user belongs to.
        let ids = try request.teams()

        // Get all the teams that have an ID in the `ids` array and return them.
        return try Team.query(on: request).filter(\Team.id ~~ ids).all()
    }
    
    /// A route handler for getting a team with a specefied ID.
    func getWithID(_ request: Request)throws -> Future<Team> {
        // Get the ID of the team to get from the route parameters.
        let id = try request.parameters.next(Int.self)

        // Verify that the user is a member of the team they are getting.
        try TeamController.assertTeam(id, with: request)
        
        // Get the team from the database by it's ID and return it if it exists, otherwise abort.
        return try Team.find(id, on: request).unwrap(or: Abort(.notFound, reason: "No team exists with the id of '\(id)'"))
    }
    
    /// A route handler for deleting a team.
    func delete(_ request: Request)throws -> Future<ModelDeletedResponse> {
        // Get the ID of the team to delete from the route parameters.
        let teamID = try request.parameters.next(Int.self)
        
        // Verify that the user tying to delete the team is an admin member in the team.
        return try TeamController.assertAdmin(request).flatMap(to: Team?.self, { _ in
            
            // Verify that the user is a member of the team they are trying to delete.
            try TeamController.assertTeam(teamID, with: request)
            
            // Get team with the ID fetch from the route parameters.
            return try Team.find(teamID, on: request)
        }).unwrap(
            or: Abort(.notFound, reason: "No team exists with the ID of '\(teamID)'")
        ).flatMap(to: String.self, { (team) in
            
            // Delete the team and all its members.
            try TeamMember.query(on: request).filter(\TeamMember.teamID == team.requireID())
            return team.delete(on: request).transform(to: team.name)
        }).map(to: ModelDeletedResponse.self, { (name) in
            
            // Return a JSON object with a 204 status code and confirmation message.
            return ModelDeletedResponse(message: "Team '\(name)' was deleted")
        })
    }
    
    // MARK: - Helpers

    /// Verifies that a team ID is in the IDs containd in the JWT payload.
    ///
    /// - Parameters:
    ///   - team: The ID to check.
    ///   - request: The request with the IDs to check against.
    /// - Returns: The teams contained in the request. This method is annotated with `@discardableResult`, so the returned value can be ignored.
    /// - Throws: `Abort(.notFound, reason: "Team not found for user")` if the IDs in the payload does not contain the ID passed in.
    @discardableResult
    static func assertTeam(_ team: Int, with request: Request)throws -> [Int] {
        let teams = try request.teams()
        guard teams.contains(team) else {
            throw Abort(.notFound, reason: "Team not found for user")
        }
        return teams
    }

    /// Verify that the request was sent by an administrator of the team. This is done by checking the `status` key in the request body.
    ///
    /// - Parameter request: The request to get the status from.
    /// - Throws: `Abort(.forbidden, reason: "User doers not have required privileges")` if the status is missing or incorrect.
    static func assertAdmin(_ request: Request)throws -> Future<Void> {
        return try request.content.decode([String: MemberStatus].self).map(to: Void.self, { (statuses) in
            guard let status = statuses["status"] else {
                throw Abort(.badRequest, reason: "No 'status' value was found")
            }
            guard status == .admin else {
                throw Abort(.forbidden, reason: "User doers not have required privileges")
            }
        })
    }
}
