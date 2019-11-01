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

        insert new List<Lead>{testLead_1, testLead_2, testLead_3, testLead_4};

        AgentLeadInaciveBatch batch = new AgentLeadInaciveBatch();
        Test.startTest();
            Database.executeBatch(batch);
        Test.stopTest();
        
        Lead reassignmentLead = [SELECT OwnerID FROM Lead WHERE LastName = :name_3];
        System.assertEquals(unassignedQueueId, reassignmentLead.OwnerId);

        Set<String> unassignedNames = new Set<String>{name_1, name_2};
        Integer unassignedLeads = [SELECT COUNT() FROM Lead WHERE LastName IN :unassignedNames];
        System.assertEquals(2, unassignedLeads);

        Set<String> unchangedNames = new Set<String>{name_1, name_2};
        Integer notReassignmentLead = [SELECT COUNT() FROM Lead WHERE LastName IN :unchangedNames];
        System.assertEquals(2, notReassignmentLead);
    }
}
