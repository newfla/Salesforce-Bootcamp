/****************** BOOTCAMP SALESFORCES F.B. ******************/

public with sharing class BookingPrinter {

    public List<Invoice__C> invoices {get;set;}

    public List<Booking__c> bookings {get;set;}

    public BookingPrinter(){
        String bookingName=ApexPages.currentPage().getParameters().get('Booking');

        try{
            invoices = [ SELECT Issue_Date__c, Total_Amount__c
                            FROM Invoice__C
                            WHERE Booking__r.Name = :bookingName];

            bookings= [ SELECT Name, Created_Date__c FROM Booking__c WHERE Name = : bookingName];
            

        }catch(Exception e){ invoices=new List<Invoice__C> (); bookings=new List<Booking__c>(); }
    }
}