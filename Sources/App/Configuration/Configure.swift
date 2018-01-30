import Vapor
import FluentMySQL

public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
    ) throws {
    try services.register(FluentProvider())
    try services.register(FluentMySQLProvider())
    
    var dbConfig = DatabaseConfig()
    let database = MySQLDatabase(hostname: "localhost", user: "root", password: nil, database: "service_teams")
    dbConfig.add(database: database, as: .mysql)
    services.register(dbConfig)
    
    var migirateConfig = MigrationConfig()
    services.register(migirateConfig)
}
