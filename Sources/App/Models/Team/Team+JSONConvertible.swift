import JSON

extension Team: JSONConvertible {
    public func makeJSON() throws -> JSON {
        var json = JSON()
        let children: [Member] = try self.children().all()
        
        try json.set("name", self.name)
        try json.set("members", children.makeJSON())
        return json
    }
    
    public convenience init(json: JSON) throws {
        let name: String = try json.get("name")
        self.init(name: name)
    }
}
