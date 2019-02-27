trigger TriggerServiceEx5 on Service__c (after update, before delete) {
    if(Trigger.isUpdate)
        TriggerHandlerServiceEx5.updateService(Trigger.newMap, Trigger.oldMap);
    else 
       TriggerHandlerServiceEx5.deleteService(Trigger.oldMap);
}