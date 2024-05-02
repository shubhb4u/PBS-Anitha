import { LightningElement, track } from 'lwc';
import submitApplication from '@salesforce/apex/CustomerApplicationController.submitApplication';

export default class CustomerApplicationForm extends LightningElement {
    @track name = '';
    @track companyName= '';
    @track date= '';
    @track type = '';
    typeOptions = [
        { label: 'Option 1', value: 'Corporation' },
        { label: 'Option 2', value: 'Non-Corporation' },
        
    ];
    @track phone = '';
    @track phoneval = '';
    @track email = '';
    @track emailval = '';
    @track address = '';

    handleNameChange(event) {
        this.name = event.target.value;
    }
    handleCompanyNameChange(event) {
        this.companyName = event.target.value;
    }
    handleDateChange(event) {
        this.date = event.target.value;
    }
    handleTypeChange(event) {
        this.type = event.target.value;
    }

    handlePhoneChange(event) {
        this.phone = event.target.value;
    }
    handlePhone(event) {
        this.phoneval = event.target.value;
    }
    handleEmailChange(event) {
        this.email = event.target.value;
    }
    handleEmailChangeval(event) {
        this.emailval = event.target.value;
    }

    handleAddressChange(event) {
        this.address = event.target.value;
    }

    handleSubmit() {
        // Implement your submission logic here, such as sending data to a server
        console.log('Name:', this.name);
        console.log('Phone:', this.phone);
        console.log('Address:', this.address);

        // Reset fields after submission
        this.name = '';
        this.companyName= '';
        this.date = '';
        this.type= '';
        this.phone = '';
        this.phoneval = '';
        this.email = '';
        this.emailval = '';
        this.address = '';
    }
}