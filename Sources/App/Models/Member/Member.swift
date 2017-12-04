import FluentProvider

public final class Member: Model {
    public let storage: Storage = Storage()
    
    public let userID: Int
    public let status: MemberStatus
    public let teamID: Identifier?
    
    public init(userID id: Int, status: MemberStatus, team: Team?) {
        self.userID = id
        self.status = status
        self.teamID = team?.id
    }
    
    public convenience init(userID id: Int, status: Int, team: Team? = nil)throws {
        guard let memberStatus = MemberStatus(rawValue: status) else {
            throw MemberError.undefinedMemberStatus(status)
        }
        self.init(userID: id, status: memberStatus, team: team)
    }
    
    public convenience init(row: Row) throws {
        let id: Int = try row.get("user_id")
        let status: Int = try row.get("status")
        let team: Team = try row.get(Team.foreignIdKey)
        try self.init(userID: id, status: status, team: team)
    }
}
