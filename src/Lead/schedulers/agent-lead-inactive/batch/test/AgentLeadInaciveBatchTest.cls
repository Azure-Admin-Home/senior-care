@isTest
private class AgentLeadInaciveBatchTest {
    @IsTest
    static void AgentLeadInactiveBatch_Test(){
        
        User testUser = TestFactory.createTestUser();
        insert testUser;
        
        List<String> aepCallbackYearVals = TestFactory.getPicklistValues('Lead', 'AEP_Callback_Year__c');

        String name_1 = 'Not Changed Lead 1';
        Lead testLead_1 = TestFactory.newLead(name_1);
             testLead_1.OwnerId = testUser.Id;
             testLead_1.AEP_Callback_Year__c = aepCallbackYearVals[0];
             
        String name_2 = 'Not Changed Lead 2';
        Lead testLead_2 = TestFactory.newLead(name_2);
             testLead_2.OwnerId = testUser.Id;
             testLead_2.All_Event_Activities_for_Last_7_Days__c = 1;
        
        String name_3 = 'Changed Lead 1';
        Lead testLead_3 = TestFactory.newLead(name_3);
             testLead_3.OwnerId = testUser.Id;

        Id unassignedQueueId = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'Unassigned' LIMIT 1].Id;

        String name_4 = 'Not Changed Lead 3';
        Lead testLead_4 = TestFactory.newLead(name_4);
             testLead_4.OwnerId = unassignedQueueId;

        String name_5 = 'Not Changed Lead 4';
        Lead testLead_5 = TestFactory.newLead(name_5);
             testLead_5.OwnerId = testUser.Id;

        insert new List<Lead>{testLead_1, testLead_2, testLead_3, testLead_4, testLead_5};

        Datetime createdDate = Datetime.now().addDays(-8);
        Test.setCreatedDate(testLead_3.Id, createdDate);

        AgentLeadInaciveBatch batch = new AgentLeadInaciveBatch();
        Test.startTest();
            Database.executeBatch(batch);
        Test.stopTest();
        
        Lead reassignmentLead = [SELECT OwnerID, AEP_Callback_Year__c, All_Event_Activities_for_Last_7_Days__c FROM Lead WHERE LastName = :name_3];
        System.assertEquals(unassignedQueueId, reassignmentLead.OwnerId);
        System.assertEquals(null, reassignmentLead.AEP_Callback_Year__c);
        System.assertEquals(0, reassignmentLead.All_Event_Activities_for_Last_7_Days__c);

        Integer unassignedLeads = [SELECT COUNT() FROM Lead WHERE OwnerId = :unassignedQueueId];
        System.assertEquals(2, unassignedLeads);

        Integer notReassignmentLead = [SELECT COUNT() FROM Lead WHERE OwnerId != :unassignedQueueId];
        System.assertEquals(3, notReassignmentLead);
    }
}
