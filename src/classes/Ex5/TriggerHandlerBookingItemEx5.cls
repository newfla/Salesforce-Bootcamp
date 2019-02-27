public with sharing class TriggerHandlerBookingItemEx5 {

    public Static void insertBookingItem(Map<Id,Booking_Item__c> bookingsItem){
        List<Id> servicesIds= new List<Id>();

        for (Booking_Item__c booking: bookingsItem.values()) 
            servicesIds.add(booking.Service__c);

        List<Service__c> services= searchServices(servicesIds);

        for(Booking_Item__c bookingItem : bookingsItem.values()){
            for(Service__c service : services){
                if(service.id == bookingItem.Service__c){
                    bookingItem.Booking__r.Amount__c += service.Price__c; 
                    break;
                }
            }
        }

        List<Booking__c> bookings= new List<Booking__c>();
        for(Booking_Item__c bookingItem : bookingsItem.values())
            bookings.add(bookingItem.Booking__r);
        try{
            update bookings;
        }catch(Exception e){}


    }

    public Static List<Service__c> searchServices(List<Id> servicesIds){
        try {
            return [SELECT Id, Price__c
                            FROM Service__c
                            WHERE Id IN : servicesIds];
        } catch (Exception e) {return null;}

    }
}