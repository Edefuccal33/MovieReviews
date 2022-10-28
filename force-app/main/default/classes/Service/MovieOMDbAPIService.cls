public class MovieOMDbAPIService {
    
    private static final OMDbApiSettings__mdt apiData = [SELECT ApiKeyValue__c, OMDbURLBase__c FROM OMDbApiSettings__mdt];  
    private static final String API_URL = apiData.OMDbURLBase__c;
    private static final String API_KEY = '&apikey=' + apiData.ApiKeyValue__c; 
    
    private static final String GET_REQUEST_METHOD = 'GET';
    private static final String BY_ID_SEARCH_PARAMETER = 'i=';
    private static final String BY_TITLE_SEARCH_PARAMETER = 's='; //NO SE USA!!

    private ErrorHandler errorHandler;
    
    public MovieOMDbAPIService(ErrorHandler errorHandler) {
        this.errorHandler = errorHandler; 
    }

    public static Object getMovieById(String movieId){
        
        final String endPoint = API_URL + BY_ID_SEARCH_PARAMETER + movieId + API_KEY;
        HttpResponse response = getResponse(endPoint);

        if (!errorHandler.hasErrorIMDbAPIException(response)){
            Object movie = (Object) JSON.deserializeUntyped(response.getBody());
            return movie;
        }
        return null;

    }
    
    //NO SE USA!!
    public static List<Object> getMoviesByTitle(String title){

        final String endPoint = API_URL + BY_TITLE_SEARCH_PARAMETER + title + API_KEY; 
        HttpResponse response = getResponse(endPoint);
        
        if (!errorHandler.hasErrorIMDbAPIException(response)){
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> movies = (List<Object>) results.get('Search');
            return movies;
        }
        return null;
    }
    
    private static HttpResponse getResponse(String endPoint){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setMethod(GET_REQUEST_METHOD);
        HttpResponse response = http.send(request);
        
        return response;
    }

}