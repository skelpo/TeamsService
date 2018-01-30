import Vapor
import HTTP
import SkelpoMiddleware

/// The route controller for interacting with the teams.
final class TeamController: RouteCollection, EmptyInitializable {
    
    /// This initializer is here so the controller can conform to the `EmptyInitializable` protocol.
    init() {}
    
    // MARK: - Configuration
    
    /// Used for adding the routes in a `RouteCollection` to a route builder.
    /// This method is called by the `routeBuilder.collection` method.
    func build(_ builder: RouteBuilder) throws {
        
        // Create a route at the path `/teams` using `.all` as the route handler.
        builder.get(handler: all)
        
        // Create a route at the path `/teams` using `.post` as the route handler.
        builder.post(handler: post)
        
        // Create a route at the path `/teams/:int` using `.getWithID` as the route handler.
        builder.get(Int.parameter, handler: getWithID)
        
        // Create a route at the path `/teams/:int` using `.delete` as the route handler.
        builder.delete(Int.parameter, handler: delete)
    }
    
    // MARK: - Route
    
    /// The route handler for creating a new team.
    func post(_ request: Request)throws -> ResponseRepresentable {
        // Get the name that will be for the new Team.
        guard let name = request.data["name"]?.string else {
            throw Abort(.badRequest, reason: "Missing 'name' paramater in request data")
        }
        
        // Create the team and save it.
        let team = Team(name: name)
        try team.save()
        
        // Get the ID of the new team.
        guard let teamID = team.id?.wrapped.int else {
            throw Abort(.internalServerError, reason: "Team was not saved to the database")
        }
        
        // Get the ID of the user who created the team.
        let userID: Int = try request.payload().get("id")
        
        // Create a member for the team with the user ID and amdin status, then save it.
        let member = TeamMember(userID: userID, teamID: teamID, status: .admin)
        try member.save()
        
        // Save the teams the that the user is a member of in the sessions.
        // This allows the user to access the team that was just create without getting a new access token.
        var teams = try request.teams()
        teams.append(teamID)
        try request.teams(teams)
        
        // Return a JSON object with a re-authentication message and the team that was just created.
        return try JSON(node: [
                "message": "You should re-authenticate so you can access the team you just created",
                "team": team
            ])
    }
    
    /// A route handler for getting all the teams a user belongs to.
    func all(_ request: Request)throws -> ResponseRepresentable {
        // Get the IDs of the teams the user belongs to.
        let ids = try request.teams()
        
        // Get all the teams that have an ID in the `ids` array.
        let teams = try Team.makeQuery().filter("id", in: ids).all()
        
        // Return the teams in JSON format.
        return try teams.makeJSON()
    }
    
    /// A route handler for getting a team with a specefied ID.
    func getWithID(_ request: Request)throws -> ResponseRepresentable {
        // Get the ID of the team to get from the route parameters.
        let id = try request.parameters.next(Int.self)
        
        // Verify that the user is a member of the team they are getting.
        try TeamController.assertTeam(id, with: request)
        
        // Get the team from the data base and convert it to JSON.
        guard let team = try Team.find(id)?.makeJSON() else {
            throw Abort(.notFound, reason: "No team exists with the id of '\(id)'")
        }
        
        // Return the JSON object.
        return team
    }
    
    /// A route handler for deleting a team.
    func delete(_ request: Request)throws -> ResponseRepresentable {
        // Verify that the user tying to delete the team is an admin member in the team.
        try TeamController.assertAdmin(request)
        
        // Get the ID of the team to delete from the route parameters.
        let teamID = try request.parameters.next(Int.self)
        
        // Verify that the user is a member of the team they are trying to delete.
        try TeamController.assertTeam(teamID, with: request)
        
        // Get the team from the database with the `teamID`.
        guard let team = try Team.find(teamID) else {
            throw Abort(.notFound, reason: "No team exists with the ID of '\(teamID)'")
        }
        
        // Delete the team and all its members.
        try TeamMember.makeQuery().filter("teamId", team.id).delete()
        try team.delete()
        
        // Return a JSON object with a 200 status code and confirmation message.
        return try JSON(node: [
                "status": Status.ok.statusCode,
                "message": "Team '\(team.name)' was deleted"
            ])
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
    static func assertAdmin(_ request: Request)throws {
        guard let status = request.data["status"]?.int,
            MemberStatus(rawValue: status) == .admin else {
                throw Abort(.forbidden, reason: "User doers not have required privileges")
        }
    }
}
