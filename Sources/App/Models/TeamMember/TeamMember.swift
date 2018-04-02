import Vapor
import FluentMySQL

/// Represents a member for a team.
final class TeamMember: Content {
    
    /// The ID row that holds the representation of the model on the database
    /// This property is a varible because Fluent has to be able to mutate it
    /// (from `nil` to `n`).
    var id: Int?
    
    /// The ID of the user that model represents.
    let userID: Int
    
    /// The ID of the team that the user is a member of.
    let teamID: Int
    
    /// The status the member holds in the team ('admin' or 'standard').
    let status: MemberStatus
    
    
    /// Creates a `TeamMember` with the neccesary information.
    ///
    /// - Parameters:
    ///  - userID: The ID of the user that will be a member of a team.
    ///  - teamID: The ID of the team the user will be a member of.
    ///  - status: The status the member will hold in the team.
    ///
    /// - Note: This initializer will not save the member to the database.
    init(userID: Int, teamID: Int, status: MemberStatus) {
        self.userID = userID
        self.teamID = teamID
        self.status = status
    }
    
    /// Creates a `TeamMember` with the neccesary information.
    ///
    /// - Parameters:
    ///  - userID: The ID of the user that will be a member of a team.
    ///  - teamID: The ID of the team the user will be a member of.
    ///  - status: The raw value of the status the member will hold in the team.
    /// - Throws: `MemberError.undefinedMemberStatus` if a bad status value is passed in.
    ///
    /// - Note: This initializer will not save the member to the database.
    convenience init(userID: Int, teamID: Int, status: Int)throws {
        guard let memberStatus = MemberStatus(rawValue: status) else {
            throw MemberError(identifier: "undefinedMemberStatus", reason: "No member status exists with the int value '\(status)'", status: .notFound)
        }
        self.init(userID: userID, teamID: teamID, status: memberStatus)
    }
    
    /// Create a `QueryBuilder` that gets all the teams that the member is a part of.
    func teams(queriedWith connectable: DatabaseConnectable)throws -> QueryBuilder<Team, Team> {
        return try Team.query(on: connectable).join(field: \TeamMember.teamID).filter(TeamMember.self, \.userID == userID)
    }
}

/// Conforms the `TeamMember` class to the `Model` protocol.
/// The `MySQLModel` protocol requires a property `id` of type `Int`
/// and that the `Database` type is equal to `MySQLDatabase`.
extension TeamMember: MySQLModel {}

/// Conforms the `TeamMember` class to the `Migration` protocol.
/// This allows Fluent to create the table for the model in the database.
extension TeamMember: Migration {}
