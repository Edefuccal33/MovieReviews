@RestResource(urlMapping='/Reviews/*')
global with sharing class ReviewController {
    private ReviewService reviewService;
    
    public ReviewController(ReviewService reviewService){
        this.reviewService = reviewService;
    }
    
    @HttpGet
    global static void getMovies(){
        try{
            RestRequest request = RestContext.request;
            if(request.params.isEmpty()){
                String movieId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
                Movie movie = ReviewService.getMoviesWithReviewsByMovieId(movieId);
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(movie));                
            }else{
                List<String> paramKeys = new List<String>(request.params.keySet());
                String movieTitle = request.params.get(paramKeys[1]);
                Boolean loadReviews = Boolean.valueOf(request.params.geT(paramKeys[0]));
                List<Movie> movies = ReviewService.getMoviesByMovieTitle(movieTitle, loadReviews);
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(movies));  
            }
    	}catch(APICustomException e){
            RestContext.response.statusCode = e.getErrorCode();
           	RestContext.response.responseBody = Blob.valueOf(JSON.serialize(e));
        }catch(Exception e){
            APICustomException unknownException = ErrorHandler.createServerUnknownError(e.getMessage());
            RestContext.response.statusCode = unknownException.getErrorCode();
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(unknownException));
        }
    }
    
    @HttpPost
    global static void createReview(String movieId, String authorName, String comment, Integer qualification) {
		try{
			Id recordId = reviewService.createReview(movieId, authorName, comment, qualification);
            RestContext.response.statusCode = 201;
            RestContext.response.responseBody = (Blob.valueOf(JSON.serialize(recordId)));
            
    	}catch(APICustomException e){
            RestContext.response.statusCode = e.getErrorCode();
           	RestContext.response.responseBody = Blob.valueOf(JSON.serialize(e));
            
    	}catch(Exception e){
            APICustomException unknownException = ErrorHandler.createServerUnknownError(e.getMessage());
            RestContext.response.statusCode = unknownException.getErrorCode();
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(unknownException));
        }
    }
}