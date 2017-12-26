import Fluent

/// Conforms the `Team` model to Preparation.
extension Team: Preparation {
    
    /// Creates a `teams` tabel in the database.
    /// This method gets called automaticly by the droplet when you boot your application
    static func prepare(_ database: Database) throws {
        try database.create(self, closure: { (team) in
            
            // Create `id` and `name` columns
            team.id()
            team.string("name")
        })
    }
    
    /// Drops the tabel in the database.
    /// This method is called when you run `vapor run prepare --revert [--all] [-y]`
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}
