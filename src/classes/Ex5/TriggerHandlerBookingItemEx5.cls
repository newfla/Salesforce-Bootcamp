public with sharing class TriggerHandlerBookingItemEx5 {

    public Static void insertBookingItem(Map<Id,Booking_Item__c> bookingsItem){
        List<Id> servicesIds= new List<Id>();
        List<Id> bookingIds= new List<Id>();

        for (Booking_Item__c bookingItem: bookingsItem.values()){
            servicesIds.add(bookingItem.Service__c);
            bookingIds.add(bookingItem.Booking__c);
        }
        
        Map<Id,Service__c> services = searchServices(servicesIds);
        Map<Id,Booking__c> bookings = searchBooking(bookingIds);
        
        for(Booking_Item__c bookingItem : bookingsItem.values()){

            Service__c service = services.get(bookingItem.Service__c);
            Booking__c booking = bookings.get(bookingItem.Booking__c);
            
            if(booking.Amount__c!=null) //NONOSTANTE IL DEFAULT A 0 RISULTA NULL
                booking.Amount__c += service.Price__c;
            else
                booking.Amount__c = service.Price__c;
            break;
        }
        
        try{
            update bookings.values();
        }catch(Exception e){}
    }

   public Static void deleteBookingItem(Map<Id,Booking_Item__c> bookingsItem){
        List<Id> servicesIds= new List<Id>();
        List<Id> bookingIds= new List<Id>();

        for (Booking_Item__c bookingItem: bookingsItem.values()){
            servicesIds.add(bookingItem.Service__c);
            bookingIds.add(bookingItem.Booking__c);
        }
        
        Map<Id,Service__c> services = searchServices(servicesIds);
        Map<Id,Booking__c> bookings = searchBooking(bookingIds);
        
        for(Booking_Item__c bookingItem : bookingsItem.values()){

            Service__c service = services.get(bookingItem.Service__c);
            Booking__c booking = bookings.get(bookingItem.Booking__c);
            
            //QUI E' PER FORZA DIVERSO DA NULL
                booking.Amount__c -= service.Price__c;
            break;
        }
        
        try{
            update bookings.values();
        }catch(Exception e){}
   } 

    public Static Map<Id,Service__c>searchServices(List<Id> servicesIds){
        List<Service__c> services;
        Map<Id,Service__c> maps= new Map<Id,Service__c>();
        
        try {
            services = [SELECT Id, Price__c
                            FROM Service__c
                            WHERE Id IN : servicesIds];
        } catch (Exception e) {return null;}

        if(services == null || services.isEmpty())
            return null;

        for (Service__c service : services)
           maps.put(service.Id, service);

        return maps;
    }

    public Static Map<Id,Booking__c>searchBooking(List<Id> bookingIds){
        List<Booking__c> bookings;
        Map<Id,Booking__c> maps= new Map<Id,booking__c>();
        
        try {
            bookings = [SELECT Id, Amount__c
                            FROM Booking__c
                            WHERE Id IN : bookingIds];
        } catch (Exception e) {return null;}

        if(bookings == null || bookings.isEmpty())
            return null;

        for (Booking__c booking : bookings)
           maps.put(booking.Id, booking);

        return maps;
    }
}