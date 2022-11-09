import { LightningElement, track, wire } from 'lwc';
import getMovie from '@salesforce/apex/ReviewControllerNoRest.getMovieById';
import { subscribe, MessageContext, unsubscribe  } from 'lightning/messageService';
import SEND_MOVIE_ID from "@salesforce/messageChannel/sendMovieId__c";

export default class MovieDetails extends LightningElement {
    movie;
    @track receivedMovieId = '';
	@track movieTitle='';
    @wire(MessageContext)
    messageContext;

    suscribeMovieId(){
		if(this.subscription){
			return;
		}
		this.subscription = subscribe(this.messageContext, SEND_MOVIE_ID, (message) => {
			this.handleId(message);
		});
	}

	disconnectedCallback() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

	handleId(message){
		this.receivedMovieId = JSON.parse(JSON.stringify(message)).movieIdToSend;
		this.movieTitle = JSON.parse(JSON.stringify(message)).movieTitle;
	}

	connectedCallback() {
		this.suscribeMovieId();
	}

    @wire(getMovie, {movieId: '$receivedMovieId'}) 
	loadMovies({ error, data }) {
		if (error) {
			this.movie = undefined;
			this.error = error.body.message;
			console.log(error);
		} else if (data) {
			this.movie = data;
			this.error = [];
            console.log(this.movie);
		}
	}

	get hasResults(){
		return (this.movie !== undefined);
	}

	get movieNotSelected(){
		return (this.movieTitle === '');
	}
}