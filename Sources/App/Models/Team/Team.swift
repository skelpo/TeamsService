import FluentProvider

/// Represents any kind of team.
/// A JWT payload contains the Team IDs that a user is a member of.
public final class Team: Model {
    
    /// Used by Fluent to store metadata for the model in the database.
    public let storage: Storage = Storage()
    
    /// The name of the team.
    public let name: String
    
    /// Creates a new team with a given name.
    /// - Note: The team is _not_ save to the database with this method.
    public init(name: String) {
        self.name = name
    }
    
    /// Creates a team from a `Row`.
    /// This initializer is used to create a team from information stored in a database.
    public init(row: Row) throws {
        self.name = try row.get("name")
    }
}
