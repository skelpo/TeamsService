import FluentProvider

public final class Member: Model {
    public let storage: Storage = Storage()
    
    public let userID: Int
    public let status: MemberStatus
    
    public init(userID id: Int, status: MemberStatus) {
        self.userID = id
        self.status = status
    }
    
    public convenience init(userID id: Int, status: Int = 1)throws {
        guard let memberStatus = MemberStatus(rawValue: status) else {
            throw MemberError.undefinedMemberStatus(status)
        }
        self.init(userID: id, status: memberStatus)
    }
}
