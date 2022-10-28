public class ReviewService {
    
    private static final String ANONYMOUS_DEFAULT_AUTHOR_NAME  = 'Anonymous';
    
    private ErrorHandler errorHandler;

    public ReviewService(ErrorHandler errorHandler){
        this.errorHandler = errorHandler;
    }
    
    public static ID createReview(String movieId, String authorName, String comment,
        						  Integer qualification){
		Movie movieRelated = MovieOMDbAPIService.getMovieById(movieId);
		if(!errorHandler.hasErrorReviewException(authorName, comment, qualification)){
            Review__c review = new Review__c(
                                MovieId__c = movieId,
                                Author__c=emptyAuthorNameToAnonymus(authorName),
                                Comment__c=comment,
                                Qualification__c=qualification);
            insert review;        
            return review.Id;            
        }                                      
 		return null;                                     
    }

    public static Movie getMoviesWithReviewsByMovieId(String movieId){
        Movie movie = MovieOMDbAPIService.getMovieById(movieId);
        movie.reviews = ReviewRepository.getReviewsByMovieId(movieId);
        return movie;
    }

    public static List<Movie> getMoviesWithReviewsByMovieTitle(String movieTitle){
        List<Review__c> movieReviews = new List<Review__c>();
        List<Movie> movies = MovieOMDbAPIService.getMoviesByTitle(movieTitle);

        for(Movie movie: movies){
            movieReviews = ReviewRepository.getReviewsByMovieId(movie.imdbID);
            movie.reviews = movieReviews; 
        }
        return movies;
    }
    
    private static String emptyAuthorNameToAnonymus(String authorName){
        if(String.isBlank(authorName)){
            authorName = ANONYMOUS_DEFAULT_AUTHOR_NAME;
        }
        return authorName;
    }

}