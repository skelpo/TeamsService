public enum TeamError: Error, CustomStringConvertible {
    case noTeamForID(Int)
    
    public var description: String {
        switch self {
        case let .noTeamForID(id): return "No team was found with the ID '\(id)'"
        }
    }
}
