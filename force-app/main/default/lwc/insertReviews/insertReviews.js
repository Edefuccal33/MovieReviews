import { LightningElement, track, wire } from 'lwc';
import { subscribe, MessageContext, unsubscribe, createMessageContext, releaseMessageContext, publish  } from 'lightning/messageService';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import REFRESH_REVIEWS from "@salesforce/messageChannel/refreshReviews__c";
import SEND_MOVIE_ID from "@salesforce/messageChannel/sendMovieId__c";
import createReview from '@salesforce/apex/ReviewControllerNoRest.createReview';

export default class InsertReviews extends LightningElement {
    @track receivedMovieId = '';
	@track movieTitle='';
    //params to send to Apex method
    authorName;
    comment;
    qualification;

    @wire(MessageContext)
    messageContext;

    handleSubmit(event) {
        event.preventDefault();
        const fields = event.detail.fields;
        this.qualification = parseInt(fields.Qualification__c, 10);
        this.authorName = fields.Author__c ? fields.Author__c : '' ;
        this.comment = fields.Comment__c;
        this.callApexMethod();
    }

    get movieNotSelected(){
		return (this.movieTitle === '');
	}

    callApexMethod(){
        createReview({movieId: this.receivedMovieId, authorName: this.authorName, comment: this.comment, qualification: this.qualification})
            .then(data => {
                console.log('data ', data);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Review created',
                        variant: 'success',
                    }))
                this.handleReset();
                //evento para refrescar apex
                const message = {
                    refresh: true
                };
                publish(this.context, REFRESH_REVIEWS, message);
            })
            .catch(error => {
                console.log('error ', error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: error.body.message,
                        variant: 'error',
                    }))
            })
    }

    context = createMessageContext();

    handleReset() {
        const inputFields = this.template.querySelectorAll('lightning-input-field');
        if ( inputFields ) {
            inputFields.forEach( field => {
                field.reset();
            } );
        }
    }
    // handleSuccess(event) {
    //     console.log('onsuccess event recordEditForm', event.detail.id);
    //     // @wire(createReview, {movieId: '$receivedMovieId'}) 
    // }

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

	get hasResults(){
		return (this.movie !== undefined);
	}

	get movieNotSelected(){
		return (this.movieTitle === '');
	}

}