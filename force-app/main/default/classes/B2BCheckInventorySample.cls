global with sharing class B2BCheckInventorySample implements sfdc_checkout.CartInventoryValidation {
    private static Boolean useHTTPService = false;

    global sfdc_checkout.IntegrationStatus startCartProcessAsync(sfdc_checkout.IntegrationInfo jobInfo, ID cartId) {
        sfdc_checkout.IntegrationStatus integStatus = new sfdc_checkout.IntegrationStatus();
        try {
            Map<String, Decimal> quantitiesFromSalesforce = new Map<String, Decimal>();
            for (CartItem cartItem : [SELECT Sku, Quantity FROM CartItem WHERE CartId = :cartId AND Type = 'Product']) {
                if (String.isBlank(cartItem.Sku)) {
                    String errorMessage = 'The SKUs for all products in your cart must be defined.';
                    return integrationStatusFailedWithCartValidationOutputError(
                        integStatus,
                        errorMessage,
                        jobInfo,
                        cartId
                    );
                }
                quantitiesFromSalesforce.put(cartItem.Sku, cartItem.Quantity);
            }

            if (quantitiesFromSalesforce.isEmpty()) {
                String errorMessage = 'Looks like your cart is empty.';
                return integrationStatusFailedWithCartValidationOutputError(
                    integStatus,
                    errorMessage,
                    jobInfo,
                    cartId
                );
            }

            for (String sku : quantitiesFromSalesforce.keySet()) {
                Decimal quantityFromSalesforce = quantitiesFromSalesforce.get(sku);
                Decimal inventoryAvailable = getProductInventoryAvailable(sku);
                
                if (inventoryAvailable == null){
                    String errorMessage = 'The product with SKU ' + sku + ' could not be found.';
                    return integrationStatusFailedWithCartValidationOutputError(
                       integStatus,
                       errorMessage,
                       jobInfo,
                       cartId
                   );
                } else if (inventoryAvailable < quantityFromSalesforce){
                   String errorMessage = 'Insufficient quantity for the product with SKU ' + sku + ': ' 
                               + quantityFromSalesforce + ' needed, but only '
                               + inventoryAvailable + ' available.';
                   return integrationStatusFailedWithCartValidationOutputError(
                       integStatus,
                       errorMessage,
                       jobInfo,
                       cartId
                   );
                } else {
                    integStatus.status = sfdc_checkout.IntegrationStatus.Status.SUCCESS;
                }
            }
        } catch(Exception e) {
            return integrationStatusFailedWithCartValidationOutputError(
                integStatus,
                'An exception of type ' + e.getTypeName() + ' has occurred: ' + e.getMessage(),
                jobInfo,
                cartId
            );
        }
        return integStatus;
    }

    private Decimal getProductInventoryAvailable(String sku) {
        // Query Product2 object to retrieve Inventory Available for the SKU
        Product2 product = [SELECT Inventory_Available__c FROM Product2 WHERE ProductCode = :sku LIMIT 1];
        if (product != null) {
            return product.Inventory_Available__c;
        }
        return null;
    }
    
    private sfdc_checkout.IntegrationStatus integrationStatusFailedWithCartValidationOutputError(
        sfdc_checkout.IntegrationStatus integrationStatus, String errorMessage, sfdc_checkout.IntegrationInfo jobInfo, Id cartId) {
            integrationStatus.status = sfdc_checkout.IntegrationStatus.Status.FAILED;
            CartValidationOutput cartValidationError = new CartValidationOutput(
                BackgroundOperationId = jobInfo.jobId,
                CartId = cartId,
                Level = 'Error',
                Message = errorMessage.left(255),
                Name = (String)cartId + ':' + jobInfo.jobId,
                RelatedEntityId = cartId,
                Type = 'Inventory'
            );
            insert cartValidationError;
            return integrationStatus;
    }
}