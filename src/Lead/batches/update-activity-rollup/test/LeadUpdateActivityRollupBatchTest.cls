@isTest
private class LeadUpdateActivityRollupBatchTest {
    
    @IsTest
    static void LeadUpdateActivityRollupBatch_Test(){
        
        User testUser = TestFactory.createTestUser();
        insert testUser;

        Integer numberOfLeads = 65;
        List<Lead> testLeads = new List<Lead>();
        for(Integer i = 1; i <= numberOfLeads; i++){
            String name = 'Test Lead ' + i;
            Lead testLead = TestFactory.newLead(name);
                 testLead.OwnerId = testUser.Id;
            testLeads.add(testLead);
        }
        insert testLEads;

        LeadUpdateActivityRollupBatch batch = new LeadUpdateActivityRollupBatch();
        Test.startTest();
            Database.executeBatch(batch);
        Test.stopTest();
    }
}
