import Fluent

extension Team: Preparation {
    public static func prepare(_ database: Database) throws {
        try database.create(self, closure: { (team) in
            team.id()
            team.string("name")
        })
    }
    
    public static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}
