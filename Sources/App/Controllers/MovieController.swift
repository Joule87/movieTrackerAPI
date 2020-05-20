//
//  MovieController.swift
//  App
//
//  Created by Julio Collado on 5/18/20.
//

import Vapor
import FluentPostgreSQL

struct MovieController: RouteCollection {
    func boot(router: Router) throws {
        let moviesGroup = router.grouped("api/movies")
        moviesGroup.get(use: getAll)
        //        moviesGroup.get("rating", Int.parameter, use: getAllByRating)
        
        let movieGroup = router.grouped("api/movie")
        movieGroup.get(Movie.parameter, use: getById)
        movieGroup.post(Movie.self, use: add)
        movieGroup.delete(Movie.parameter, use: delete)
        movieGroup.put(Movie.self, use: update)
        movieGroup.get(Movie.parameter,"cinemas", use: getAllCinemasForMovie)
    }
    
    func getAll(request: Request) -> Future<[Movie]> {
        return Movie.query(on: request).all()
    }
    
    func getById(request: Request) throws -> Future<Movie> {
        return try request.parameters.next(Movie.self)
    }
    
    //    func getAllByRating(request: Request) throws -> Future<[Movie]> {
    //        let rating = try request.parameters.next(Int.self)
    //        return Movie.query(on: request).filter(\.rating == rating).all()
    //    }
    
    func add(request: Request, movie: Movie) throws -> Future<Movie> {
        return movie.save(on: request)
    }
    
    func delete(request: Request) throws -> Future<Movie> {
        return try request.parameters.next(Movie.self).delete(on: request)
    }
    
    func update(request: Request, movie: Movie) throws -> Future<Movie> {
        return movie.update(on: request)
    }
    
    //api/movie/${movieId}/cinemas
    func getAllCinemasForMovie(request: Request) throws -> Future<[Cinema]> {
        return try request.parameters.next(Movie.self).flatMap(to: [Cinema].self) { movie in
            return try movie.cinemas.query(on: request).all()
        }
    }
}
