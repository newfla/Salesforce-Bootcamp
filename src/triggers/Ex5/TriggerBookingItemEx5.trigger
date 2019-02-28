trigger TriggerBookingItemEx5 on Booking_Item__c (after insert, before insert) {
    if(Trigger.isInsert)
        TriggerHandlerBookingItemEx5.insertBookingItem(Trigger.newMap);
    else
        TriggerHandlerBookingItemEx5.deleteBookingItem(Trigger.oldMap);    
}