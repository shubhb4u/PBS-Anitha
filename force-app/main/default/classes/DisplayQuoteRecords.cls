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
                List<Quote> quoList = [SELECT Id, PBS_Pdf_Download__c, Status FROM Quote WHERE Id = :quoId];
                System.debug('quoList:' + quoList);

                    String downLink = quoList.isEmpty() ? '' : quoList[0].PBS_Pdf_Download__c;
                    if (!String.isBlank(downLink)) {
                        return downLink;
                    } 
                }
                
            // Return a default message if quoId is null
            return 'Invalid quoId';
        }
    }