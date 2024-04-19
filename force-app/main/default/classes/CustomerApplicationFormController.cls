// CustomerApplicationFormController.cls
public with sharing class CustomerApplicationFormController {
    
    @AuraEnabled
    public static void submitApplication(String accountName,String street, String city, String country, String province, String postalCode) {
        System.debug('accountName--->'+accountName);
        // Perform any necessary validation here
        
        // Create a new CustomerApplication record
        B2B_Customer__c newApplication = new B2B_Customer__c();
        newApplication.Name = accountName;
        newApplication.Company_Billing_Address__Street__s = street;
        newApplication.Company_Billing_Address__City__s = city;
        newApplication.Company_Billing_Address__CountryCode__s = country;
        newApplication.Company_Billing_Address__StateCode__s = province;
        newApplication.Company_Billing_Address__PostalCode__s = postalCode;
        
        
        
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