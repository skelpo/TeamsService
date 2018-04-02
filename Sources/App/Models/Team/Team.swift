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
        guard let id = self.id else {
            throw TeamError.notSaved
        }
        return try TeamMember.query(on: connectable).filter(\TeamMember.teamID == id)
    }
}

/// Conforms the `Team` class to the `Model` protocol.
/// When you conform a class to `Model` in an extention,
/// the class must already conform to `Codable`.
extension Team: Model {
    // The key path to the model's `id` property.
    static var idKey: WritableKeyPath<Team, Int?> {
        return \.id
    }
    
    /// The database type that is used to store the model.
    typealias Database = MySQLDatabase
}

/// Conforms the `Team` class to the `Model` protocol.
/// This allows Fluent to create the table for the model in the database.
extension Team: Migration {}
