import Vapor
import FluentMySQL
import SkelpoMiddleware

/// Configures the services that will be used in the application.
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    
    // Register the Fluent and FluentMySQL providers.
    // This configures migrations and the database connection.
    try services.register(FluentProvider())
    try services.register(FluentMySQLProvider())
    try services.register(SkelpoMiddleware.Provider())
    
    // Create the database config.
    var dbConfig = DatabaseConfig()
    
    // Setup the connection to the database.
    let database = MySQLDatabase(hostname: "localhost", user: "root", password: nil, database: "service_teams")
    dbConfig.add(database: database, as: .mysql)
    services.register(dbConfig)
    
    // Add the models to the migration config so tables are create for them.
    var migirateConfig = MigrationConfig()
    migirateConfig.add(model: Team.self, database: .mysql)
    migirateConfig.add(model: TeamMember.self, database: .mysql)
    services.register(migirateConfig)
}
