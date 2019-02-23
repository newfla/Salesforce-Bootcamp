/****************** BOOTCAMP SALESFORCES F.B. ******************/

public with sharing class BookingUtils {

    public List<Booking__c> search( String type, Date dateFrom, Date dateTo ){

        List<Booking__c> bookings=new List<Booking__c>();

        if(!String.isEmpty(type) && dateFrom == null && dateTo == null)
            try {
                bookings=[ SELECT Id 
                    FROM Booking__c 
                    WHERE Id IN (SELECT Booking__c 
                                FROM Booking_Item__c
                                WHERE Service__r.Type__c =: type)];
            
            } catch (Exception e) {bookings = null;}
        
        else if(!String.isEmpty(type) && dateFrom != null && dateTo != null){
            try{
                bookings=[ SELECT Id 
                    FROM Booking__c  
                    WHERE Id IN (SELECT Booking__c 
                                 FROM Booking_Item__c 
                                 WHERE Service__r.Type__c=:type)
                        AND Created_Date__c >= :dateFrom
                        AND Created_Date__c <= :dateTo];
            } catch (Exception e){ bookings = null; }
        }

        return bookings;
    }


    public Boolean updateNewStatus(String bookingNumber){

        Booking__c booking;

        //FIND BOOKING
        try{
            booking = [SELECT Id, Name, Status__c 
                        FROM Booking__c 
                        WHERE Name =: bookingNumber AND Status__c = 'New']
                    .get(0);
        }catch(Exception e){ return false; }
        
        //CHECK & UPDATE STATUS ON DB
        if(booking != null || !booking.Status__c.equals('New'))
            return false;
        else{

            booking.Status__c = 'Canceled';
            try{
                update booking;
            }catch(Exception e){ return false; }
        }
        return true;
    }

    public Boolean generateInvoice(String bookingNumber){

        Booking__c booking;
        Invoice__c invoice= new Invoice__c();
        List<AggregateResult> AggregateResults= new List<AggregateResult>();

        //FIND BOOKING
        try{
            booking = [SELECT Id, Name, Status__c 
                        FROM Booking__c 
                        WHERE Name =: bookingNumber]
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