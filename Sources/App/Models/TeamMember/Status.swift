import FluentMySQL

/// Represents the status a member can have in a team.
/// The cases have a raw value type of `Int`.
enum MemberStatus: Int, Codable, CustomStringConvertible {
    
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

/// Conforms `MemberStatus` enum to `MySQLDataConvertible`.
extension MemberStatus: MySQLDataConvertible {
    
    /// Creates a data representation of the enum case
    /// that Fluent can store in a MySQL database.
    func convertToMySQLData() throws -> MySQLData {
        return MySQLData(integer: self.rawValue)
    }
    
    /// Creates an instance of `MemberStatus` from data
    /// fetched from a MySQL database.
    ///
    /// - Parameter mysqlData: The data used to get the enum case.
    ///
    /// - Returns: The enum case with a raw value matching the integer
    ///   pulled from the data passed in.
    /// - Throws: `FluentError.badRawType` if the data passed in is not an integer
    ///   and `MemberError.invalidRawValue` if the enum does not have a case with a raw
    ///   value equal to the integer poulled from the MySQL data.
    static func convertFromMySQLData(_ mysqlData: MySQLData) throws -> MemberStatus {
        guard let rawValue = try mysqlData.integer(Int.self) else {
            throw FluentError(identifier: "badRawType", reason: "Attempted to use incorrect type to create a MemberStatus. Use an Int.", source: .capture())
        }
        guard let status = MemberStatus(rawValue: rawValue) else {
            throw MemberError(identifier: "invalidRawValue", reason: "Attempted to create a MemberStatus from an invalid raw value \(rawValue)", status: .internalServerError)
        }
        return status
    }
}
