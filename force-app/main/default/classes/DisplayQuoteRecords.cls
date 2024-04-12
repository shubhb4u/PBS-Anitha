/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-08-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class DisplayQuoteRecords {


    @AuraEnabled
    public static List<Quote> DisplayQuoteRecs(string contactId) {
        if(ContactId!=null){
        List<Quote> qLidt=[select id,ContactId,Status,Name,ExpirationDate,TotalPrice,PBS_Pdf_Download__c,QuoteNumber from Quote where ContactId = : ContactId];
        System.debug('qLidt:'+qLidt);
        return qLidt;
        }else{
            List<Quote> qLidt1=[select id,ContactId from Quote where ContactId = '003Hp00002urk0KIAQ'];
           return qLidt1; 
        }
    }
        

    @AuraEnabled
    public static String getDownloadLink(String quoId) {
            if (quoId != null) {
                List<Quote> quoList = [SELECT Id, PBS_Pdf_Download__c FROM Quote WHERE Id = :quoId];
                System.debug('quoList:' + quoList);
                String downLink = quoList.isEmpty() ? '' : quoList[0].PBS_Pdf_Download__c;
                if (!String.isBlank(downLink)) {
                    return downLink;
                } else {
                    return 'Download link not available';
                }
            }
            // Return a default message if quoId is null
            return 'Invalid quoId';
        }
    }


    // @AuraEnabled
    // public static String getDistributionLink(String conDistId) {

    //     String pdfUrl = '';
    //     ContentDistribution cd = [select Id, DistributionPublicUrl, ContentDownloadUrl, PdfDownloadUrl from ContentDistribution where id =: conDistId limit 1];
    //     pdfUrl = pdfUrl+ cd.DistributionPublicUrl;
    //     return pdfUrl;
    // }

    // @AuraEnabled
    // public static String getDownloadLink(String quoId) {
    // String downloadUrl = '';
    // String publicUrlforDownload  =  '';

    // // Query the latest ContentDocumentLink for the given quoId
    // List<ContentDocumentLink> cdl = [SELECT ContentDocument.Id FROM ContentDocumentLink WHERE LinkedEntityId = :quoId ORDER BY ContentDocument.CreatedDate DESC LIMIT 1];
    
    // if (!cdl.isEmpty()) {
    //     // Query the ContentVersion related to the ContentDocument
    //     ContentVersion cv = [SELECT Id FROM ContentVersion WHERE ContentDocumentId = :cdl[0].ContentDocument.Id LIMIT 1];
        
    //     if (cv != null) {
    //         // Create a new ContentDistribution
    //         ContentDistribution cd = new ContentDistribution(
    //             Name = 'Test',
    //             ContentVersionId = cv.Id,
    //             PreferencesAllowViewInBrowser = true,
    //             PreferencesLinkLatestVersion = true,
    //             PreferencesNotifyOnVisit = false,
    //             PreferencesPasswordRequired = false,
    //             PreferencesAllowOriginalDownload = true
    //         );
    //         insert cd;

    //         // Check if the ContentDistribution was successfully inserted
    //         if (cd.Id != null) {
    //             // Get the download URL using the inserted ContentDistribution Id
    //             downloadUrl = getDistributionLink(cd.Id);

    //             // Update the Quote record with the download URL
    //             if (quoId != null && downloadUrl != '') {
    //                 Quote quoteRecord = [SELECT Id, PBS_Pdf_Download__c FROM Quote WHERE Id = :quoId LIMIT 1];
    //                 if (quoteRecord != null) {
    //                     quoteRecord.PBS_Pdf_Download__c = downloadUrl;
    //                     update quoteRecord;
    //                     System.debug('Quote PDF link is --->>> '+ quoteRecord.PBS_Pdf_Download__c);
    //                 } else {
    //                     System.debug('Quote record not found for the given quoId');
    //                 }
    //             } else {
    //                 System.debug('quoId is null');
    //             }
    //         } else {
    //             System.debug('ContentDistribution insertion failed');
    //         }
    //     } else {
    //         System.debug('ContentVersion not found for the ContentDocument');
    //     }
    // } else {
    //     System.debug('No ContentDocumentLink found for the given quoId');
    // }

    // List<Quote> updatedQuote =  [Select id, PBS_Pdf_Download__c from quote where id =: quoId];
    // publicUrlforDownload =  updatedQuote[0].PBS_Pdf_Download__c;

    // return publicUrlforDownload;



            //0Q0Hs000003C2CFKA0
            
        // Set<Id> documentIds = new Set<Id>();
        
        // List<ContentDocumentLink> cdls = [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :quoId];
        // System.debug('cdls ->>>' + cdls);

        // if (!cdls.isEmpty()) {
        //     for (ContentDocumentLink cdl : cdls) {
        //         documentIds.add(cdl.ContentDocumentId);
        //         System.debug('documentIds ->>>' + documentIds);
        //     }
        // }

        // // Getting the corresponding content document record 
        // List<ContentDocument> documents = [SELECT Id FROM ContentDocument WHERE Id IN :documentIds];
        // if (!documents.isEmpty()) {
        //     System.debug('documents ->>>' + documents[0].Id);

        //     Set<Id> conDocIds = new Set<Id>();
        //     for (ContentDocument cd : documents) {
        //         if (cd.Id != null) {
        //             conDocIds.add(cd.Id);
        //         }
        //     }

            

            // conDistList = [SELECT Id, ContentDocumentId, ContentDownloadUrl,DistributionPublicUrl  FROM ContentDistribution WHERE ContentDocumentId IN :conDocIds ORDER BY CreatedDate DESC LIMIT 1];
            
            // downloadUrl = String.valueOf(conDistList[0].ContentDownloadUrl);
            // System.debug('downloadUrl ->>>' + downloadUrl);
            // } else {
            // Handle the case when the documents list is empty
            //     System.debug('No documents found for the given quote.');
            // }
       
    // }

// }