public with sharing class InsertCustomer {
    @AuraEnabled
    public static string insertDetails(String name, String cName, Date dateOfBusiness,/* String typeOfBusiness,*/ String primaryFinanceContact, String phone1, String billingEmail,
                                      String purchasingEmail, String bankName, String phone, Integer taxNum, Integer dnbNum) {
        try {

            List<B2B_Customer__c> Details = new List<B2B_Customer__c>();
            B2B_Customer__c newApplication = new B2B_Customer__c();

            newApplication.Name = name;
            //accDetails.LastName=name;
            newApplication.Company_Name__c = cName;
            newApplication.Date__c = dateOfBusiness;
            //newApplication.Type_of_Business__c = typeOfBusiness;
            newApplication.Primary_Finance_Contact__c = primaryFinanceContact;
            newApplication.Phone1__c = phone1;
            newApplication.E_mail_Billing__c = billingEmail;
            newApplication.E_mail_Purchasing__c = purchasingEmail;
            newApplication.Bank_Name__c = bankName;
            newApplication.Phone__c = phone;
            newApplication.Tax_I_D_Number__c = taxNum;
            newApplication.DNB_Number__c = dnbNum;
            //newApplication.Type_of_Business__c = businessType;
           // newApplication.Other_Loan__c = otherLoan;

            Details.add(newApplication);
            insert Details;

            return 'Success';
        } catch (Exception e) {
            System.debug('Failed');
            return 'Failed ' + e.getMessage();
        }
    }
}