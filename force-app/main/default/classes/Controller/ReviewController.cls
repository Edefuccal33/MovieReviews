@RestResource(urlMapping='/Reviews/*')
global with sharing class ReviewController {
    private ReviewService reviewService;
    
    public ReviewController(ReviewService reviewService){
        this.reviewService = reviewService;
    }
    
    @HttpGet
    global static void getReviewsByMovieId(){
        try{
            RestRequest request = RestContext.request;
            String movieId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
            Map<Object, List<Review__c>> movieWithReviews = ReviewService.getReviewsByMovieId(movieId);
			RestContext.response.responseBody = Blob.valueOf(JSON.serialize(movieWithReviews));
            
    	}catch(IMDbAPIException e){
            RestContext.response.statusCode = e.getErrorCode();
           	RestContext.response.responseBody = Blob.valueOf(JSON.serialize(e));
    	}
    }
    
    @HttpPost
    global static void createReview(String movieId, String authorName, String comment, Integer qualification) {
		try{
			Id recordId = reviewService.createReview(movieId, authorName, comment, qualification);
            RestContext.response.statusCode = 201;
            RestContext.response.responseBody = (Blob.valueOf(JSON.serialize(recordId)));
            
    	}catch(ReviewException e){
            RestContext.response.statusCode = e.getErrorCode();
           	RestContext.response.responseBody = Blob.valueOf(JSON.serialize(e));
            
    	}catch(IMDbAPIException e){
            RestContext.response.statusCode = e.getErrorCode();
           	RestContext.response.responseBody = Blob.valueOf(JSON.serialize(e));
    	}
    }
}