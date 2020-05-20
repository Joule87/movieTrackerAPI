//
//  Movie.swift
//  App
//
//  Created by Julio Collado on 5/18/20.
//

import Vapor
import FluentPostgreSQL

final class Movie: Content {
    typealias Database = PostgreSQLDatabase
    
    var id: Int?
    var title: String
    var isWatched: Bool
    var description: String
}

extension Movie: PostgreSQLModel {
    static var entity: String = "Movies"
}

extension Movie: Migration {}

extension Movie: Parameter {}

extension Movie {
    var reviews:  Children<Movie, Review> {
        return children(\.movieId)
    }
    
    var cinemas: Siblings<Movie, Cinema, CinemaMoviePivot> {
        return siblings()
    }
}
