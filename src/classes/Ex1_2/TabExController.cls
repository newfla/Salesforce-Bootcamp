/****************** BOOTCAMP SALESFORCES F.B. ******************/

public with sharing class TabExController {

    public Date dateFrom {get;set;}

    public Date dateTo {get;set;}

    public String type {get;set;}

    public String cancelBooking {get;set;}

    public String generatePDFBooking {get;set;}

    public String generateInvoiceBooking {get;set;}

    public List<Booking__c> bookings {get;set;}

    public Boolean showTable {get;set;}

    private Bookingutils bookingsUtils = new Bookingutils();

    public TabExController(){
        showTable = false;
    }


    public List<SelectOption> getItems() {

        List<SelectOption> options = new List<SelectOption>();

        Schema.DescribeFieldResult fieldResult = Booking__c.Status__c.getDescribe();

        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
               options.add(new SelectOption(f.getLabel(), f.getValue()));
        
        return options;
    }

    public PageReference search(){
        Booking__c book=new Booking__c();

        bookings = bookingsUtils.search(type, dateTo,dateFrom);

        if (bookings == null)
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Check \'From\' and \'To\' date'));
        else
            showTable = true;

        bookings= new List<Booking__c>();
        book.Status__c = 'New';
        bookings.add(book);

        return null;
    }

    public PageReference cancel(){
        if (!bookingsUtils.updateNewStatus(cancelBooking))
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Issue updating Status__c'));
        return null;
    }

    public PageReference generate(){
        if (!bookingsUtils.generateInvoice(generateInvoiceBooking))
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Invoice creation failed'));
        return null;
    }

    public PageReference generatePDF(){
        PageReference printer = new PageReference('/apex/TabExPagePrinter');
        printer.getParameters().put('Booking',generatePDFBooking);
        return printer;
    }

}