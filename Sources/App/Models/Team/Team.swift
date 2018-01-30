import FluentMySQL

/// Represents any kind of team.
/// A JWT payload contains the Team IDs that a user is a member of.
final class Team: Model {
    
    /// The name of the team.
    let name: String
    
    /// Creates a new team with a given name.
    /// - Note: The team is _not_ save to the database with this method.
    init(name: String) {
        self.name = name
    }
}
