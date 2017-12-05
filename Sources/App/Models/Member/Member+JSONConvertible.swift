import JSON

extension Member: JSONConvertible {
    public func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("id", self.id?.wrapped)
        try json.set("user_id", self.userID)
        try json.set("status", self.status.rawValue)
        try json.set("status_name", self.status.description)
        return json
    }
    
    public convenience init(json: JSON) throws {
        let id: Int = try json.get("user_id")
        let status: Int = try json.get("status")
        try self.init(userID: id, status: status)
    }
}
