import FluentProvider

public final class Team {
    public let storage: Storage = Storage()
    
    public let name: String
    
    public init(name: String) {
        self.name = name
    }
}
