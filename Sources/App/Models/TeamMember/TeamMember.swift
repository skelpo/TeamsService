import Vapor
import FluentMySQL

/// Represents a member for a team.
final class TeamMember: Content, MySQLModel, Migration {
    
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
    func teams(queriedWith connectable: DatabaseConnectable) -> QueryBuilder<Team.Database, Team> {
        return Team.query(on: connectable).join(\TeamMember.teamID, to: \Team.id).filter(\TeamMember.userID == userID)
    }
}
