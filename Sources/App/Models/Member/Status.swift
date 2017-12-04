public enum MemberStatus: Int, CustomStringConvertible {
    case admin
    case standard
    
    public var description: String {
        switch self {
        case .admin: return "admin"
        case .standard: return "standard"
        }
    }
}
