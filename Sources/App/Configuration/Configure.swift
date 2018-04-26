import Vapor
import JWTVapor
import FluentMySQL
import VaporRequestStorage

/// Configures the services that will be used in the application.
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    
    // Configure the JWT signer used to verify and sign tokens.
    // In this case, we are using RSA.
    // We can sign tokens because we are using a private key
    // (the `d` value must be used to create a private key)
    let jwt = JWTProvider { (n) in
        guard let d = Environment.get("REVIEWSENDER_JWT_D") else {
            throw Abort(.internalServerError, reason: "Unable to find environment variable `REVIEWSENDER_JWT_D`", identifier: "envVarMissing")
        }
        
        let header = JWTHeader(alg: "RS256", crit: ["exp", "aud"], kid: "reviewsender")
        return try RSAService(n: n, e: "AQAB", d: d, header: header)
    }
    
    // Register the Fluent, FluentMySQL, Storage, and JWT providers.
    // This configures migrations and the database connection.
    try services.register(jwt)
    try services.register(FluentProvider())
    try services.register(StorageProvider())
    try services.register(FluentMySQLProvider())
    
    // Create a router, register the application's routes with it,
    // register the router with the application's services.
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    // Create the database config.
    var dbConfig = DatabasesConfig()
    
    // Setup the connection to the database.
    let config = MySQLDatabaseConfig(hostname: "localhost", port: 3306, username: "root", password: "password", database: "service_teams")
    let database = MySQLDatabase(config: config)
    dbConfig.add(database: database, as: .mysql)
    services.register(dbConfig)
    
    // Add the models to the migration config so tables are create for them.
    var migirateConfig = MigrationConfig()
    migirateConfig.add(model: Team.self, database: .mysql)
    migirateConfig.add(model: TeamMember.self, database: .mysql)
    services.register(migirateConfig)
}
