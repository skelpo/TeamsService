import Fluent

extension Team: RowRepresentable {
    public func makeRow() throws -> Row {
        var row = Row()
        try row.set("name", self.name)
        return row
    }
}
