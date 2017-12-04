import Fluent

extension Member: RowRepresentable {
    public func makeRow() throws -> Row {
        var row = Row()
        try row.set("user_id", self.userID)
        try row.set("status", self.status.rawValue)
        return row
    }
}
