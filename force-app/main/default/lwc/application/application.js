import { LightningElement, api } from 'lwc';
import createAccount from '@salesforce/apex/AccountController.createAccount';

export default class AccountForm extends LightningElement {
    handleSubmit() {
        const fields = this.template.querySelectorAll('lightning-input-field');
        console.log('fields:'+fields);
        let accountData = {};
        fields.forEach(field => {
            console.log('field:'+field);
            console.log('field.value:'+field.value);
            console.log('field.fieldName:'+field.fieldName);
            accountData[field.fieldName] = field.value;
        });

       console.log('accountdata:'+accountData);
        console.log('Billing City:'+accountData.BillingAddress.BillingCity);
        console.log('Billing State Code:'+accountData.BillingAddress.BillingStateCode);
        console.log('Billing Street:'+accountData.BillingAddress.BillingStreet);
        console.log('Billing Zip:'+accountData.BillingAddress.BillingPostalCode);
        console.log('Billing Country Code:'+accountData.BillingAddress.BillingCountryCode);


       
        
        createAccount({ accountData })
            .then(result => {
                // Handle success
                console.log('Account created successfully:', result);
            })
            .catch(error => {
                // Handle error
                console.error('Error creating account:', error);
            });
    }
}