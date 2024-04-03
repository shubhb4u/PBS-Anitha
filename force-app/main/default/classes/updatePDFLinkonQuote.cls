public with sharing class updatePDFLinkonQuote {

    // public static void handleContentVersion(List<ContentVersion> newContentDistributions, Map<Id, ContentVersion> oldMap) {
    //     List<Id> contentDocumentIds = new List<Id>();
        
    //     for (ContentDistribution cd : newContentDistributions) {
    //         // Check if the ContentDocumentId is present and the record is new or the DistributionPublicUrl field has changed
    //         if (cd.ContentDocumentId != null && (oldMap == null || cd.DistributionPublicUrl != oldMap.get(cd.Id).DistributionPublicUrl)) {
    //             contentDocumentIds.add(cd.ContentDocumentId);
    //         }
    //     }
        
    //     // Query ContentDocumentLink records related to ContentDocumentIds
    //     Map<Id, Id> contentDocumentToQuoteMap = new Map<Id, Id>();
    //     for (ContentDocumentLink cdl : [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId IN :contentDocumentIds]) {
    //         contentDocumentToQuoteMap.put(cdl.ContentDocumentId, cdl.LinkedEntityId);
    //     }
        
    //     // Query Quote records related to ContentDocumentLink records
    //     Map<Id, Quote> quotesToUpdate = new Map<Id, Quote>();
    //     for (Id contentDocumentId : contentDocumentToQuoteMap.keySet()) {
    //         Id quoteId = contentDocumentToQuoteMap.get(contentDocumentId);
    //         if (!quotesToUpdate.containsKey(quoteId)) {
    //             quotesToUpdate.put(quoteId, new Quote(Id = quoteId, PBS_Pdf_Download__c = ''));
    //         }
    //     }
        
    //     // Update Quote records with DistributionPublicUrl
    //     for (ContentDistribution cd : newContentDistributions) {
    //         if (contentDocumentToQuoteMap.containsKey(cd.ContentDocumentId)) {
    //             Quote relatedQuote = quotesToUpdate.get(contentDocumentToQuoteMap.get(cd.ContentDocumentId));
    //             relatedQuote.PBS_Pdf_Download__c = cd.DistributionPublicUrl;
    //         }
    //     }
        
    //     // Perform update on Quote records
    //     if (!quotesToUpdate.isEmpty()) {
    //         update quotesToUpdate.values();
    //     }
    // }


    // ***************************************************************************************************************************
    
    public static void updatePdfUrlonQuote(List<ContentVersion> conVerList, Map<id,ContentVersion> oldMap){

        Set<Id> conVerIds  =  new Set<Id>();
        for(ContentVersion conVer : conVerList){

            if(conVer.Id != null){
                conVerIds.add(conVer.Id);
            }
        }
        System.debug('conVerIds are ->> '+ conVerIds);

        Map<Id, String> contentDocIdURLmap = new Map<Id, String>();
        if (!conVerList.isEmpty()) {
            for (ContentVersion conV : [Select id, contentDocumentId, VersionDataUrl from ContentVersion where id in : conVerIds]) {
                if (conV.ContentDocumentId != null && conV.VersionDataUrl != null) {
                    contentDocIdURLmap.put(conV.ContentDocumentId, conV.VersionDataUrl);
                }
            }
            System.debug(contentDocIdURLmap);
        }

        Map<Id, String> contentDocIdQuoteIdmap = new Map<Id, String>();
        Set<Id> quoteIds = new Set<Id>();
        if (!contentDocIdURLmap.isEmpty()) {
            for (ContentDocumentLink conDocLink : [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId IN :contentDocIdURLmap.keySet()]) {
                if (conDocLink.ContentDocumentId != null && conDocLink.LinkedEntityId != null) {
                    String url = contentDocIdURLmap.get(conDocLink.ContentDocumentId);
                    contentDocIdQuoteIdmap.put(conDocLink.LinkedEntityId, url);
                    quoteIds.add(conDocLink.LinkedEntityId);
                }
            }
            System.debug(contentDocIdQuoteIdmap);
        }

        Map<Id, Quote> quoteMap = new Map<Id, Quote>([SELECT Id, PBS_Pdf_Download__c FROM Quote WHERE Id IN :quoteIds]);
        List<Quote> updateQuotes = new List<Quote>();

        for (Quote qo : quoteMap.values()) {
            if (contentDocIdQuoteIdmap.containsKey(qo.Id)) {
                qo.PBS_Pdf_Download__c = contentDocIdQuoteIdmap.get(qo.Id);
                updateQuotes.add(qo);
            }
        }
        System.debug('updateQuotes are ->>' + updateQuotes);

        if (!updateQuotes.isEmpty()) {
            update updateQuotes;
        }


    }
}