public class MovieOMDbAPIService {
    
    private static final OMDbApiSettings__mdt apiData = [SELECT ApiKeyValue__c, OMDbURLBase__c FROM OMDbApiSettings__mdt];  
    private static final String API_URL = apiData.OMDbURLBase__c;
    private static final String API_KEY = '&apikey=' + apiData.ApiKeyValue__c; 
    
    private static final String GET_REQUEST_METHOD = 'GET';
    private static final String BY_ID_SEARCH_PARAMETER = 'i=';
    private static final String BY_TITLE_SEARCH_PARAMETER = 's=';

    private ErrorHandler errorHandler;
    
    public MovieOMDbAPIService(ErrorHandler errorHandler) {
        this.errorHandler = errorHandler; 
    }

    public static Movie getMovieById(String movieId){      
        validateMovieId(movieId);
        final String endPoint = API_URL + BY_ID_SEARCH_PARAMETER + movieId + API_KEY;
        HttpResponse response = getResponse(endPoint);

        if (!errorHandler.hasErrorFromOMDbAPI(response)){
            return (Movie) JSON.deserialize(response.getBody(), Movie.class); 
        }
        return null;
    }
    
    public static List<Movie> getMoviesByTitle(String title){
        validateMovieTitle(title);
        final String endPoint = API_URL + BY_TITLE_SEARCH_PARAMETER + title + API_KEY; 
        HttpResponse response = getResponse(endPoint);
        
        if (!errorHandler.hasErrorFromOMDbAPI(response)){
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> deserializedResults = (List<Object>) results.get('Search');
            List<Movie> movies = new List<Movie>();

            for(Object obj: deserializedResults){
                movies.add((Movie) JSON.deserialize(JSON.serialize(obj), Movie.class));
            }
            return movies;
        }
        return null;
    }

    private static void validateMovieTitle(String movieTitle){
        if(String.isBlank(movieTitle) || String.isEmpty(movieTitle)){
            throw errorHandler.createEmptyMovieTitleException();
        }
    }

    private static void validateMovieId(String movieId){
        if(String.isBlank(movieId) || String.isEmpty(movieId)){
            throw errorHandler.createEmptyMovieIdException();
        }
    }

    private static HttpResponse getResponse(String endPoint){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setMethod(GET_REQUEST_METHOD);
        request.setTimeout(3000);
        HttpResponse response;
        try{
            response = http.send(request);
            return response;
        }catch(System.CalloutException e){
            return null;
        }        
    }

}