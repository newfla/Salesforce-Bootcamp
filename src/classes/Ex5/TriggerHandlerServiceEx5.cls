public with sharing class TriggerHandlerServiceEx5 {

    public Static void updateService(Map<Id,Service__c> services, Map<Id,Service__c> servicesOld){
       List<Booking__c> bookings = new List<Booking__c>();
       List<Booking_Item__c> items = TriggerHandlerServiceEx5.searchBookingItemsByService(services.keySet());

       if(items==null)
            return;


       for(Booking_Item__c bookItem: items){
           for(Id idService: services.keySet()){
               if(idService == bookItem.Service__c){
                   bookItem.Booking__r.Amount__c += (services.get(idService).Price__c - servicesOld.get(idService).Price__c) ;
                   bookings.add(bookItem.Booking__r);
                   break;
               }
           }
       }
       try{
           update bookings;
       }catch(Exception e){}
    }

    public Static void deleteService(Map<Id,Service__c> services){

        List<Booking__c> bookings = new List<Booking__c>();
        List<Booking_Item__c> items = TriggerHandlerServiceEx5.searchBookingItemsByService(services.keySet());

        if(items==null)
            return;

        for(Booking_Item__c bookItem: items){
           for(Id idService: services.keySet()){
               if(idService == bookItem.Service__c){
                   bookItem.Booking__r.Amount__c -= services.get(idService).Price__c;
                   bookings.add(bookItem.Booking__r);
                   break;
               }
           }
       }
       try{
           update bookings;
       }catch(Exception e){}
        
    }

    public Static List<Booking_Item__c> searchBookingItemsByService(Set<Id> ids){

        List<Booking_Item__c> items=new List<Booking_Item__c>();

        try{
           items= [SELECT id, Name, Booking__c, Service__c, Booking__r.Amount__c 
                    FROM Booking_Item__c
                    WHERE Service__c IN : ids AND Booking__r.Status__c = 'New'];
       }catch(Exception e){return null;}
       return items;
    }
}