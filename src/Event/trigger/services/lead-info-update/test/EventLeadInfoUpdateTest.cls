@isTest
public class EventLeadInfoUpdateTest {
    @IsTest
    static void methodName(){
        Lead testLead = new Lead(LastName = 'Test 01',
                           Disposition__c = 'Caller Disconnected - HANGUP',
                           Batch_Job_Date__c = system.today(),
                           LeadSource = 'Website',
                           Lead_Type__c = '3',
                           Sub_Id__c = 'Form',
                           Inbound_Outbound__c = 'Outbound',
                           State = 'Arizona');
        insert testLead;
        Id testLeadId = testLead.Id;
        
        Event testEvent = new Event(Subject = 'Call',
                                    WhoId = testLeadId,
                                    StartDateTime = Datetime.now(),
                                    EndDateTime = Datetime.now().addMinutes(10));
        
        Test.startTest();
            insert testEvent;
        Test.stopTest();
        
    }
}