import Fluent

extension TeamMember: RowConvertible {
    public func makeRow() throws -> Row {
        var row = Row()
        
        try row.set("userId", self.userID)
        try row.set("teamId", self.teamID)
        try row.set("status", self.status)
        
        return row
    }
    
    public convenience init(row: Row) throws {
        let userID: Int = try row.get("userId")
        let teamID: Int = try row.get("teamId")
        let status: Int = try row.get("status")
        
        try self.init(userID: userID, teamID: teamID, status: status)
    }
}
