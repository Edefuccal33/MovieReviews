public class ReviewRepository {
    
    public ReviewRepository(){}
    
    public static List<Review__c> getReviewsByMovieId(String movieId){
        return [SELECT Id, Name, Author__c, Qualification__c, Comment__c, CreatedDate__c
				FROM Review__c
                WHERE MovieId__c = :movieId
                ORDER BY CreatedDate__c DESC];
    }

    public static List<Review__c> getAllReviews(){
        return [SELECT MovieId__c, Id, Name, Author__c, Qualification__c, Comment__c, CreatedDate__c
                FROM Review__c
                ORDER BY CreatedDate__c DESC];
    }

    public static Id insertReview(String movieId, String authorName, String comment,
                                    Integer qualification){
        Review__c review = new Review__c(
                            MovieId__c = movieId,
                            Author__c = authorName,
                            Comment__c = comment,
                            Qualification__c = qualification);
        insert review;        
        return review.Id;                                                    
    }
}