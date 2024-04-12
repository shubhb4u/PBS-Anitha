public with sharing class PdfUploaderController {
    @AuraEnabled
    public static String insertPdfAttachment(String orderSummaryNumber, String fileName, String base64Data) {
        
        orderSummary ord = [SELECT Id, OrderNumber,OriginalOrderId FROM orderSummary where OrderNumber =: orderSummaryNumber LIMIT 1];
        System.debug('OrderSummary'+ord);
        ContentVersion contentVersion = new ContentVersion(
            Title = fileName,
            PathOnClient = fileName,
            VersionData = EncodingUtil.base64Decode(base64Data), // Decode base64 string to Blob
            IsMajorVersion = true
        );

        // Insert ContentVersion record
        insert contentVersion;
		system.debug('contentVersion' +contentVersion);
        // Create new ContentDocumentLink to relate the file to the Order Summary
        Id documentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id LIMIT 1].ContentDocumentId;
        ContentDocumentLink contentLink = new ContentDocumentLink(
            ContentDocumentId = documentId,
            LinkedEntityId = ord.Id,
            ShareType = 'V', // 'V' for sharing with all users who can view the record
            Visibility = 'AllUsers' // All users who can see the record will also see the file
        );

        // Insert ContentDocumentLink record
        insert contentLink;

        return orderSummaryNumber; // Return the Id of the inserted ContentVersion
    }
}