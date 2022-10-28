public class ReviewService {
    
    private static final String ANONYMOUS_DEFAULT_AUTHOR_NAME  = 'Anonymous';
    
    private ErrorHandler errorHandler;

    public ReviewService(ErrorHandler errorHandler){
        this.errorHandler = errorHandler;
    }
    
    public static ID createReview(String movieId, String authorName, String comment,
        						  Integer qualification){
		Object movieRelated = MovieOMDbAPI.getMovieById(movieId);
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
    
    public static Map<Object, List<Review__c>> getReviewsByMovieId(String movieId){
        List<Review__c> reviews = new List<Review__c>();
        Map<Object, List<Review__c>> movieWithReviews = new Map<Object, List<Review__c>>();    
		reviews = ReviewRepository.getReviewsByMovieId(movieId);
        Object movieRelated = MovieOMDbAPI.getMovieById(movieId);
        movieWithReviews.put(movieRelated, reviews);
        
		return movieWithReviews;          
    }
    
    private static String emptyAuthorNameToAnonymus(String authorName){
        if(String.isBlank(authorName)){
            authorName = ANONYMOUS_DEFAULT_AUTHOR_NAME;
        }
        return authorName;
    }

}