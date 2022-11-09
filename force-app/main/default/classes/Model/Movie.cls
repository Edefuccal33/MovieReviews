public class Movie {

	@AuraEnabled
    public String Title;	//Gold
	@AuraEnabled
	public String Year;	//2016
	@AuraEnabled
	public String Rated;	//R
	@AuraEnabled
	public String Released;	//27 Jan 2017
	@AuraEnabled
	public String Runtime;	//120 min
	@AuraEnabled
	public String Genre;	//Crime, Drama
	@AuraEnabled
	public String Director;	//Stephen Gaghan
	@AuraEnabled
	public String Writer;	//Patrick Massett, John Zinman
	@AuraEnabled
	public String Actors;	//Matthew McConaughey, Edgar Ramírez, Bryce Dallas Howard
	@AuraEnabled
	public String Plot;	//Kenny Wells, a prospector desperate for a lucky break, teams up with a similarly eager geologist and sets off on a journey to find gold in the uncharted jungle of Indonesia.
	@AuraEnabled
	public String Language;	//English, Indonesian
	@AuraEnabled
	public String Country;	//United States
	@AuraEnabled
	public String Awards;	//1 win & 5 nominations
	@AuraEnabled
	public String Poster;	//https://m.media-amazon.com/images/M/MV5BNzI1NjI5OTUyM15BMl5BanBnXkFtZTgwOTM4NzY2MDI@._V1_SX300.jpg
	//public cls_Ratings[] Ratings;
    //public List<Map<String,String>> Ratings;
	@AuraEnabled
	public String Metascore;	//49
	@AuraEnabled
	public String imdbRating;	//6.7
	@AuraEnabled
	public String imdbVotes;	//64,415
	@AuraEnabled
	public String imdbID;	//tt1800302
	@AuraEnabled
	public String Type;	//movie
	@AuraEnabled
	public String DVD;	//02 May 2017
	@AuraEnabled
	public String BoxOffice;	//$7,227,038
	@AuraEnabled
	public String Production;	//N/A
	@AuraEnabled
	public String Website;	//N/A
	@AuraEnabled
	public String Response;	//True
    @AuraEnabled
	public List<Review__c> Reviews;

    public Movie() {}


}
