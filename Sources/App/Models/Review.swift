//
//  Review.swift
//  App
//
//  Created by Julio Collado on 5/19/20.
//

import Vapor
import FluentPostgreSQL

final class Review: Content {
    typealias Database = PostgreSQLDatabase
    
    var id: Int?
    var rating: Int
    var body: String
    var movieId: Movie.ID
}

extension Review: PostgreSQLModel {
    static var entity: String = "Reviews"
}

extension Review: Migration {
    ///Adding a Foreign key
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.movieId, to: \Movie.id)
        }
    }
}

extension Review: Parameter {}

extension Review {
    var movie: Parent<Review, Movie> {
        return parent(\.movieId)
    }
}
