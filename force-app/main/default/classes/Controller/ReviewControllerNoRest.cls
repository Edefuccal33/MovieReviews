public with sharing class ReviewControllerNoRest {

    private ReviewService reviewService;
    public ReviewControllerNoRest(ReviewService reviewService) {
        this.reviewService = reviewService;
    }

    @AuraEnabled(cacheable=true)
    public static List<Movie> getMovies(String movieTitle){
        try{
            return ReviewService.getMoviesByMovieTitle(movieTitle);
    	}catch(APICustomException e){
            throw new AuraHandledException(e.getMessage());
        }catch(Exception e){
            throw new AuraHandledException(JSON.Serialize(errorHandler.createServerUnknownError()));
        }
    }

    @AuraEnabled(cacheable=true)
    public static Movie getMovieById(String movieId){
        try{
            Movie movie = ReviewService.getMoviesWithReviewsByMovieId(movieId);
            System.debug(movie);
            return ReviewService.getMoviesWithReviewsByMovieId(movieId);
    	}catch(APICustomException e){
            throw new AuraHandledException(JSON.Serialize(e));
        }catch(Exception e){
            throw new AuraHandledException(JSON.Serialize(errorHandler.createServerUnknownError()));
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Review__c> getReviews(String movieId){
        try {
            return ReviewService.getReviewsByMovieId(movieId);
        }catch (APICustomException e) {
            throw new AuraHandledException(JSON.Serialize(e));
        }catch(Exception e){
            throw new AuraHandledException(JSON.Serialize(errorHandler.createServerUnknownError()));
        }
    }

    @AuraEnabled
    public static void createReview(String movieId, String authorName, String comment, Integer qualification){
        try {
            Id recordId = reviewService.createReview(movieId, authorName, comment, qualification);
        }catch (APICustomException e) {
            throw new AuraHandledException(JSON.Serialize(e));
        }catch(Exception e){
            throw new AuraHandledException(JSON.Serialize(errorHandler.createServerUnknownError()));
        }
    }

}