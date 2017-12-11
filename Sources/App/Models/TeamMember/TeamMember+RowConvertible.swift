import Fluent

extension TeamMember: RowConvertible {
    public func makeRow() throws -> Row {
        var row = Row()
        
        try row.set("user_id", self.userID)
        try row.set("team_id", self.teamID)
        try row.set("status", self.status)
        
        return row
    }
    
    public convenience init(row: Row) throws {
        let userID: Int = try row.get("user_id")
        let teamID: Int = try row.get("team_id")
        let status: Int = try row.get("status")
        
        try self.init(userID: userID, teamID: teamID, status: status)
    }
}
