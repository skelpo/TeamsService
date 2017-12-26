import Fluent

/// `Team` model heplers for interacting with the `teams` database table.
extension Team {
    
    /// Creates a query that gets all the members that belong to the team.
    func members()throws -> Query<TeamMember> {
        return try TeamMember.makeQuery().filter("teamId", self.id)
    }
}
