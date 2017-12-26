import JSON

/// Conforms the `TeamMember` model to `JSONConvertible`.
extension TeamMember: JSONConvertible {
    
    /// Creates a JSON representation of the model
    func makeJSON() throws -> JSON {
        
        // Create a JSON object and the name of the status that the member is.
        var json = JSON()
        guard let statusName = MemberStatus(rawValue: status)?.description else {
            throw MemberError.undefinedMemberStatus(status)
        }
        
        // Set the `id`, `user_id`, `status`, and `status_name`.
        try json.set("id", self.id?.wrapped)
        try json.set("user_id", self.userID)
        try json.set("status", self.status)
        try json.set("status_name", statusName)
        
        // Return the JSON.
        return json
    }
    
    /// Creates an instance of the `TeamMember` model with a JSON object.
    convenience init(json: JSON) throws {
        
        // Get the neccesary inrofmation from the JSON.
        let userID: Int = try json.get("user_id")
        let teamID: Int = try json.get("team_id")
        let status: Int = try json.get("status")
        
        // Create the member.
        try self.init(userID: userID, teamID: teamID, status: status)
    }
}
