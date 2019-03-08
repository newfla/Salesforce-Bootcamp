global with sharing class BatchCancelEx6Scheduler implements Schedulable{

    public Static String jobName='batchCancel';
    public Static String jobTime='0 0 4 * * ?	';

    global void execute(SchedulableContext sc) {
        Database.executebatch(new batchCancelEx6());
        //System.schedule(jobName, jobTime, this);
   }

}