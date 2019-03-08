global with sharing class BatchCancelEx6 implements Database.Batchable<sObject>, Database.Stateful{

    global final String query = 'SELECT Id, Status__c, FROM Bokking__c WHERE Status__c == \'New\' AND Created_Date__c <= LAST_N_DAYS :';

    private List<Database.SaveResult> listResult;

    global Integer totErrors=0;

    global Database.QueryLocator start(Database.BatchableContext BC){

        Double days=40; 
        
        try {
            days = [SELECT Id, Update_Timer__c
                    FROM Schedule_Batch_Cancel__mdt
                    WHERE MasterLabel = 'DaysCancel' 
                    LIMIT 1].Update_Timer__c;
           
        } catch (Exception e) {}
        return Database.getQueryLocator(query+days);
    }

    global void execute(Database.BatchableContext BC,List<sObject>scope){

      for(Sobject s : scope){
          Booking__c booking = (Booking__c) s;
          booking.Status__c = 'Canceled';
      }

      listResult = Database.update(scope,false);

   }


   global void finish(Database.BatchableContext BC){
       for (Database.SaveResult result : listResult){
            if(!result.isSuccess())
                totErrors+=result.getErrors().size();
        }
   }
}