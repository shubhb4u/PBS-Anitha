import { LightningElement, track } from 'lwc';
import createAccount from '@salesforce/apex/AccountController.createAccount';

export default class AccountForm extends LightningElement {
    @track name = '';
    @track email = '';
    @track phone = '';
 
    handleNameChange(event) {
        this.name = event.target.value;
    }
 
    handleEmailChange(event) {
        this.email = event.target.value;
    }
 
    handlePhoneChange(event) {
        this.phone = event.target.value;
    }
 
    handleSubmit() {
        const signUpData = {
            Name: this.name,
            Email__c: this.email,
            Phone__c: this.phone
        };
 
        createAccount({ accountData: signUpData })
            .then(result => {
                console.log('Record created: ', result);
                // Optionally, reset form fields after successful submission
                this.name = '';
                this.email = '';
                this.phone = '';
            })
            .catch(error => {
                console.error('Error creating record: ', error);
            });
    }
}