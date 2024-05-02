import { LightningElement, track } from 'lwc';
import InsertCustomer from '@salesforce/apex/InsertCustomer.insertDetails';

export default class SampleApplicationForm extends LightningElement {
    @track customerName = '';
    @track companyName = '';
    @track dateOfBusinessCommerced = '';
    @track typeOfBusiness = '';
    typeOptions = [
        { label: 'Option 1', value: 'Corporation' },
        { label: 'Option 2', value: 'Non-Corporation' },
    ];
    @track primaryFinanceContact = '';
    @track phone1 = '';
    @track billingEmail = '';
    @track purchasingEmail = '';
    @track businessAddress = '';
    @track bankName = '';
    @track city = '';
    @track state = '';
    @track zipCode = '';
    @track phone = '';
    @track taxNum = '';
    @track dnbNum = '';
    @track accNum = '';
    @track businessType = '';
    typeOptions = [
        { label: 'Option 1', value: 'Savings' },
        { label: 'Option 2', value: 'Credit' },
    ];
    @track otherLoan = '';
    @track companyName1 = '';
    @track companyName2 = '';
    @track companyName3 = '';
    @track phone31 = '';
    @track eMail31 = '';
    @track curbalance31 = '';
    @track creditLimit31 = '';
    @track accOppSnc31 = '';
    @track phone32 = '';
    @track eMail32 = '';
    @track curbalance32 = '';
    @track creditLimit32 = '';
    @track accOppSnc32 = '';
    @track phone33 = '';
    @track eMail33 = '';
    @track curbalance33 = '';
    @track creditLimit33 = '';
    @track accOppSnc33 = '';
    @track showSection1 = true;
    @track showSection2 = false;
    @track showSection3 = false;
    @track showNextButton = true;
    @track showPreviousButton = false;
    @track showSubmitButton = false;
    @track street11 = '';
    @track city11 = '';
    @track state11 = '';
    @track postalCode11 = '';
    @track country11 = '';
    
    // Company
    @track showCompany1 = true;
    @track showCompany2 = false;
    @track showCompany3 = false;
    @track showCompPrvBtn = false;
    @track showCompNxtBtn = true

    handleCustomerNameChange(event) {
        this.customerName = event.target.value;
    }
    handleCompanyNameChange(event) {
        this.companyName = event.target.value;
    }
    handledateOfBusinessCommercedChange(event) {
        this.dateOfBusinessCommerced = event.target.value;
    }
    handletypeOfBusinessChange(event) {
        this.typeOfBusiness = event.target.value;
    }

    handleprimaryFinanceContactChange(event) {
        this.primaryFinanceContact = event.target.value;
    }
    handleSecondaryPhoneChange(event) {
        this.phone1 = event.target.value;
    }
    handleBillingEmailChange(event) {
        this.billingEmail = event.target.value;
    }
    handlePurchasingEmailChange(event) {
        this.purchasingEmail = event.target.value;
    }

    handleBusinessAddressChange(event) {
        this.businessAddress = event.target.value;
    }

    handleBankNameChange(event) {
        this.bankName = event.target.value;
    }
    handleCityChange(event) {
        this.city = event.target.value;
    }
    handleStateProvinceChange(event) {
        this.state = event.target.value;
    }
    handleZipCodeChange(event) {
        this.zipCode = event.target.value;
    }
    handlePrimaryPhoneChange(event) {
        this.phone = event.target.value;
    }
    handleTaxIdNumberChange(event) {
        this.taxNum = event.target.value;
    }
    handleDnbNumberChange(event) {
        this.dnbNum = event.target.value;
    }
    handleAccountNumberChange(event) {
        this.accNum = event.target.value;
    }
    handleTypeOfBusinessChange2(event) {
        this.businessType = event.target.value;
    }
    handleOtherLoanChange(event) {
        this.businessType = event.target.value;
    }
    handleCompanyNameChange31(event) {
        this.companyName1 = event.target.value;
    }
    handleCompanyNameChange32(event) {
        this.companyName2 = event.target.value;
    }
    handleCompanyNameChange33(event) {
        this.companyName3 = event.target.value;
    }

    handlePrimaryPhoneChange31(event) {
        this.phone31 = event.target.value;
    }
    handleEmailChange1(event) {
        this.eMail31 = event.target.value;
    }
    handleCurrentBalanceChange1(event) {
        this.curbalance31 = event.target.value;
    }
    handleCreditLimitChange1(event) {
        this.creditLimit31 = event.target.value;
    }
    handleDateChange1(event) {
        this.accOppSnc31 = event.target.value;
    }

    handlePrimaryPhoneChange32(event) {
        this.phone32 = event.target.value;
    }
    handleEmailChange2(event) {
        this.eMail32 = event.target.value;
    }
    handleCurrentBalanceChange2(event) {
        this.curbalance32 = event.target.value;
    }
    handleCreditLimitChange2(event) {
        this.creditLimit32 = event.target.value;
    }
    handleDateChange2(event) {
        this.accOppSnc32 = event.target.value;
    }

    handlePrimaryPhoneChange33(event) {
        this.phone33 = event.target.value;
    }
    handleEmailChange3(event) {
        this.eMail33 = event.target.value;
    }
    handleCurrentBalanceChange3(event) {
        this.curbalance33 = event.target.value;
    }
    handleCreditLimitChange3(event) {
        this.creditLimit33 = event.target.value;
    }
    handleDateChange3(event) {
        this.accOppSnc33 = event.target.value;
    }
    handleStreetChange11(event) {
        this.street11 = event.target.value;
    }

    handleCityChange11(event) {
        this.city11 = event.target.value;
    }

    handleProvinceChange11(event) {
        this.state11= event.target.value;
    }

    handlePostalCodeChange11(event) {
        this.postalCode11 = event.target.value;
    }

    handleCountryChange11(event) {
        this.country11= event.target.value;
    }

    handleNext() {
        if (this.showSection1) {
            this.showSection1 = false;
            this.showSection2 = true;
            this.showPreviousButton = true;
        } else if (this.showSection2) {
            this.showSection2 = false;
            this.showSection3 = true;
            this.showNextButton = false;
            this.showSubmitButton = true;
        }
    }

    // Company Handle next
    handleCompNxt() {
        if(this.showCompany1) {
            this.showCompany1 = false;
            this.showCompany2 = true;
            this.showCompPrvBtn = true
        } else if(this.showCompany2) {
            this.showCompany2 = false;
            this.showCompany3 = true;
            this.showCompPrvBtn = true;
            this.showCompNxtBtn = false
        }

    }


    handlePrevious() {
        if (this.showSection2) {
            this.showSection1 = true;
            this.showSection2 = false;
            this.showSection3 = false;
            this.showNextButton = true;
            this.showPreviousButton = false;
        }
        else if (this.showSection3) {
            this.showSection1 = false;
            this.showSection2 = true;
            this.showSection3 = false;
            this.showSubmitButton = false;
            this.showNextButton = true;
        }
    }

    // Company handle Prev
    handleCompPrv () {
        if (this.showCompany1) {
            this.showCompNxtBtn = true;
        } else if(this.showCompany2) {
            this.showCompany2 = false;
            this.showCompany1 = true;
            this.showCompPrvBtn = false;
            this.showCompNxtBtn = true;
        } else if(this.showCompany3) {
            this.showCompany3 = false;
            this.showCompany2 = true;
            this.showCompPrvBtn = true;
            this.showCompNxtBtn = true;
        }
    }


    handleSubmit() {
        // Implement your submission logic here, such as sending data to a server
        console.log('Customer Name:', this.customerName);
        console.log('Primary Phone:', this.primaryFinanceContact);
        console.log('Business Address:', this.businessAddress);
        //console.log('Business Address1:', this.businessAddress);


        InsertCustomer({name: this.customerName ,cName: this.companyName , dateOfBusiness: this.dateOfBusinessCommerced ,typeOfBusiness: this.dateOfBusinessCommerced , primaryFinanceContact: this.primaryFinanceContact , phone1: this.phone1 , billingEmail: this.billingEmail,
            purchasingEmail: this.purchasingEmail,bankName: this.bankName,phone: this.phone, taxNum: this.taxNum, dnbNum: this.dnbNum , businessType: this.businessType ,otherLoan: this.otherLoan})
    .then(response => {
            // Handle successful response
            console.log(' Details created successfully:', response);
           //console.log('working');
            //this.showSuccessMessage = true;
            // Dispatch success message
        })
        .catch(error => {
            // Handle error
            console.error('Error creating details :', error);
            // Dispatch error message
        });

        // Reset fields after submission
        
        
          /*  insertDetails(name : this.customerName)
              .then((result) => {
                console.log('data success');
              })
              .catch((error) => {
                this.error = error;
              });*/
          }
    }