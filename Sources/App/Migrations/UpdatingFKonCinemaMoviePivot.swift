//
//  19-05-2020-UpdatingFKonCinemaMoviePivot.swift
//  App
//
//  Created by Julio Collado on 5/20/20.
//

import Vapor
import FluentPostgreSQL

struct UpdatingFKonCinemaMoviePivot: Migration {
    typealias Database = PostgreSQLDatabase
    
    static func prepare(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return Database.update(CinemaMoviePivot.self, on: conn) { builder in
            builder.reference(from: \.cinemaId, to: Cinema.idKey, onDelete: .cascade)
            builder.reference(from: \.movieId, to: Movie.idKey, onDelete: .cascade)
        }
    }
    
    static func revert(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return Database.update(CinemaMoviePivot.self, on: conn) { builder in
            builder.deleteReference(from: \.cinemaId, to: Cinema.idKey)
            builder.deleteReference(from: \.movieId, to: Movie.idKey)
        }
    }
}
