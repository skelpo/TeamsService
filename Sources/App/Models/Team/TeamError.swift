/// Errors that occur when interacting with the `Team` model.
public enum TeamError: Error, CustomStringConvertible {
    
    /// Thrown when no team is found with an ID that a user is a member of.
    case noTeamForID(Int)
    
    /// API friendly versions of the error.
    /// `APIErrorMiddleware` uses this property to generate the error JSON.
    public var description: String {
        switch self {
        case let .noTeamForID(id): return "No team was found with the ID '\(id)'"
        }
    }
}
