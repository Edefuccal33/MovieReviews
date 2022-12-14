public class ErrorHandler {

    //Error messages from OMDb API:
    private static final String ERROR_OMDb_INVALID_ID = 'Incorrect IMDb ID.';//da un código 200
    private static final String ERROR_API_KEY_NOT_PROVIDED = 'No API key provided.';
    private static final String ERROR_API_KEY_INVALID = 'Invalid API key!';
    private static final String ERROR_MOVIE_TITLE_NOT_FOUND = 'Movie not found!';
    //Custom error message for Time Out OMDb API:
    private static final String ERROR_TIME_OUT_CALL_OUT = 'OMDb API is taking too long to response. Try another title!';
    private static final String NULL_MOVIE_TITLE = 'Please enter a movie title to retrieve movies';
    private static final String NULL_MOVIE_ID = 'Search and select any movie to see its reviews.';
    private static final String UNKNOWN_ERROR_MESSAGE = 'Cannot find matches, please try with another search term.';

    private static final String OMDb_API_SOURCE_ERROR = 'OM Data Base API';
    private static final String MOVIE_REVIEWS_API_SOURCE_ERROR = 'Salesforce Movie Reviews API';
    private static final String UNKNOWN_ERROR_SOURCE = 'Server unkown error. Please contact the administrator.';
    //Custom error messages from Movie Reviews API:
    private static final String CUSTOM_MESSAGE_INVALID_AUTHOR_PARAM_POST_REVIEW = 'Author name string value cannot be numeric.';
    private static final String CUSTOM_MESSAGE_INVALID_COMMENT_PARAM_POST_REVIEW = 'Comment string value is mandatory. It cannot be null, empty or numeric.';
    private static final String CUSTOM_MESSAGE_INVALID_QUALIFICATION_PARAM_POST_REVIEW = 'Qualification number value is mandatory. It cannot be null or empty, must be a number between 0 and 10.';

    public ErrorHandler(){}

    public static Boolean hasErrorFromOMDbAPI(HttpResponse response){
        
        if (response == null){
            throw new APICustomException(503, ERROR_TIME_OUT_CALL_OUT, OMDb_API_SOURCE_ERROR);
        }
        if (response.getStatusCode()==404){
            throw new APICustomException(500, UNKNOWN_ERROR_MESSAGE, OMDb_API_SOURCE_ERROR);
        }

        Map<String, Object> results;
        try{
            results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        }catch(System.JSONException e){
            throw new APICustomException(400, e.getMessage(), OMDb_API_SOURCE_ERROR);
        }
      
        String errorMessage = (String) results.get('Error');
        String responseFalseText = (String) results.get('Response');

        if (responseFalseText.equalsIgnoreCase('False')){        
            //In order to return correct error codes.  
            if(errorMessage.equalsIgnoreCase(ERROR_OMDb_INVALID_ID)){
                throw new APICustomException(400,errorMessage, OMDb_API_SOURCE_ERROR);
            }else if(errorMessage.equalsIgnoreCase(ERROR_API_KEY_NOT_PROVIDED) || 
                        errorMessage.equalsIgnoreCase(ERROR_API_KEY_INVALID)){
                throw new APICustomException(401,errorMessage, OMDb_API_SOURCE_ERROR);
            }else if(errorMessage.equalsIgnoreCase(ERROR_MOVIE_TITLE_NOT_FOUND)){
                throw new APICustomException(404,errorMessage, OMDb_API_SOURCE_ERROR);
            }else{
                throw new APICustomException(500, errorMessage, OMDb_API_SOURCE_ERROR);
            }
        }
        return FALSE;
    }

    public static Boolean hasErrorFromThisReviewsAPI(String authorName, String comment, Integer qualification){
        if(authorName.isNumeric()){
            throw new APICustomException(400, 
                                      CUSTOM_MESSAGE_INVALID_AUTHOR_PARAM_POST_REVIEW,
                                      MOVIE_REVIEWS_API_SOURCE_ERROR);
        }
        if(!IsStringValid(comment)){
            throw new APICustomException(400, 
                                      CUSTOM_MESSAGE_INVALID_COMMENT_PARAM_POST_REVIEW,
                                      MOVIE_REVIEWS_API_SOURCE_ERROR);
        }
        if(!isQualificationValid(qualification)){
            throw new APICustomException(400, 
                                      CUSTOM_MESSAGE_INVALID_QUALIFICATION_PARAM_POST_REVIEW,
                                      MOVIE_REVIEWS_API_SOURCE_ERROR);
        }
        return FALSE;
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

    public static APICustomException createServerUnknownError(){
        return new APICustomException(500, UNKNOWN_ERROR_SOURCE, UNKNOWN_ERROR_SOURCE); 
    }

    public static APICustomException createEmptyMovieTitleException(){
        return new APICustomException(400, NULL_MOVIE_TITLE, OMDb_API_SOURCE_ERROR); 
    }

    public static APICustomException createEmptyMovieIdException(){
        return new APICustomException(400, NULL_MOVIE_ID, OMDb_API_SOURCE_ERROR); 
    }

}
