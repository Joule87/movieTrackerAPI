//
//  ReviewController.swift
//  App
//
//  Created by Julio Collado on 5/19/20.
//

import Vapor
import FluentPostgreSQL

final class ReviewController: RouteCollection {
    
    func boot(router: Router) throws {
        let reviewGroup = router.grouped("api/review")
        reviewGroup.post(Review.self, use: add)
        reviewGroup.delete(Review.parameter, use: delete)
        reviewGroup.get(Review.parameter,"movie", use: getMovieFromReview)
        reviewGroup.put(Review.self, use: update)
        
        let reviewsGroup = router.grouped("api/reviews")
        reviewsGroup.get(use: getAll)
        reviewsGroup.get("movieId", Int.parameter, use: getAllByMovieId)
    }
    
    func add(request: Request, review: Review) throws -> Future<Review> {
        return review.save(on: request)
    }

    func getAllByMovieId(request: Request) throws -> Future<[Review]> {
        let movieId = try request.parameters.next(Int.self)
        return Review.query(on: request).filter(\.movieId == movieId).all()
    }
    
    func getAll(request: Request) throws -> Future<[Review]> {
        return Review.query(on: request).all()
    }
    
    func delete(request: Request) throws -> Future<Review> {
        return try request.parameters.next(Review.self).delete(on: request)
    }
    
    func getMovieFromReview(request: Request) throws -> Future<Movie> {
        return try request.parameters.next(Review.self).flatMap(to: Movie.self) { review in
            return review.movie.get(on: request)
        }
    }
    
    func update(request: Request, review: Review) throws -> Future<HTTPStatus> {
        review.update(on: request).transform(to: .ok)
    }
}
