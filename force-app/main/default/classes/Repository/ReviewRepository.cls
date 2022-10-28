public class ReviewRepository {
    
    public ReviewRepository(){}
    
    public static List<Review__c> getReviewsByMovieId(String movieId){
        return [SELECT Id, Name, Author__c, Qualification__c, Comment__c, CreatedDate__c
				FROM Review__c
                WHERE MovieId__c = :movieId];
    }
}