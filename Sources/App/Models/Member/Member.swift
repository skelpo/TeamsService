import FluentProvider

public final class Member {
    let storage: Storage = Storage()
    
    let userID: Int
    let status: MemberStatus
    
    public init(userID id: Int, status: MemberStatus) {
        self.userID = id
        self.status = status
    }
}
