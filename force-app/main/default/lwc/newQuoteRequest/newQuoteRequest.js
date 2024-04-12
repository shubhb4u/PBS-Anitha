import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'; // Import Toast Event
import createQuote from '@salesforce/apex/RequestQuoteController.createQuote';
import { CartSummaryAdapter } from "commerce/cartApi";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import CONTACT_ID from "@salesforce/schema/User.ContactId";
import USER_FIRST_NAME from "@salesforce/schema/User.FirstName";
import USER_LAST_NAME from "@salesforce/schema/User.LastName";
import USER_ID from "@salesforce/user/Id";

export default class NewQuoteRequest extends LightningElement {
    @api recordId;
    @api effectiveAccountId;
    @track CartId;
    @track requestQuoteBy;
    @track reasonForQuote;
    @track requestQuoteByError;
    @track reasonForQuoteError;
    @track contactId;
    @track userName;
    @track showSuccessMessage;


    @wire(CartSummaryAdapter)
    setCartSummary({ data, error }) {
        if (data) {
            console.log("Cart Id", data.cartId);
            console.log("Cart", data);
            this.CartId = data.cartId;
        } else if (error) {
            console.error(error);
        }
    }

    @wire(getRecord, { recordId: USER_ID, fields: [CONTACT_ID, USER_FIRST_NAME, USER_LAST_NAME] })
    user({data, error}) {
        if (data) {
            this.contactId = getFieldValue(data, CONTACT_ID);
            this.userName = getFieldValue(data, USER_FIRST_NAME) + ' ' + getFieldValue(data, USER_LAST_NAME);

            console.log('data ->>>', this.contactId);
            console.log('userName ->>>', this.userName);
        } else if (error) {
            console.error('Error fetching user data:', error);
        }
    }

    connectedCallback() {
        console.log('Welcome to JS:');
        console.log('cartId:', this.CartId);
    }

    handleRequestQuoteByChange(event) {
        this.requestQuoteBy = event.target.value;
    }

    handleReasonForQuoteChange(event) {
        this.reasonForQuote = event.target.value;
    }

    handleCreateQuote() {
        this.requestQuoteByError = '';
        this.reasonForQuoteError = '';
        if (!this.requestQuoteBy || !this.reasonForQuote) {
            if(!this.requestQuoteBy){
                this.requestQuoteByError = 'This field is required and can not be empty';
            }
            if(!this.reasonForQuote){
                this.reasonForQuoteError = 'This field is required and can not be empty';
            }
            return;
        }
        if (this.CartId) {
            console.log('this.contactId', this.contactId);
            createQuote({ cartId: this.CartId, requestQuoteBy: this.requestQuoteBy, reasonForQuote: this.reasonForQuote, contactId: this.contactId, userName: this.userName })
                .then(response => {
                    // Handle successful response
                    console.log('Quote created successfully:', response);
                    this.showSuccessMessage = true;
                    // Dispatch success message
                })
                .catch(error => {
                    // Handle error
                    console.error('Error creating quote:', error);
                    // Dispatch error message
                });
        } else {
            console.error('No cart details available.');
        }
    }
}