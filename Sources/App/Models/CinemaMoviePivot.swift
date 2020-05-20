//
//  CinemaMoviePivot.swift
//  App
//
//  Created by Julio Collado on 5/20/20.
//

import Foundation
import FluentPostgreSQL

final class CinemaMoviePivot: PostgreSQLPivot, ModifiablePivot {
    typealias Database = PostgreSQLDatabase
    
    var id: Int?
    var movieId: Movie.ID
    var cinemaId: Cinema.ID
    
    typealias Left = Movie
    typealias Right = Cinema
    
    static var leftIDKey: LeftIDKey = \.movieId
    static var rightIDKey: RightIDKey = \.cinemaId
    
    init(_ left: Movie, _ right: Cinema) throws {
        self.cinemaId = try right.requireID()
        self.movieId = try left.requireID()
    }
    
}

extension CinemaMoviePivot: Migration { }

extension CinemaMoviePivot: PostgreSQLModel {
    static var entity: String = "CinemaMovies"
}
