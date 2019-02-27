public with sharing class Ex3ControllerApex {


    @AuraEnabled
    public static Contact simpleAction(Integer who){
        Contact contact=new Contact();
        try{
            contact = [ SELECT ID, Name, Phone FROM Contact]
                .get(who);
        }catch(Exception e){}

        return contact;
    }
    
}