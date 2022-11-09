import { LightningElement, api } from 'lwc';
import { createMessageContext, releaseMessageContext, publish } from 'lightning/messageService';
import SEND_MOVIE_ID from "@salesforce/messageChannel/sendMovieId__c";

export default class MovieTile extends LightningElement {
	@api movie;

    context = createMessageContext();

    disconnectedCallback(){
        releaseMessageContext(this.context);
    }

    handleOpenRecordClick() {
        const selectEvent = new CustomEvent('movieview', {
            detail: this.movie.imdbID
        });
        this.dispatchEvent(selectEvent);
        console.log(this.movie.imdbID);
        const message = {
            movieIdToSend: this.movie.imdbID,
            movieTitle: this.movie.Title
        };
        publish(this.context, SEND_MOVIE_ID, message);
    }
}