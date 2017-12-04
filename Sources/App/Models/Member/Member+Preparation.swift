import Fluent

extension Member: Preparation {
    public static func prepare(_ database: Database) throws {
        try database.create(self, closure: { (member) in
            member.id()
            member.int("user_id")
            member.int("status")
            member.parent(Team.self)
        })
    }
    
    public static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}
