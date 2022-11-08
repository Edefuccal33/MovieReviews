public class Movie {

	@AuraEnabled
    public String Title;	//Gold
	@AuraEnabled
	public String Year;	//2016
	public String Rated;	//R
	public String Released;	//27 Jan 2017
	public String Runtime;	//120 min
	public String Genre;	//Crime, Drama
	public String Director;	//Stephen Gaghan
	public String Writer;	//Patrick Massett, John Zinman
	public String Actors;	//Matthew McConaughey, Edgar Ramírez, Bryce Dallas Howard
	public String Plot;	//Kenny Wells, a prospector desperate for a lucky break, teams up with a similarly eager geologist and sets off on a journey to find gold in the uncharted jungle of Indonesia.
	public String Language;	//English, Indonesian
	public String Country;	//United States
	public String Awards;	//1 win & 5 nominations
	@AuraEnabled
	public String Poster;	//https://m.media-amazon.com/images/M/MV5BNzI1NjI5OTUyM15BMl5BanBnXkFtZTgwOTM4NzY2MDI@._V1_SX300.jpg
	//public cls_Ratings[] Ratings;
    //public List<Map<String,String>> Ratings;
	public String Metascore;	//49
	public String imdbRating;	//6.7
	public String imdbVotes;	//64,415
	@AuraEnabled
	public String imdbID;	//tt1800302
	public String Type;	//movie
	public String DVD;	//02 May 2017
	public String BoxOffice;	//$7,227,038
	public String Production;	//N/A
	public String Website;	//N/A
	public String Response;	//True
    @AuraEnabled
	public List<Review__c> Reviews;

    public Movie() {}


}
