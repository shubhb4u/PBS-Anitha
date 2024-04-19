trigger quoteTrigger on Quote (after  insert, after update) {

    if(Trigger.isAfter){
        if(Trigger.isUpdate || Trigger.isInsert){
            generateQuotePdfDocument.CreateQuoteonInsert(Trigger.new);
        }
    }
}