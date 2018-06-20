import FluentMySQL

/// Represents the status a member can have in a team.
/// The cases have a raw value type of `Int`.
enum MemberStatus: Int, MySQLEnumType, CustomStringConvertible {
    
    static func reflectDecoded() throws -> (MemberStatus, MemberStatus) {
        return (.admin, .standard)
    }
    
    /// Defines that the user is an admin in the team.
    /// An admin can add and remove users, and delete the team.
    /// This case has a raw value of '0'.
    case admin
    
    /// Defines that the user is a standard team member without any admin privlidges.
    /// This case has a raw value of '1'.
    case standard
    
    /// A string representation of the status ('admin' and 'standard').
    var description: String {
        switch self {
        case .admin: return "admin"
        case .standard: return "standard"
        }
    }
}
