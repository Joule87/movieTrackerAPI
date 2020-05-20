//
//  CinemaController.swift
//  App
//
//  Created by Julio Collado on 5/20/20.
//

import Vapor
import FluentPostgreSQL

final class CinemaController: RouteCollection {
    
    func boot(router: Router) throws {
        let cinemaGroup = router.grouped("api/cinema")
        cinemaGroup.post(Cinema.self, use: add)
        cinemaGroup.post(Cinema.parameter, "movie", Movie.parameter, use: addMovieToCinema)
        cinemaGroup.delete(Cinema.parameter, use: delete)
        cinemaGroup.get(Cinema.parameter, "movies", use: getAllMoviesOnCinema)
        
        let cinemasGroup = router.grouped("api/cinemas")
        cinemasGroup.get(use: getAll)
    }
    
    func add(request: Request, review: Cinema) throws -> Future<Cinema> {
        return review.save(on: request)
    }
    
    func addMovieToCinema(request: Request) throws -> Future<HTTPStatus> {
        return try flatMap(to: HTTPStatus.self, request.parameters.next(Cinema.self), request.parameters.next(Movie.self)) { cinema, movie in
            return cinema.movies.attach(movie, on: request).transform(to: .created)
        }
    }

    func getAll(request: Request) throws -> Future<[Cinema]> {
        return Cinema.query(on: request).all()
    }
    
    //api/cinema/${cinemaId}/movies
    func getAllMoviesOnCinema(request: Request) throws -> Future<[Movie]> {
        return try request.parameters.next(Cinema.self).flatMap(to: [Movie].self) { cinema in
            return try cinema.movies.query(on: request).all()
        }
    }
    
    func delete(request: Request) throws -> Future<HTTPStatus> {
        return try request.parameters.next(Cinema.self).flatMap(to: HTTPStatus.self) { cinema in
            return cinema.delete(on: request).transform(to: .noContent)
        }
    }

}
