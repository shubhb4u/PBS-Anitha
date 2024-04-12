// This must implement the sfdc_checkout.CartTaxCalculations interface
// in order to be processed by the checkout flow and used for your Taxes integration.
global with sharing class B2BTaxSample implements sfdc_checkout.CartTaxCalculations {
    // You MUST change this to be your service or you must launch your own Heroku Service
    // and add the host in Setup | Security | Remote site settings.
    private static String httpHost = 'https://example.com';
    private static Boolean useHTTPService = false;
    private class ApplicationException extends Exception {}
    global sfdc_checkout.IntegrationStatus startCartProcessAsync(sfdc_checkout.IntegrationInfo jobInfo, Id cartId) {
        sfdc_checkout.IntegrationStatus integStatus = new sfdc_checkout.IntegrationStatus();
        try {
            // In the Spring '20 release, there should be one delivery group per cart.
            // In the future, when multiple delivery groups can be created,
            // this sample should be updated to loop through all delivery groups.
            // We need to get the ID of the delivery group in order to get the DeliverTo info.
            Id cartDeliveryGroupId = [SELECT CartDeliveryGroupId FROM CartItem WHERE CartId = :cartId WITH SECURITY_ENFORCED][0].CartDeliveryGroupId;

            Id curCartAccountId = [SELECT Id, AccountId FROM WebCart WHERE Id=:cartId].AccountId;//custom code
            System.debug('curCartAccountId--->'+curCartAccountId);
            CartDeliveryGroup deliveryGroup = [SELECT DeliverToState, DeliverToCountry FROM CartDeliveryGroup WHERE Id = :cartDeliveryGroupId WITH SECURITY_ENFORCED][0];
            System.debug('deliveryGroup--->'+deliveryGroup);            
            // Get all SKUs, the cart item IDs, and the total prices from the cart items.
            Map<String, Id> cartItemIdsBySKU = new Map<String, Id>();
            System.debug('cartItemIdsBySKU--->'+cartItemIdsBySKU);
            Map<String, Decimal> cartItemTotalPriceBySKU = new Map<String, Decimal>();
            //Custom code
            //Map<Id, Account> accountMap = new Map<Id, Account>();
            //System.debug('accountMap--->'+accountMap);
            
           /* for (Account acc : [SELECT Id, Name, Exempt__c FROM Account WHERE Id = :curCartAccountId]) {
                accountMap.put(acc.Id, acc);
                System.debug('acc--->'+acc);
            }
            System.debug('accountMap-->'+accountMap);*/
            Account currAccId = [SELECT Id, Name, Exempt__c, Manual_Tax__c FROM Account WHERE Id = :curCartAccountId];
                    System.debug('AccId--->'+currAccId);
					System.debug('AccId--->'+currAccId.Exempt__c);
            		System.debug('AccId--->'+currAccId.Manual_Tax__c);
            // Check if the account is exempt from tax calculation
            if(currAccId != null && currAccId.Exempt__c == true || currAccId.Manual_Tax__c == true) {
                integStatus.status = sfdc_checkout.IntegrationStatus.Status.SUCCESS;
                System.debug(' integStatus.status-->'+ integStatus.status);
                return integStatus;
            }else{
                System.debug('cartId--->'+cartId);
                for (CartItem cartItemL : [SELECT Sku,Id, Product2.id,Product2.Product_Exempt__c,Product2Id, TotalPrice, Type FROM CartItem WHERE CartId =:cartId WITH SECURITY_ENFORCED]) {
                    System.debug('cartItem---->'+cartItemL);
                    System.debug('cartItem---->'+cartItemL.Product2);
                     System.debug('cartItem---->'+cartItemL.Product2.id);
                    System.debug('Product2Id--->'+cartItemL.Product2.Product_Exempt__c);
                    
                    String cartItemSKU = '';
                    // CartItem product =[SELECT from CartItem where Id =: cartItem.Id LIMIT 1];
                    //System.debug('product---'+cartItem != null);
                    //System.debug('product1---'+cartItem.Product2.Exempt_Product__c);
                    // system.debug('inside if-->' +cartItem != null && cartItem.Product2.Exempt_Product__c == true && cartItem.Sku != null);
                    
                    if(cartItemL != null && cartItemL.Product2.Product_Exempt__c == true && cartItemL.Sku != null ){
                        system.debug('inside if-->' +cartItemL != null && cartItemL.Product2.Product_Exempt__c == true);
                        integStatus.status = sfdc_checkout.IntegrationStatus.Status.SUCCESS;
                        return integStatus;
                    }
                    
                    if (cartItemL.Type == 'Product') { 
                        /* Product2 curProduct =[SELECT Id,Exempt_Product__c FROM Product2 WHERE Id =:cartItem.Product2Id];
if(curProduct != null && curProduct.Exempt_Product__c == true){
integStatus.status = sfdc_checkout.IntegrationStatus.Status.SUCCESS;
return integStatus;
}*/
                        if (String.isBlank(cartItemL.Sku)) {
                            String errorMessage = 'The SKUs for all products in your cart must be defined.';
                            return integrationStatusFailedWithCartValidationOutputError(
                                integStatus,
                                errorMessage,
                                jobInfo,
                                cartId
                            );
                        }
                        
                        cartItemSKU = cartItemL.Sku;
                        
                    }
                    
                    else if (cartItemL.Type == 'Charge') {
                        // This is an example for a Cart Item of type shipping charge.
                        // For simplicity and testing purposes, we just assign some SKU to this charge so that the taxation external service returns some value.
                        cartItemSKU = 'ChargeSKU';
                    }
                    cartItemIdsBySKU.put(cartItemSKU, cartItemL.Id);
                    cartItemTotalPriceBySKU.put(cartItemSKU, cartItemL.TotalPrice);
                }
                
            }
           
            
                  
            
            // Following snippet of code fetches a mocked static json response from getDataFromStaticResponse.
            // Another example that demonstrates how to call a live 3rd party HTTP Service to fetch the desired 
            // response is implemented in getDataFromExternalService method.
            
            Map<String, TaxDataFromExternalService> rateAndAmountFromExternalServicePerSku = null;
            if(useHTTPService) {
                rateAndAmountFromExternalServicePerSku = getTaxRatesAndAmountsFromExternalService(cartItemTotalPriceBySKU, deliveryGroup.DeliverToState, deliveryGroup.DeliverToCountry);
            } else {
                rateAndAmountFromExternalServicePerSku = getDataFromStaticResponse(cartItemTotalPriceBySKU, deliveryGroup.DeliverToState, deliveryGroup.DeliverToCountry);
            }
            
            // If there are taxes from a previously cancelled checkout, delete them.
            List<Id> cartItemIds = cartItemIdsBySKU.values();
            delete [SELECT Id FROM CartTax WHERE CartItemId IN :cartItemIds WITH SECURITY_ENFORCED];
            
            // For each cart item, insert a new tax line in the CartTax entity.
            // The total tax is automatically rolled up to TotalLineTaxAmount in the corresponding CartItem line.
            CartTax[] cartTaxestoInsert = new CartTax[]{};
                for (String sku : cartItemIdsBySKU.keySet()) {
                    TaxDataFromExternalService rateAndAmountFromExternalService = rateAndAmountFromExternalServicePerSku.get(sku);
                    if (rateAndAmountFromExternalService == null){
                        return integrationStatusFailedWithCartValidationOutputError(
                            integStatus,
                            'The product with sku ' + sku + ' could not be found in the external system',
                            jobInfo,
                            cartId
                        );
                    }
                    // If the sku was found in the external system, add a new CartTax line for that sku
                    // The following fields from CartTax can be filled in:
                    // Amount (required): Calculated tax amount.
                    // CartItemId (required): ID of the cart item.
                    // Description (optional): Description of CartTax.
                    // Name (required): Name of the tax.
                    // TaxCalculationDate (required): Calculation date for this tax line.
                    // TaxRate (optional): The percentage value of the tax. Null if the tax is a flat amount.
                    // TaxType (required): The type of tax, e.g. Actual or Estimated.
                    CartTax tax = new CartTax( 
                        Amount = rateAndAmountFromExternalService.getAmount(),
                        CartItemId = cartItemIdsBySKU.get(sku),
                        Name = rateAndAmountFromExternalService.getTaxName(),
                        TaxCalculationDate = Date.today(),
                        TaxRate = rateAndAmountFromExternalService.getRate(),
                        TaxType = 'Actual'
                    );
                    cartTaxestoInsert.add(tax);
                }
            insert(cartTaxestoInsert);
            integStatus.status = sfdc_checkout.IntegrationStatus.Status.SUCCESS;
        } catch(Exception e) {
            // For testing purposes, this example treats exceptions as user errors, which means they are displayed to the buyer user.
            // In production you probably want this to be an admin-type error. In that case, throw the exception here
            // and make sure that a notification system is in place to let the admin know that the error occurred.
            // See the readme section about error handling for details about how to create that notification.
            return integrationStatusFailedWithCartValidationOutputError(
                integStatus,
                'An exception of type ' + e.getTypeName() + ' has occurred: ' + e.getMessage(),
                jobInfo,
                cartId
            );
        }
        return integStatus;
    }
    
    private Map<String, TaxDataFromExternalService> getDataFromStaticResponse(Map<String, Decimal> cartItemTotalAmountBySKU, String state, String country) {
        if (cartItemTotalAmountBySKU == null) {
            throw new ApplicationException('Input SKUs list is empty or undefined.');
        }
        
        Decimal taxRate = 0.08;
        
        Map<String, TaxDataFromExternalService> taxDataFromStaticServiceBySKU = new Map<String, TaxDataFromExternalService>();
        for (String sku : cartItemTotalAmountBySKU.keySet()) {
            taxDataFromStaticServiceBySKU.put(sku, new TaxDataFromExternalService(
                taxRate,
                cartItemTotalAmountBySKU.get(sku) * taxRate,
                'GST'
            ));
        }
        return taxDataFromStaticServiceBySKU;
    }
    
    private Map<String, TaxDataFromExternalService> getTaxRatesAndAmountsFromExternalService (
        Map<String, Decimal> cartItemTotalAmountBySKU, String state, String country) {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            Integer successfulHttpRequest = 200;
            String encodedState = (state == null) ? '' : EncodingUtil.urlEncode(state, 'UTF-8').replace('+', '%20');
            String encodedCountry = (country == null) ? '' : EncodingUtil.urlEncode(country, 'UTF-8').replace('+', '%20');
            
            Map<String, Decimal> encodedCartItemTotalAmountBySKU = new Map<String, Decimal>();
            for(String sku: cartItemTotalAmountBySKU.keySet()) {
                encodedCartItemTotalAmountBySKU.put(EncodingUtil.urlEncode(sku, 'UTF-8'), cartItemTotalAmountBySKU.get(sku));
            }
            
            String requestURL = httpHost + '/get-tax-rates?state=' + encodedState
                + '&country=' + encodedCountry
                + '&amountsBySKU=' + JSON.serialize(encodedCartItemTotalAmountBySKU);
            request.setEndpoint(requestURL);
            request.setMethod('GET');
            HttpResponse response = http.send(request);
            
            // If the request is successful, parse the JSON response;
            // The response includes the tax amount, rate, and name for each SKU. It looks something like this:
            // {"SKU_1_september10-1568355297":{"taxAmount":2.8229012971048855,"taxRate":0.08,"taxName":"GST"},"SKU_0_september10-1568355296":{"taxAmount":5.0479003481482385,"taxRate":0.08,"taxName":"GST"}}
            if (response.getStatusCode() == successfulHttpRequest) {
                Map<String, Object> resultsFromExternalServiceBySKU = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                Map<String, TaxDataFromExternalService> taxDataFromExternalServiceBySKU = new Map<String, TaxDataFromExternalService>();
                for (String sku : resultsFromExternalServiceBySKU.keySet()) {
                    Map<String, Object> rateAndAmountFromExternalService = (Map<String, Object>) resultsFromExternalServiceBySKU.get(sku);
                    taxDataFromExternalServiceBySKU.put(sku, new TaxDataFromExternalService(
                        (Decimal)rateAndAmountFromExternalService.get('taxRate'),
                        (Decimal)rateAndAmountFromExternalService.get('taxAmount'),
                        (String)rateAndAmountFromExternalService.get('taxName')
                    ));
                }
                return taxDataFromExternalServiceBySKU;
            } else if(response.getStatusCode() == 404) {
                throw new CalloutException ('404. You must create a sample application or add your own service which returns a valid response');
            } else {
                throw new CalloutException ('There was a problem with the request. Error: ' + response.getStatusCode());
            }
        }
    
    // Structure to store the tax data retrieved from external service
    // This simplifies our ability to access it when storing it in Salesforce's CartTax entity
    Class TaxDataFromExternalService {
        private Decimal rate;
        private Decimal amount;
        private String taxName;
        
        public TaxDataFromExternalService () {
            rate = 0.0;
            amount = 0.0;
            taxName = '';
        }
        
        public TaxDataFromExternalService (Decimal someRate, Decimal someAmount, String someTaxName) {
            rate = someRate;
            amount = someAmount;
            taxName = someTaxName;
        }
        
        public Decimal getRate() {
            return rate;
        }
        
        public Decimal getAmount() {
            return amount;
        }
        
        public String getTaxName() {
            return taxName;
        }
    }
    
    private sfdc_checkout.IntegrationStatus integrationStatusFailedWithCartValidationOutputError(
        sfdc_checkout.IntegrationStatus integrationStatus, String errorMessage, sfdc_checkout.IntegrationInfo jobInfo, Id cartId) {
            integrationStatus.status = sfdc_checkout.IntegrationStatus.Status.FAILED;
            // For the error to be propagated to the user, we need to add a new CartValidationOutput record.
            // The following fields must be populated:
            // BackgroundOperationId: Foreign Key to the BackgroundOperation
            // CartId: Foreign key to the WebCart that this validation line is for
            // Level (required): One of the following - Info, Error, or Warning
            // Message (optional): Message displayed to the user (maximum 255 characters)
            // Name (required): The name of this CartValidationOutput record. For example CartId:BackgroundOperationId
            // RelatedEntityId (required): Foreign key to WebCart, CartItem, CartDeliveryGroup
            // Type (required): One of the following - SystemError, Inventory, Taxes, Pricing, Shipping, Entitlement, Other
            CartValidationOutput cartValidationError = new CartValidationOutput(
                BackgroundOperationId = jobInfo.jobId,
                CartId = cartId,
                Level = 'Error',
                Message = errorMessage.left(255),
                Name = (String)cartId + ':' + jobInfo.jobId,
                RelatedEntityId = cartId,
                Type = 'Taxes'
            );
            insert(cartValidationError);
            return integrationStatus;
        }
}