import { NavigationMixin } from 'lightning/navigation';
import { LightningElement, wire, track } from 'lwc';
import { createMessageContext, releaseMessageContext, publish } from 'lightning/messageService';
import SEND_MOVIE_ID from "@salesforce/messageChannel/sendMovieId__c";
import searchMovies from '@salesforce/apex/ReviewControllerNoRest.getMovies';
export default class MovieList extends NavigationMixin(LightningElement) {
	movieTitle = '';
	movies;
	context = createMessageContext();
	@track hideSearch;

	handleHideSearch(e){
		this.hideSearch = e.detail;
	}

	disconnectedCallback(){
        releaseMessageContext(this.context);
    }

	@wire(searchMovies, {movieTitle: '$movieTitle'}) 
	loadMovies({ error, data }) {
		if (error) {
			this.movies = [];
			this.error = error.body.message;
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

	handleClick(){
		this.hideSearch = false;
		//this.template.querySelector('lightning-input').focus();
		const message = {
            movieIdToSend:'',
            movieTitle:''
        };
        publish(this.context, SEND_MOVIE_ID, message);
		// this.searchTerm = '';
		// this.movieTitle = '';
		//let elem = this.template.querySelector("lightning-input-field[data-fieldname='Amount']");
		let elem = this.template.querySelector('lightning-input');
		// eslint-disable-next-line @lwc/lwc/no-async-operation
		setTimeout(() => elem.focus());
	}

}