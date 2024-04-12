import { LightningElement, track } from 'lwc';
import PdfUploaderController from '@salesforce/apex/PdfUploaderController.insertPdfAttachment';
import { NavigationMixin } from 'lightning/navigation';

export default class OrderSummaryComponent extends NavigationMixin(LightningElement) {
    @track orderSummaryNumber;
    @track CheckYes;
    
    connectedCallback() { 
        const queryParams = new URLSearchParams(window.location.search);
        const param1Value = queryParams.get('orderNumber');
        console.log('Value of param1:', param1Value);
        if (param1Value) {
            this.orderSummaryNumber = param1Value;
            console.log('Checked...'+ param1Value);     
        } else {
            console.log('notfound...'+ param1Value);
        }
    }    

    handleYesButtonClick(event) {
        if(event.target.value == 'Yes'){
            this.CheckYes = true;
        } 
    }

    handleFileUpload(event) {
        const file = event.target.files[0];
        if (file) {
            this.uploadPdf(file);
        }
    }

    uploadPdf(file) {
        const reader = new FileReader();
        reader.onloadend = () => {
            const base64Data = reader.result.split(',')[1];
            const fileName = file.name;
            this.uploadPdfToApex(this.orderSummaryNumber, fileName, base64Data);
        };
        reader.readAsDataURL(file);
    }
    
    uploadPdfToApex(orderSummaryNumber, fileName, base64Data) {
        PdfUploaderController({orderSummaryNumber, fileName, base64Data})
        .then(response => {
            console.log('response:'+response);
            if(response == 'Success') {
                this.handleSubmit(); // Redirect to home page
            }
            else{
                console.error('Error uploading PDF');
            }
        })
        .catch(error => {
            console.error('Error uploading PDF: ' + error);
        });
    }

    handleSubmit() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/' // Redirect to the homepage
            }
        });
    }
}