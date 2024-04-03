trigger ContentVersionTriggerPBS on ContentVersion (after insert, after Update) {

    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUpdate){
            updatePDFLinkonQuote.updatePdfUrlonQuote(Trigger.new, Trigger.oldMap);
        }
    }
}