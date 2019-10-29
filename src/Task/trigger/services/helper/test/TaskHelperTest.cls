@isTest
public class TaskHelperTest{
    @isTest
    public static void testLeadScoremethod(){
        List<Dail_Attempts__mdt> dailAttempts = [select id, Max_Age__c, Min_Age__c, Dails_Attempt__c, Resting_Period__c from Dail_Attempts__mdt];
        List<Last_Call_By_State__mdt> stateCallTimings = [select id, First_Dail__c, Last_Dial__c, DeveloperName from Last_Call_By_State__mdt];
        
        Lead ld = new Lead(LastName = 'Test 01', Disposition__c = 'Caller Disconnected - HANGUP', Batch_Job_Date__c = system.today(), LeadSource = 'Website', Lead_Type__c = '3', Sub_Id__c = 'Form',
                                 Inbound_Outbound__c = 'Outbound', State = 'Arizona');
        insert ld;
        
        Task taskRecord = new Task(Subject = 'Call', WhoId = ld.Id, Priority='High', Status = 'Completed', ActivityDate = System.Today());
        insert taskRecord;
        Test.setCreatedDate(taskRecord.Id, System.Today());
    }
}