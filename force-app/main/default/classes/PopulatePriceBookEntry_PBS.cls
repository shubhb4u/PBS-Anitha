public with sharing class PopulatePriceBookEntry_PBS implements Database.Batchable<SObject>, Schedulable {

    public Database.QueryLocator start(Database.BatchableContext context) {
        // Query only necessary fields from PricebookEntry object
        return Database.getQueryLocator([SELECT Id, Product2Id, Pricebook2Id, UnitPrice, IsActive FROM PricebookEntry]);
    }

    public void execute(Database.BatchableContext context, List<PricebookEntry> priceBookEntryList) {

        Map<Id, PriceBookEntry_PBS__c> pbEntryMap = new Map<Id, PriceBookEntry_PBS__c>();
        for (PricebookEntry pb : priceBookEntryList) {
            // Create a map of PriceBookEntry_PBS__c records by PricebookEntry Id
            pbEntryMap.put(pb.Id, new PriceBookEntry_PBS__c(
                Product_PBS__c = pb.Product2Id,
                Price_Book_PBS__c = pb.Pricebook2Id,
                Unit_Price_PBS__c = pb.UnitPrice
            ));
        }

        // Retrieve existing PriceBookEntry_PBS__c records by Id
        Map<Id, PriceBookEntry_PBS__c> existingPbEntryMap = new Map<Id, PriceBookEntry_PBS__c>([SELECT Id FROM PriceBookEntry_PBS__c WHERE Id IN :pbEntryMap.keySet()]);

        List<PriceBookEntry_PBS__c> recordsToInsertUpdate = new List<PriceBookEntry_PBS__c>();
        for (Id pbId : pbEntryMap.keySet()) {
            PriceBookEntry_PBS__c newPbEntry = pbEntryMap.get(pbId);
            if (existingPbEntryMap.containsKey(pbId)) {
                // If an existing record exists, update it
                newPbEntry.Id = existingPbEntryMap.get(pbId).Id;
            }
            recordsToInsertUpdate.add(newPbEntry);
        }

        if (!recordsToInsertUpdate.isEmpty()) {
            upsert recordsToInsertUpdate;
        }
    }

    public void finish(Database.BatchableContext context) {
        // Implement any post-processing logic here
    }

    public void execute(SchedulableContext sc) {
        PopulatePriceBookEntry_PBS batchJob = new PopulatePriceBookEntry_PBS();
        Database.executeBatch(batchJob, 200); // Adjust the batch size as needed
    }
}