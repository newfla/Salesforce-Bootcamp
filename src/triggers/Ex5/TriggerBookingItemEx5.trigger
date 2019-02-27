trigger TriggerBookingItemEx5 on Booking_Item__c (after insert) {
    if(Trigger.isInsert)
        TriggerHandlerBookingItemEx5.insertBookingItem(Trigger.newMap);    
}