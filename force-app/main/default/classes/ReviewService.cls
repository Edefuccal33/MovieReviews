public class ReviewService {
    
    private static final String ANONYMOUS_DEFAULT_AUTHOR_NAME  = 'Anonymous';
    //Custom error messages:
    private static final String CUSTOM_MESSAGE_INVALID_AUTHOR_PARAM_POST_REVIEW = 'Author name string value cannot be numeric.';
    private static final String CUSTOM_MESSAGE_INVALID_COMMENT_PARAM_POST_REVIEW = 'Comment string value is mandatory. It cannot be null, empty or numeric.';
    private static final String CUSTOM_MESSAGE_INVALID_QUALIFICATION_PARAM_POST_REVIEW = 'Qualification number value is mandatory. It cannot be null or empty, must be a number between 0 and 10.';
    
    public ReviewService(){}
    
    public static ID createReview(String movieId, String authorName, String comment,
        						  Integer qualification){
		Object movieRelated = MovieOMDbAPI.getMovieById(movieId);
		if(errorHandler(authorName, comment, qualification) == null){
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

    private static ReviewException errorHandler(String authorName, String comment, Integer qualification){
        if(authorName.isNumeric()){
            throw new ReviewException(400, 
                                      CUSTOM_MESSAGE_INVALID_AUTHOR_PARAM_POST_REVIEW);
        }
        if(!IsStringValid(comment)){
            throw new ReviewException(400, 
                                      CUSTOM_MESSAGE_INVALID_COMMENT_PARAM_POST_REVIEW);
        }
        if(!isQualificationValid(qualification)){
            throw new ReviewException(400, 
                                      CUSTOM_MESSAGE_INVALID_QUALIFICATION_PARAM_POST_REVIEW);
        }
        return null;
    }
    
    private static Boolean IsStringValid(String stringValue){
        if(String.isBlank(stringValue) || String.isEmpty(stringValue) || stringValue.isNumeric()){
            return FALSE;
        }
        return TRUE;
    }

    private static Boolean isQualificationValid(Integer qualification){
        if(string.isBlank(String.valueOf(qualification)) || 
           string.isEmpty(String.valueOf(qualification)) ||
           !String.valueOf(qualification).isNumeric()){
            return FALSE;
        }
        if(String.valueOf(qualification).length() > 2){
            return FALSE;
        }
        if(qualification > 10 || qualification < 0){
            return FALSE;
        }
        return TRUE;
    }
   
}