import FluentSQLite
import Vapor
import FluentPostgreSQL

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentPostgreSQLProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a SQLite database
    //let sqlite = try SQLiteDatabase(storage: .memory)

    // Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    
    var sqlDatabaseConfig: PostgreSQLDatabaseConfig
    if let url = Environment.get("DATABASE_URL"), let databaseConfig = PostgreSQLDatabaseConfig(url: url) {
        sqlDatabaseConfig = databaseConfig
    } else {
        sqlDatabaseConfig = PostgreSQLDatabaseConfig(hostname: "localhost", port: 5432, username: "postgres", database: "movietraker")
    }

    let SQLdatabase = PostgreSQLDatabase(config: sqlDatabaseConfig)
    databases.add(database: SQLdatabase, as: .psql)
    services.register(databases)

    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Movie.self, database: .psql)
    migrations.add(model: Review.self, database: .psql)
    migrations.add(model: Cinema.self, database: .psql)
    migrations.add(model: CinemaMoviePivot.self, database: .psql)
    migrations.add(migration: UpdatingFKonCinemaMoviePivot.self, database: .psql)
    
    //migrations.add(migration: AddingDescriptionToMovies.self, database: .psql)
    //migrations.add(migration: RemovingRatingFromMovies.self, database: .psql)
    
    services.register(migrations)
}
