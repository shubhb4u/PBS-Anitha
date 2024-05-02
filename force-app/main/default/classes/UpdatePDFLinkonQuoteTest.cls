@isTest
private class UpdatePDFLinkonQuoteTest {
    @isTest
    static void testUpdatePdfUrlonQuote() {
        // Create ContentVersions
        List<ContentVersion> contentVersions = new List<ContentVersion>();
        for(Integer i = 0; i < 5; i++) {
            ContentVersion cv = new ContentVersion(
                Title = 'Test Content Version ' + i,
                VersionData = Blob.valueOf('Test Data'),
                PathOnClient = 'Test Path ' + i
            );
            contentVersions.add(cv);
        }
        insert contentVersions;

        // Create mock Quote record
        Quote mockQuote = new Quote(
            Name = 'Test Quote'
            // Add any required fields here
        );
        insert mockQuote;

        // Create ContentDocumentLinks
        List<ContentDocumentLink> contentDocumentLinks = new List<ContentDocumentLink>();
        for(ContentVersion cv : contentVersions) {
            ContentDocumentLink cdl = new ContentDocumentLink(
                ContentDocumentId = cv.ContentDocumentId,
                LinkedEntityId = mockQuote.Id, // Mock Quote Id
                ShareType = 'I'
            );
            contentDocumentLinks.add(cdl);
        }
        insert contentDocumentLinks;

        Test.startTest();
        // Call the method to be tested
        updatePDFLinkonQuote.updatePdfUrlonQuote(contentVersions);
        Test.stopTest();

        // Verify that Quotes were updated
        List<Quote> updatedQuotes = [SELECT Id, PBS_Pdf_Download__c FROM Quote];
        System.assertEquals(contentVersions.size(), updatedQuotes.size(), 'Number of Quotes should match the number of ContentVersions');
        for(Quote q : updatedQuotes) {
            System.assertNotEquals(null, q.PBS_Pdf_Download__c, 'PDF Download URL should not be null');
        }
    }
}