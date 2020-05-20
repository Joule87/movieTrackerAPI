import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let movieCollection = MovieController()
    try router.register(collection: movieCollection)
    
    let reviewController = ReviewController()
    try router.register(collection: reviewController)
    
    let cinemaController = CinemaController()
    try router.register(collection: cinemaController)
}
