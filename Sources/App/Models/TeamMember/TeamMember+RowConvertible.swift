import Fluent

/// Conforms the `TeamMember` model to `RowConvertible`.
extension TeamMember: RowConvertible {
    
    /// Creates a `Row` from the model so Fluent can store it in the database.
    func makeRow() throws -> Row {
        // Create a row.
        var row = Row()
        
        // Set the `userId`, `teamId`, and `status` columns in the database row.
        try row.set("userId", self.userID)
        try row.set("teamId", self.teamID)
        try row.set("status", self.status)
        
        // return the row.
        return row
    }
    
    /// Creates a model from a `Row`.
    /// This initializer is used to create an intance of the `TeamMember` model wih data stored in the database.
    convenience init(row: Row) throws {
        
        // Get the required data from the row
        let userID: Int = try row.get("userId")
        let teamID: Int = try row.get("teamId")
        let status: Int = try row.get("status")
        
        // Create an instance of `TeamMember`.
        try self.init(userID: userID, teamID: teamID, status: status)
    }
}
