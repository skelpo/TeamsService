import Vapor
import FluentMySQL

/// Represents any kind of team.
/// A JWT payload contains the Team IDs that a user is a member of.
final class Team: Content {
    
    /// The name of the team.
    let name: String
    
    /// The ID row that holds the representation of the model on the database
    /// This property is a varible because Fluent has to be able to mutate it
    /// (from `nil` to `n`).
    var id: Int?
    
    /// Creates a new team with a given name.
    /// - Note: The team is _not_ save to the database with this method.
    init(name: String) {
        self.name = name
    }
    
    /// Creates a `QueryBuilder` that gets all the members that belong to the team.
    func members(queriedWith connectable: DatabaseConnectable)throws -> QueryBuilder<TeamMember, TeamMember> {
        return try TeamMember.query(on: connectable).filter(\TeamMember.teamID == self.requireID())
    }
}

/// Conforms the `Team` class to the `Model` protocol.
/// The `MySQLModel` protocol requires a property `id` of type `Int`
/// and that the `Database` type is equal to `MySQLDatabase`.
extension Team: MySQLModel {}

/// Conforms the `Team` class to the `Migration` protocol.
/// This allows Fluent to create the table for the model in the database.
extension Team: Migration {}
