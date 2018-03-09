/// Errors that occur when interacting with the `Team` model.
enum TeamError: Error, CustomStringConvertible {
    
    /// Thrown when no team is found with an ID that a user is a member of.
    case noTeamForID(Int)
    
    /// Thrown when you attempt to access the ID of a `TeamMember` model
    /// that was not saved to the database
    case notSaved
    
    /// API friendly versions of the error.
    /// `APIErrorMiddleware` uses this property to generate the error JSON.
    var description: String {
        switch self {
        case let .noTeamForID(id): return "No team was found with the ID '\(id)'"
        case .notSaved: return "The member you attempted to access is not saved to the database"
        }
    }
}
