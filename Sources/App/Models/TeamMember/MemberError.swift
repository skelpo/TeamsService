/// Errors that can occur when interacting with the `TeamMember` model.
enum MemberError: Error, CustomStringConvertible {
    
    /// Thrown when an attempt is made to create a user with a status that does not exist.
    case undefinedMemberStatus(Int)
    
    /// An API friendly versions of the error.
    /// `APIErrorMiddleware` uses this property to generate the error JSON.
    var description: String {
        switch self {
        case let .undefinedMemberStatus(status): return "No member status exists with the int value '\(status)'"
        }
    }
}
