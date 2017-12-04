import FluentProvider

public final class Team: Model {
    public let storage: Storage = Storage()
    
    public let name: String
    
    public init(name: String) {
        self.name = name
    }
    
    public init(row: Row) throws {
        self.name = try row.get("name")
    }
}
