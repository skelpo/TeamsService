import Fluent

/// Conforms the `TeamMember` model to `Preparation`.
/// This allows the droplet to create a table in the database for the model.
extension TeamMember: Preparation {
    public static func prepare(_ database: Database) throws {
        try database.create(self, closure: { (member) in
            
            // Create `id`, `userId`, `teamId`, and `status` columns in the `team_members` table.
            member.id()
            member.int("userId")
            member.int("teamId")
            member.int("status")
        })
    }
    
    /// Drops the tabel in the database.
    /// This method is called when you run `vapor run prepare --revert [--all] [-y]`
    public static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}
