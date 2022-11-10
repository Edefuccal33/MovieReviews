import { LightningElement, wire, track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { subscribe, MessageContext, unsubscribe  } from 'lightning/messageService';
import SEND_MOVIE_ID from "@salesforce/messageChannel/sendMovieId__c";
import REFRESH_REVIEWS from "@salesforce/messageChannel/refreshReviews__c";
import getReviews from '@salesforce/apex/ReviewControllerNoRest.getReviews';
export default class ReviewList extends LightningElement {
    reviews = [];
	subscription = null;
	refreshSubscription = null;
	@track refresh = false;
	@track receivedMovieId = '';
	@track movieTitle='';
	@wire(MessageContext)
    messageContext;

	/** Wired Apex result so it can be refreshed programmatically */
	wiredReviewsResult;
	
	suscribeMovieId(){
		if(this.subscription){
			return;
		}
		this.subscription = subscribe(this.messageContext, SEND_MOVIE_ID, (message) => {
			this.handleId(message);
		});
		this.refreshSubscription = subscribe(this.messageContext, REFRESH_REVIEWS, (message) => {
			this.handleRefresh(message);
		})
	}

	disconnectedCallback() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

	handleId(message){
		this.receivedMovieId = JSON.parse(JSON.stringify(message)).movieIdToSend;
		this.movieTitle = JSON.parse(JSON.stringify(message)).movieTitle;
	}

	handleRefresh(message){
		this.refresh = JSON.parse(JSON.stringify(message)).refresh;
		if(this.refresh){
			refreshApex(this.wiredReviewsResult);	
		} 
	}

	connectedCallback() {
		this.suscribeMovieId();
	}

	@wire(getReviews, {movieId: '$receivedMovieId'})
	loadMovie(result) {
		// Hold on to the provisioned value so we can refresh it later.
		this.wiredReviewsResult = result;
		// Destructure the provisioned value 
		if (result.data) {
			this.reviews = result.data;
			this.error = [];
		}
		else if (result.error) {
			this.reviews = [];
			this.error = result.error.body.message;
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
}