@RestResource(urlMapping='/Reviews/*')
global with sharing class ReviewController {
    private ReviewService reviewService;
    private static final STRING MOVIE_TITLE_KEY_PARAM = 'MovieTitle';
    
    public ReviewController(ReviewService reviewService){
        this.reviewService = reviewService;
    }
    
    @HttpGet
    global static void getMoviesWithReviews(){
        try{
            RestRequest request = RestContext.request;

            /* NOTA: 
            Convencido de que no es una buena práctica.
            Realizado sólo para este ejercicio para no crear 2 controllers.
            */

            //Si la URI viene sin parámetros, busca la película por Id.
            if(request.params.isEmpty()){
                String movieId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
                Movie movie = ReviewService.getMoviesWithReviewsByMovieId(movieId);
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(movie));                
            }else{ //La busca por el título.
                String movieTitle = request.params.get(MOVIE_TITLE_KEY_PARAM);
                List<Movie> movies = ReviewService.getMoviesWithReviewsByMovieTitle(movieTitle);
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(movies));  
            }

    	}catch(IMDbAPIException e){
            RestContext.response.statusCode = e.getErrorCode();
           	RestContext.response.responseBody = Blob.valueOf(JSON.serialize(e));

    	}catch(Exception e){
            RestContext.response.statusCode = 500;
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
            
    	}catch(Exception e){
            RestContext.response.statusCode = 500;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(e));
        }
    }
}