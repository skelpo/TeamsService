import FluentMySQL
import Vapor

extension DatabaseIdentifier {
    
    /// Not really sure what this is for, but you need it.
    static var mysql: DatabaseIdentifier<MySQLDatabase> {
        return .init("mysql")
    }
}
