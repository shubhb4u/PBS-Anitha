public with sharing class CustomerApplicationController {
    
    @AuraEnabled
    public static void submitApplication(String customerName/*, String companyName, Date businessDate, String businessType, String businessAddress, String primaryPhone, String secondaryPhone, String billingEmail, String purchasingEmail*/) {
        // Perform any necessary validation here
        System.debug(customerName);
        //System.debug(companyName);
        
        // Create a new CustomerApplication record
        B2B_Customer__c newApplication = new B2B_Customer__c();
        newApplication.Name = customerName;
       /* newApplication.Company_Name__c = companyName;
        newApplication.Date__c = businessDate;
        newApplication.Type_of_Business__c = businessType;
        newApplication.Primary_Finance_Contact__c = primaryPhone;*/
       
        
        // Insert the record
        try {
            insert newApplication;
        } catch (Exception e) {
            // Handle any exceptions, e.g., log the error
            System.debug('Error inserting customer application: ' + e.getMessage());
            throw new AuraHandledException('Failed to submit application. Please try again later.');
        }
    }
}