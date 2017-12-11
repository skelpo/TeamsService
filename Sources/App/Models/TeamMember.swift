import FluentProvider

public final class TeamMember {
    public let storage: Storage = Storage()
    
    public let userID: Int
    public let teamID: Int
    public let status: Int
    
    public init(userID: Int, teamID: Int, status: Int) {
        self.userID = userID
        self.teamID = teamID
        self.status = status
    }
    
    public init(userID: Int, teamID: Int, status: MemberStatus) {
        self.userID = userID
        self.teamID = teamID
        self.status = status.rawValue
    }
}
