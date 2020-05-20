//
//  Cinema.swift
//  App
//
//  Created by Julio Collado on 5/20/20.
//

import Foundation
import Vapor
import FluentPostgreSQL

final class Cinema: Content {
    typealias Database = PostgreSQLDatabase
    
    var id: Int?
    var name: String
    var capacity: Int
    
}

extension Cinema: PostgreSQLModel {
    static var entity: String = "Cinemas"
}

extension Cinema: Migration {}

extension Cinema: Parameter {}

extension Cinema {
    var movies: Siblings<Cinema, Movie, CinemaMoviePivot> {
        return siblings()
    }
}


