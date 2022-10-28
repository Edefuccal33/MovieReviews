public class ErrorHandler {

    //Error messages from OMDb API:
    private static final String ERROR_IMDb_INVALID_ID = 'Incorrect IMDb ID.';//da un código 200
    private static final String ERROR_API_KEY_NOT_PROVIDED = 'No API key provided.';
    private static final String ERROR_API_KEY_INVALID = 'Invalid API key!';
    //private static final String ERROR_UNKNOWN_IMDb = 'Error getting data'; //da un código 200 (movieId tt2321216)   

    //Custom error messages from Movie Reviews API:
    private static final String CUSTOM_MESSAGE_INVALID_AUTHOR_PARAM_POST_REVIEW = 'Author name string value cannot be numeric.';
    private static final String CUSTOM_MESSAGE_INVALID_COMMENT_PARAM_POST_REVIEW = 'Comment string value is mandatory. It cannot be null, empty or numeric.';
    private static final String CUSTOM_MESSAGE_INVALID_QUALIFICATION_PARAM_POST_REVIEW = 'Qualification number value is mandatory. It cannot be null or empty, must be a number between 0 and 10.';
    
    public ErrorHandler(){}

    public static Boolean hasErrorIMDbAPIException(HttpResponse response){
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        String errorMessage = (String) results.get('Error');
        String responseFalseText = (String) results.get('Response');

        if (responseFalseText.equalsIgnoreCase('False')){        
            //In order to return correct error codes.  
            if(errorMessage.equalsIgnoreCase(ERROR_IMDb_INVALID_ID)){
                throw new IMDbAPIException(400,errorMessage);
            }else if(errorMessage.equalsIgnoreCase(ERROR_API_KEY_NOT_PROVIDED) || 
                        errorMessage.equalsIgnoreCase(ERROR_API_KEY_INVALID)){
                throw new IMDbAPIException(403,errorMessage);
            }else{
                throw new IMDbAPIException(500,errorMessage);
            }
        }
        return FALSE;
    }

    public static Boolean hasErrorReviewException(String authorName, String comment, Integer qualification){
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

}
