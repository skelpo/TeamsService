import Fluent

/// `TeamMember` model heplers for interacting with the `team_memberss` database table.
extension TeamMember {
    
    /// Create a query that gets all the teams that the member is a part of.
    func teams()throws -> Query<Team> {
        
        // Get all the IDs of the teams the user is part of.
        let ids = try TeamMember.makeQuery().filter("userId", self.userID).all().map({ $0.teamID })
        
        // Get all the teams that have an ID in the `ids` array.
        return try Team.makeQuery().filter("id", in: ids)
    }
}
