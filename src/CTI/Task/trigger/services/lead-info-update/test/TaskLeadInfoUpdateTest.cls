@isTest
private class TaskLeadInfoUpdateTest {
    
    @IsTest
    static void populateLeadFields_byTaskFields_Test(){
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
        
        String subjectName = 'MISC - Hang-up';
        Task testTask = new Task(TaskSubtype = 'Call',
                                 Subject = subjectName,
                                 WhoId = testLeadId,
                                 Priority='High',
                                 Status = 'Completed',
                                 ActivityDate = System.Today());
        
        Test.startTest();
            insert testTask;
            Datetime taskCreatedDate = [SELECT CreatedDate FROM Task WHERE Id = :testTask.Id LIMIT 1].CreatedDate;
        Test.stopTest();

        Lead updatedLead = [SELECT Disposition__c, Last_Dial_Attempt__c FROM Lead WHERE Id = :testLeadId LIMIT 1];
        System.assertEquals(subjectName, updatedLead.Disposition__c);
        System.assertEquals(taskCreatedDate, updatedLead.Last_Dial_Attempt__c);
    }
}