import { NavigationMixin } from 'lightning/navigation';
import { LightningElement, wire } from 'lwc';
import { createMessageContext, releaseMessageContext, publish } from 'lightning/messageService';
import SEND_MOVIE_ID from "@salesforce/messageChannel/sendMovieId__c";
/** BearController.searchBears(searchTerm) Apex method */
import searchMovies from '@salesforce/apex/ReviewControllerNoRest.getMovies'; //@salesforce/apex/BearController.searchBears';
export default class MovieList extends NavigationMixin(LightningElement) {
	movieTitle = '';
	movies;
	context = createMessageContext();

	disconnectedCallback(){
        releaseMessageContext(this.context);
    }

	handleOnClick() {
        const idToSend = {
            movieIdToSend: '',
            movieTitle: ''
        };
        publish(this.context, SEND_MOVIE_ID, idToSend);
    }

	@wire(searchMovies, {movieTitle: '$movieTitle'}) 
	loadMovies({ error, data }) {
		if (error) {
			this.movies = [];
			this.error = error.body.message;
			console.log(error);
		} else if (data) {
			this.movies = data;
			this.error = [];
		}
	}

	handleSearchTermChange(event) {
		window.clearTimeout(this.delayTimeout);
		const searchTerm = event.target.value;
		// eslint-disable-next-line @lwc/lwc/no-async-operation
		this.delayTimeout = setTimeout(() => {
			this.movieTitle = searchTerm;
		}, 100);
		const message = {
            movieIdToSend:'',
            movieTitle:''
        };
        publish(this.context, SEND_MOVIE_ID, message);
	}

	get hasResults(){
		return (this.movies.length > 0);
	}

	// handleMovieView(event) {
	// 	// Get bear record id from bearview event
	// 	const movieId = event.detail;
	// 	// Navigate to bear record page
	// 	this[NavigationMixin.Navigate]({
	// 		type: 'standard__recordPage',
	// 		attributes: {
	// 			recordId: movieId,
	// 			objectApiName: 'movie',
	// 			actionName: 'view',
	// 		},
	// 	});
	// }
}