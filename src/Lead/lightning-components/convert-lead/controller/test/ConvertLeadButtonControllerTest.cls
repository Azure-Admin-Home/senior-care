@isTest
private class ConvertLeadButtonControllerTest {
    @IsTest
    static void convertLead_test(){
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;

        User testUser = new User(ProfileId = profileId,
                                 LastName = 'last',
                                 Phone = '7896541236',
                                 Email = 'puser000@amamama.com',
                                 Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                                 CompanyName = 'TEST',
                                 Title = 'title',
                                 Alias = 'alias',
                                 TimeZoneSidKey = 'America/Los_Angeles',
                                 EmailEncodingKey = 'UTF-8',
                                 LanguageLocaleKey = 'en_US',
                                 LocaleSidKey = 'en_US',
                                 Server_URL__c = 'https://test-service.com');
        insert testUser;
        
        Lead testLead = new Lead(firstName = 'James111111',
                                 lastName = '111sdskjjhd',
                                 company = 'Walmart11',
                                 status = 'contacted',
                                 OwnerId = testUser.Id) ;
        insert testLead;

        Test.startTest();
           Map<String, Id> response =ConvertLeadButtonController.convertLead(testLead.Id); 
        Test.stopTest();
    }
}