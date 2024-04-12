trigger ContentVersionTriggerPBS on ContentVersion (after insert, after update) {

    if(Trigger.isAfter){
        if(Trigger.isInsert || trigger.isUpdate){
            updatePDFLinkonQuote.updatePdfUrlonQuote(Trigger.new);
        }
    }
}