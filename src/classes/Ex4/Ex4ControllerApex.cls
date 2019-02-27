public without sharing class Ex4ControllerApex {

    @AuraEnabled
    public static List<String> getPicklistStatus(){

        List<String> options = new List<String>();

        Schema.DescribeFieldResult fieldResult = Service__c.Type__c.getDescribe();

        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
               options.add(f.getLabel());
        return options;
    }

    @AuraEnabled
    public static List<Booking__c> getBookings(String serviceType, Date dateFrom, Date dateTo, String accountName){

        List<Booking__c> bookings=new List<Booking__c>();

        if(!String.isEmpty(serviceType) && dateFrom == null && dateTo == null && String.isEmpty(accountName))
            try {
                bookings=[ SELECT Id , Name, Created_Date__c, Status__c, Account__r.Name
                    FROM Booking__c 
                    WHERE Id IN (SELECT Booking__c 
                                FROM Booking_Item__c
                                WHERE Service__r.Type__c =: serviceType)];
            } catch (Exception e) {bookings = null;}
        
        else if(!String.isEmpty(serviceType) && dateFrom != null && dateTo != null && !String.isEmpty(serviceType)){
            try{
                bookings=[ SELECT Id , Name, Created_Date__c, Status__c, Account__r.Name
                    FROM Booking__c  
                    WHERE Id IN (SELECT Booking__c 
                                 FROM Booking_Item__c 
                                 WHERE Service__r.Type__c=:serviceType)
                        AND Created_Date__c >= :dateFrom
                        AND Created_Date__c <= :dateTo
                        AND Account__r.Name  = : accountName];
            } catch (Exception e){ bookings = null; }
        }

        else if(!String.isEmpty(serviceType) && dateFrom == null && dateTo == null && !String.isEmpty(serviceType)){
            try{
                bookings=[ SELECT Id , Name, Created_Date__c, Status__c, Account__r.Name
                    FROM Booking__c  
                    WHERE Id IN (SELECT Booking__c 
                                 FROM Booking_Item__c 
                                 WHERE Service__r.Type__c=:serviceType)
                        AND Account__r.Name  = : accountName];
            } catch (Exception e){ bookings = null; }
        }

        return bookings;
    }

    @AuraEnabled
    public static Boolean updateNewStatus(String bookingName){

        Booking__c booking;

        //FIND BOOKING
        try{
            booking = [SELECT Id, Name, Status__c 
                        FROM Booking__c 
                        WHERE Name =: bookingName AND Status__c = 'New']
                    .get(0);
        }catch(Exception e){ return false; }
        //CHECK & UPDATE STATUS ON DB
        if(booking == null && !booking.Status__c.equals('New'))
            return false;
        else{
            booking.Status__c = 'Canceled';
            try{
                update booking;
            }catch(Exception e){ return false; }
        }

        return true;
    }

    @AuraEnabled
    public static Boolean generateInvoice(String bookingName){

        Booking__c booking;
        Invoice__c invoice= new Invoice__c();
        List<AggregateResult> AggregateResults= new List<AggregateResult>();

        //FIND BOOKING
        try{
            booking = [SELECT Id, Name, Status__c 
                        FROM Booking__c 
                        WHERE Name =: bookingName]
                    .get(0);
        }catch(Exception e){ return false; }

        //FIND (SUM PRICE) SERVICE BOOKING_ITEM (BOOKING MASTER-DETAIL) ---> SERVICES
            try{
                aggregateResults = [ SELECT SUM (Service__r.Price__c) tot
                                        FROM Booking_Item__c
                                        WHERE Booking__c =: booking.Id];
                                        
            }catch(Exception e){ return false; }


        //SET-UP INVOICE
            invoice.Booking__c = booking.Id;
            invoice.Total_Amount__c = (Double) aggregateResults.get(0).get('tot');
            invoice.Issue_Date__c=Date.today();


        //INSERT INVOICE
            try{
                insert invoice;
            }catch(Exception e){ return false; }
        
        //UPDATE STATUS ON DB
        booking.Status__c='Invoiced';
        try{
            update booking;
        }catch(Exception e){ return false; }

        return true;
    }
}