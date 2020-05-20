//
//  AddingDescriptionToMovies.swift
//  App
//
//  Created by Julio Collado on 5/18/20.
//

import Foundation
import Vapor
import FluentPostgreSQL

struct AddingDescriptionToMovies: Migration {
    typealias Database = PostgreSQLDatabase
    
    static func prepare(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return Database.update(Movie.self, on: conn) { builder in
            builder.field(for: \.description)
        }
    }
    
    static func revert(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return Database.update(Movie.self, on: conn) { builder in
            builder.deleteField(for: \.description)
        }
    }
}
