import { LightningElement, wire, track } from 'lwc';
import { subscribe, MessageContext, unsubscribe  } from 'lightning/messageService';
import SEND_MOVIE_ID from "@salesforce/messageChannel/sendMovieId__c";
import getReviews from '@salesforce/apex/ReviewControllerNoRest.getReviews';
export default class ReviewList extends LightningElement {
    reviews;
	subscription = null;
	@track receivedMovieId = '';
	@track movieTitle='';
	@wire(MessageContext)
    messageContext;

	get movieSelected(){
		return (!this.received === '');
	}

	suscribeMovieId(){
		if(this.subscription){
			this.disconnectedCallback();
			return;
		}
		console.log(this.receivedMovieId);
		this.subscription = subscribe(this.messageContext, SEND_MOVIE_ID, (idToSend) => {
			this.handleId(idToSend);
		});
	}

	disconnectedCallback() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

	handleId(idToSend){
		this.receivedMovieId = JSON.parse(JSON.stringify(idToSend)).movieIdToSend;
		this.movieTitle = JSON.parse(JSON.stringify(idToSend)).movieTitle;
	}

	connectedCallback() {
		this.suscribeMovieId();
	}
	
	@wire(getReviews, {movieId: '$receivedMovieId'})
	loadMovie({ error, data }) {
		if (error) {
			this.reviews = [];
			this.error = error.body.message;
			console.log(error);
		} else if (data) {
			this.reviews = data;
			this.error = [];
		}
    }

	get hasResults(){
		return (this.reviews.length > 0);
	}

	createReview(){
		console.log("Creada!");
	}
}