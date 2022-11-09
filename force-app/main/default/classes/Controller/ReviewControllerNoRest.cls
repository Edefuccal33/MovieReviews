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
            throw new AuraHandledException(errorHandler.createServerUnknownError().getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static Movie getMovieById(String movieId){
        try{
            Movie movie = ReviewService.getMoviesWithReviewsByMovieId(movieId);
            System.debug(movie);
            return ReviewService.getMoviesWithReviewsByMovieId(movieId);
    	}catch(APICustomException e){
            throw new AuraHandledException(e.getMessage());
        }catch(Exception e){
            throw new AuraHandledException(errorHandler.createServerUnknownError().getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Review__c> getReviews(String movieId){
        try {
            System.debug(movieId);
            return ReviewService.getReviewsByMovieId(movieId);
        }catch (APICustomException e) {
            System.debug(movieId);
            System.debug(e);
            throw new AuraHandledException(e.getMessage());
        }catch(Exception e){
            System.debug(movieId);
            System.debug(e);
            throw new AuraHandledException(errorHandler.createServerUnknownError().getMessage());
        }
    }


}