import Fluent

extension TeamMember: Preparation {
    public static func prepare(_ database: Database) throws {
        try database.create(self, closure: { (member) in
            member.id()
            member.int("user_id")
            member.int("team_id")
            member.int("status")
        })
    }
    
    public static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}
