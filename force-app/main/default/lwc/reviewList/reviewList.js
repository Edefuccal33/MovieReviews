import { LightningElement, wire, track } from 'lwc';
import { subscribe, MessageContext, unsubscribe  } from 'lightning/messageService';
import SEND_MOVIE_ID from "@salesforce/messageChannel/sendMovieId__c";
import getReviews from '@salesforce/apex/ReviewControllerNoRest.getReviews';
export default class ReviewList extends LightningElement {
    reviews = [];
	subscription = null;
	@track receivedMovieId = '';
	@track movieTitle='';
	@wire(MessageContext)
    messageContext;

	suscribeMovieId(){
		if(this.subscription){
			return;
		}
		console.log(this.reviews);
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

	get countReviews(){
		return (this.reviews.length);
	}

	get movieNotSelected(){
		return (this.movieTitle === '');
	}

	createReview(){
		console.log("Creada!");
	}
}