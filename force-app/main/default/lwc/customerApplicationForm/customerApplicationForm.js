import { LightningElement,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AddressAutocomplete_UsingGoogleAPI extends LightningElement {
    @api recordId;
    @api objectAPIName;
    strName = 'test123';
    strStreet;
    strCity;
    strState;
    strCountry;
    strPostalCode;
    handleSuccess( event ) {
    console.log( 'Updated Record Id is ', event.detail.id );
    this.dispatchEvent(
    new ShowToastEvent({
    title: 'Successful Record Update',
    message: 'Record Updated Surccessfully!!!',
    variant: 'success'
    })
    );
    }
    handleSubmit( event )
    
    {
    let fields = event.detail.fields;
    console.log( 'Fields are ' + JSON.stringify( fields ) );
    event.preventDefault();
    if ( this.objectAPIName === 'B2B_Customer__c' ) {

    fields.Company_Billing_Address__Street__s = this.strStreet;
    fields.Name = this.strName;
    //fields.BillingCity = this.strCity;
    //fields.BillingState = this.strState;
    //fields.BillingCountry = this.strCountry;
    //fields.BillingPostalCode = this.strPostalCode;
    } else if ( this.objectAPIName === 'Contact' ) {
    fields.MailingStreet = this.strStreet;
    fields.MailingCity = this.strCity;
    fields.MailingState = this.strState;
    fields.MailingCountry = this.strCountry;
    fields.MailingPostalCode = this.strPostalCode;
    }
    this.template.querySelector( 'lightning-record-edit-form' ).submit( fields );
    }
    addressInputChange( event ) {
    this.strStreet = event.target.street;
    this.strCity = event.target.city;
    this.strState = event.target.province;
    this.strCountry = event.target.country;
    this.strPostalCode = event.target.postalCode;
    }


}