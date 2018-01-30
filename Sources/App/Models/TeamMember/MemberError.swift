/// Errors that can occur when interacting with the `TeamMember` model.
enum MemberError: Error, CustomStringConvertible {
    
    /// Thrown when an attempt is made to create a user with a status that does not exist.
    case undefinedMemberStatus(Int)
    
    /// Thrown when you attempt to access the ID of a `TeamMember` model
    /// that was not saved to the database
    case notSaved
    
    /// An API friendly versions of the error.
    /// `APIErrorMiddleware` uses this property to generate the error JSON.
    var description: String {
        switch self {
        case let .undefinedMemberStatus(status): return "No member status exists with the int value '\(status)'"
        case .notSaved: return "The member you attempted to access is not saved to the database"
        }
    }
}
