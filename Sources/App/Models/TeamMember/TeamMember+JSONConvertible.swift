import JSON

extension TeamMember: JSONConvertible {
    public func makeJSON() throws -> JSON {
        var json = JSON()
        
        try json.set("id", self.id?.wrapped)
        try json.set("user_id", self.userID)
        try json.set("status", self.status)
        try json.set("status_name", self.status)
        
        return json
    }
    
    public convenience init(json: JSON) throws {
        let userID: Int = try json.get("user_id")
        let teamID: Int = try json.get("team_id")
        let status: Int = try json.get("status")
        
        try self.init(userID: userID, teamID: teamID, status: status)
    }
}
