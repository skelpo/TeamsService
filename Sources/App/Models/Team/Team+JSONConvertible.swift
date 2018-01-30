/// Conformes the `Team` model to `JSONConvertible`.
extension Team: JSONConvertible {
    
    /// Creates a JSON representation of the model instance.
    func makeJSON() throws -> JSON {
        // Create the JSON instance and get all the team's members
        var json = JSON()
        let members: [TeamMember] = try self.members().all()
        
        // Set the `id`, `name`, and `members` JSON keys
        try json.set("id", self.id?.wrapped)
        try json.set("name", self.name)
        try json.set("members", members.makeJSON())
        
        // Return the JSON
        return json
    }
    
    /// Creates an instance of `Team` from a JSON object.
    convenience init(json: JSON) throws {
        // Get the team's name from the JSON
        let name: String = try json.get("name")
        
        // Create the team.
        self.init(name: name)
    }
}
