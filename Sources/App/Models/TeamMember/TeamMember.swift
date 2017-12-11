import FluentProvider

public final class TeamMember: Model {
    public let storage: Storage = Storage()
    
    public let userID: Int
    public let teamID: Int
    public let status: Int
    
    public init(userID: Int, teamID: Int, status: MemberStatus) {
        self.userID = userID
        self.teamID = teamID
        self.status = status.rawValue
    }
    
    public convenience init(userID: Int, teamID: Int, status: Int)throws {
        guard let memberStatus = MemberStatus(rawValue: status) else {
            throw MemberError.undefinedMemberStatus(status)
        }
        self.init(userID: userID, teamID: teamID, status: memberStatus)
    }
}
