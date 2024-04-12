public with sharing class AccountController {
    @AuraEnabled
    public static String createAccount(Map<String, Object> accountData) {
        // Extract data from the map
        String accountName = (String) accountData.get('Name');
        String Industry = (String) accountData.get('Industry');
        String email = (String) accountData.get('Email__c');
        String company = (String) accountData.get('Company__c');
        
        // Extract Billing Address fields
        Map<Object, Object> billingAddress = (Map<Object, Object>) 	accountData.get('BillingAddress');
        String BillingCity = (String) billingAddress.get('BillingCity');
        String BillingStateCode = (String) billingAddress.get('BillingStateCode');
        String BillingStreet = (String) billingAddress.get('BillingStreet');
        String BillingPostalCode = (String) billingAddress.get('BillingPostalCode');
        String BillingCountryCode = (String) billingAddress.get('BillingCountryCode');

	// Extract Shipping Address fields
  	Map<Object, Object> shippingAddress = (Map<Object, Object>) 	accountData.get('BillingAddress');
        String ShippingCity = (String) shippingAddress.get('BillingCity');
    	String ShippingStateCode = (String) shippingAddress.get('BillingStateCode');
    	String ShippingStreet = (String) shippingAddress.get('BillingStreet');
    	String ShippingPostalCode = (String) shippingAddress.get('BillingPostalCode');
    	String ShippingCountryCode = (String) shippingAddress.get('BillingCountryCode');
        
        // Create Account
        Account newAccount = new Account();
        newAccount.Name = accountName;
        newAccount.Email__c = email; // corrected variable name
        newAccount.Company__c = company;
        newAccount.Industry = Industry;
        newAccount.BillingCity = BillingCity;
        newAccount.BillingStateCode = BillingStateCode;
        newAccount.BillingStreet = BillingStreet;
        newAccount.BillingCountryCode = BillingCountryCode;
        newAccount.BillingPostalCode = BillingPostalCode;
	newAccount.ShippingCity = BillingCity;
   	newAccount.ShippingStateCode = BillingStateCode;
    	newAccount.ShippingStreet = BillingStreet;
    	newAccount.ShippingCountryCode = BillingCountryCode;
    	newAccount.ShippingPostalCode = BillingPostalCode;
        
        // Set other fields
        
        insert newAccount;
	return newAccount.Id;
        
    }
}