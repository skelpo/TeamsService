import JSON

extension Team: JSONConvertible {
    public func makeJSON() throws -> JSON {
        var json = JSON()
        let members: [Member] = try self.members.all()
        
        try json.set("name", self.name)
        try json.set("members", members.makeJSON())
        return json
    }
    
    public convenience init(json: JSON) throws {
        let name: String = try json.get("name")
        self.init(name: name)
    }
}
