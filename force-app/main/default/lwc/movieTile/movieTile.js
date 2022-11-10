import { LightningElement, api } from 'lwc';
import { createMessageContext, releaseMessageContext, publish } from 'lightning/messageService';
import SEND_MOVIE_ID from "@salesforce/messageChannel/sendMovieId__c";

export default class MovieTile extends LightningElement {
	@api movie;
    hiddeSearch;
    context = createMessageContext();

    disconnectedCallback(){
        releaseMessageContext(this.context);
    }

    handleOpenRecordClick() {
        const message = {
            movieIdToSend: this.movie.imdbID,
            movieTitle: this.movie.Title
        };
        publish(this.context, SEND_MOVIE_ID, message);
        //cuando hacen click en la peli, creó este evento 
        const hideSearchEvent = new CustomEvent("hidesearch", {
            detail: true
        });
        //envío el evento con Boolan true
        this.dispatchEvent(hideSearchEvent); 
    }
}