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
    let status: Int
    
    
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
        self.status = status.rawValue
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
            throw MemberError.undefinedMemberStatus(status)
        }
        self.init(userID: userID, teamID: teamID, status: memberStatus)
    }
    
    /// Create a `QueryBuilder` that gets all the teams that the member is a part of.
    func teams()throws -> QueryBuilder<Team> {
        
        // Get all the IDs of the teams the user is part of.
        let ids = try TeamMember.makeQuery().filter("userId", self.userID).all().map({ $0.teamID })
        
        // Get all the teams that have an ID in the `ids` array.
        return try Team.makeQuery().filter("id", in: ids)
    }
}

/// Conforms the `TeamMember` class to the `Model` protocol.
/// When you conform a class to `Model` in an extention,
/// the class must already conform to `Codable`.
extension TeamMember: Model {
    // The key path to the model's `id` property.
    static var idKey: ReferenceWritableKeyPath<TeamMember, Int?> {
        return \.id
    }
    
    /// The database type that is used to store the model.
    typealias Database = MySQLDatabase
}

/// Conforms the `TeamMember` class to the `Model` protocol.
/// This allows Fluent to create the table for the model in the database.
extension TeamMember: Migration {}
