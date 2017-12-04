import JSON

extension Team: JSONConvertible {
    public func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("name", self.name)
        return json
    }
    
    public convenience init(json: JSON) throws {
        let name: String = try json.get("name")
        self.init(name: name)
    }
}
