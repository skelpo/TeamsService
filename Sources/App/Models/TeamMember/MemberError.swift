public enum MemberError: Error, CustomStringConvertible {
    case undefinedMemberStatus(Int)
    
    public var description: String {
        switch self {
        case let .undefinedMemberStatus(status): return "No member status exists with the int value '\(status)'"
        }
    }
}
