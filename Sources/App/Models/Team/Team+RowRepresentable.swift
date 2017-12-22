import Fluent

/// Conformes the `Team` model to `RowRepresentable`.
extension Team: RowRepresentable {
    
    /// Creates a `Row` from the model so Fluent can store the model in the database.
    /// Very rarely, if ever, will you have to call this method directly.
    public func makeRow() throws -> Row {
        
        // Create a row, set the name property, and return it.
        var row = Row()
        try row.set("name", self.name)
        return row
    }
}
