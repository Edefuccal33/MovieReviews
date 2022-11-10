public class ReviewService {
    
    private static final String ANONYMOUS_DEFAULT_AUTHOR_NAME  = 'Anonymous';
    
    private ErrorHandler errorHandler;

    public ReviewService(ErrorHandler errorHandler){
        this.errorHandler = errorHandler;
    }
    
    public static ID createReview(String movieId, String authorName, String comment,
        						  Integer qualification){
		Movie movieRelated = MovieOMDbAPIService.getMovieById(movieId);
		if(!errorHandler.hasErrorFromThisReviewsAPI(authorName, comment, qualification)){
            return ReviewRepository.insertReview(movieId, emptyAuthorNameToAnonymus(authorName), comment, qualification);           
        }                                      
 		return null;                                     
    }

    public static Movie getMoviesWithReviewsByMovieId(String movieId){
        Movie movie = MovieOMDbAPIService.getMovieById(movieId);
        movie.reviews = ReviewRepository.getReviewsByMovieId(movieId);
        return movie;
    }

    public static List<Review__c> getReviewsByMovieId(String movieId){
        Movie movie = MovieOMDbAPIService.getMovieById(movieId);
        return ReviewRepository.getReviewsByMovieId(movieId);
    }

    public static List<Movie> getMoviesByMovieTitle(String movieTitle){
        
        return MovieOMDbAPIService.getMoviesByTitle(movieTitle);
        
        // if (!loadReviews) return MovieOMDbAPIService.getMoviesByTitle(movieTitle);

        // List<Movie> movies = MovieOMDbAPIService.getMoviesByTitle(movieTitle);
        // List<Review__c> allReviews = ReviewRepository.getAllReviews();
        // List<Review__c> relatedReviews = new List<Review__c>();

        // for(Movie movie: movies){
        //     for(Review__c r: allReviews){
        //         if(movie.imdbID == r.MovieId__c){
        //             relatedReviews.add(r);
        //         }
        //     }
        //     movie.reviews = relatedReviews; 
        // }
        // return movies;
    }
    
    private static String emptyAuthorNameToAnonymus(String authorName){
        if(String.isBlank(authorName) || String.isEmpty(authorName) || authorName == null){
            authorName = ANONYMOUS_DEFAULT_AUTHOR_NAME;
        }
        return authorName;
    }

}