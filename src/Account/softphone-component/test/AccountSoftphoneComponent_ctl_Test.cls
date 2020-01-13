@isTest
public class AccountSoftphoneComponent_ctl_Test {
    
    @testSetup
    public static void testData(){
        Id personAcc = [SELECT Id FROM RecordType WHERE (Name='Person Account') AND (SobjectType='Account')].Id;
        Account account = new Account(LastName='TestAccount', RecordTypeId = personAcc,Phone='12345678',PersonMobilePhone='12345678',PersonHomePhone='12345678',PersonOtherPhone='12345678', PersonAssistantPhone='12345678');
        insert account;
    }
    
    @isTest
    public static void testgetRecentWorkLead()
    {
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
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
            Server_URL__c = 'https://scb-sf-web1.callproxe.com'
             
          //  UserRoleId = r.Id
        ); insert u;
        System.runAs(u){
            AccountSoftphoneComponent_ctl.getAgentDetails();
        }
        
        // qsuiteUtilities.nextCallWrapper wrap =new qsuiteUtilities.nextCallWrapper();
        // List<String> tempList = new List<String>{'a','b','c'};
        //     wrap.on_hook = tempList;
        // wrap.transfer_conference = tempList;
        // wrap.success = tempList;
        // wrap.call_list_id = tempList;
        // wrap.abandoned = tempList;
        // wrap.callback_alert = tempList;
        // wrap.campaign = tempList;
        // wrap.action = tempList;
        // wrap.non_media_event = tempList;
        // wrap.call_type_text = tempList;
        // wrap.type = tempList;
        // wrap.uuid = tempList;
        // wrap.transfer_type = tempList;
        // wrap.transfer_starter = tempList;
        
        Test.startTest();    
        Test.setMock(HttpCalloutMock.class, new qsuiteUtilities_Mock());
        Account testAccount = [SELECT Id FROM Account WHERE LastName='TestAccount' LIMIT 1];
        Boolean isPersonAccount = AccountSoftphoneComponent_ctl.checkIfAccountPersonal(testAccount.Id);
        Account tempAccount = AccountSoftphoneComponent_ctl.getAccount(testAccount.Id,'33227ea9-d9d0-11e9-abcc-0a52c0223f8c');
        // String reqJSON = '{"lead":{"Id":"00Q2f000001V4gmEAC","Name":"Lead 10","Phone":"5519990593"},"isEvent":true,"dispositionName":"Caller Disconnected - HANGUP","taskElement":{"subject":"Caller Disconnected - HANGUP","Notes":"Test Note","isDisposition":true},"eventElement":{"subject":"Call","Notes":"Test Followup Note","isDisposition":false,"activityDateTime":"2019-09-27T21:36:00.000Z"}}';
        // String createDispJson = '{"lead":{"Id":"00Q2f000001V4gmEAC","Name":"Lead 10","Phone":"5519990593"},"isEvent":true,"dispositionName":"Caller Disconnected - HANGUP","taskElement":{"subject":"Caller Disconnected - HANGUP","Notes":"Test Note","isDisposition":true},"eventElement":{"subject":"Call","Notes":"Test Followup Note","isDisposition":false,"activityDateTime":"2019-09-27T21:36:00.000Z"}}';
        // LeadSoftphoneComponent_ctl.responseWrapper resp = LeadSoftphoneComponent_ctl.handleServerCall(reqJSON);
        // LeadSoftphoneComponent_ctl.createDispositonTask(createDispJson, testLead.Id);
        Test.stopTest(); 
    }

    // @IsTest
    // static void personAccount_withBlankPhoneFields_Test(){
        
    //     Id personAcc = [SELECT Id FROM RecordType WHERE (Name='Person Account') AND (SobjectType='Account')].Id;
    //     Account blankAccount = new Account(LastName='TestAccount', RecordTypeId = personAcc);
    //     insert blankAccount;

    //     Test.setMock(HttpCalloutMock.class, new qsuiteUtilities_Mock());
    //     Test.startTest();
    //     Id blankAccountId = blankAccount.Id;
    //     Account tempAccount = AccountSoftphoneComponent_ctl.getAccount(blankAccountId,'33227ea9-d9d0-11e9-abcc-0a52c0223f8c');
    //     Test.stopTest();
    // }

    @IsTest
    static void personAccount_withMobileField_Test(){
        
        Id personAcc = [SELECT Id FROM RecordType WHERE (Name='Person Account') AND (SobjectType='Account')].Id;
        Account blankAccount = new Account(LastName='TestAccount', RecordTypeId = personAcc, PersonMobilePhone='12345678');
        insert blankAccount;

        Test.setMock(HttpCalloutMock.class, new qsuiteUtilities_Mock());
        Test.startTest();
        Id blankAccountId = blankAccount.Id;
        Account tempAccount = AccountSoftphoneComponent_ctl.getAccount(blankAccountId,'33227ea9-d9d0-11e9-abcc-0a52c0223f8c');
        Test.stopTest();
    }

    @IsTest
    static void personAccount_withHomePhoneFields_Test(){
        
        Id personAcc = [SELECT Id FROM RecordType WHERE (Name='Person Account') AND (SobjectType='Account')].Id;
        Account blankAccount = new Account(LastName='TestAccount', RecordTypeId = personAcc, PersonHomePhone='12345678');
        insert blankAccount;

        Test.setMock(HttpCalloutMock.class, new qsuiteUtilities_Mock());
        Test.startTest();
        Id blankAccountId = blankAccount.Id;
        Account tempAccount = AccountSoftphoneComponent_ctl.getAccount(blankAccountId,'33227ea9-d9d0-11e9-abcc-0a52c0223f8c');
        Test.stopTest();
    }

    @IsTest
    static void personAccount_withOtherPhoneFields_Test(){
        
        Id personAcc = [SELECT Id FROM RecordType WHERE (Name='Person Account') AND (SobjectType='Account')].Id;
        Account blankAccount = new Account(LastName='TestAccount', RecordTypeId = personAcc, PersonOtherPhone='12345678');
        insert blankAccount;

        Test.setMock(HttpCalloutMock.class, new qsuiteUtilities_Mock());
        Test.startTest();
        Id blankAccountId = blankAccount.Id;
        Account tempAccount = AccountSoftphoneComponent_ctl.getAccount(blankAccountId,'33227ea9-d9d0-11e9-abcc-0a52c0223f8c');
        Test.stopTest();
    }

    @IsTest
    static void personAccount_withAssistantPhoneFields_Test(){
        
        Id personAcc = [SELECT Id FROM RecordType WHERE (Name='Person Account') AND (SobjectType='Account')].Id;
        Account blankAccount = new Account(LastName='TestAccount', RecordTypeId = personAcc, PersonAssistantPhone='12345678');
        insert blankAccount;

        Test.setMock(HttpCalloutMock.class, new qsuiteUtilities_Mock());
        Test.startTest();
        Id blankAccountId = blankAccount.Id;
        Account tempAccount = AccountSoftphoneComponent_ctl.getAccount(blankAccountId,'33227ea9-d9d0-11e9-abcc-0a52c0223f8c');
        Test.stopTest();
    }

    @isTest
    public static void testloginToQsuiteAPI()
    {
        test.startTest();
        test.setMock(HttpCalloutMock.class, new qsuiteUtilities_Mock());
        AccountSoftphoneComponent_ctl.loginResponseWrapper loginString = AccountSoftphoneComponent_ctl.loginToQsuite();
        test.stopTest();
    }

    @isTest
    public static void testterminateCallAPI()
    {
        test.startTest();
        test.setMock(HttpCalloutMock.class, new qsuiteUtilities_Mock());
        Boolean terminateCallFlag = AccountSoftphoneComponent_ctl.terminateCall('loginString');
        test.stopTest();
    }

    // @isTest
    // public static void testCreateLead()
    // {
    //     String jsonString = '{ "FirstName" : "Test FirstName","LastName" : "Test LastName","Phone":"1234567890"}';
    //     AccountSoftphoneComponent_ctl.leadResponseWrapper temp= AccountSoftphoneComponent_ctl.createLeadRecord(jsonString);
    // }

    @isTest
    public static void testlogOutFromQsuiteAPI()
    {
        test.startTest();
        test.setMock(HttpCalloutMock.class, new qsuiteUtilities_Mock());
        Boolean terminateCallFlag = AccountSoftphoneComponent_ctl.logOutFromQsuite('loginString');
        test.stopTest();
    }

    // @isTest
    // public static void testCreateDisposition()
    // {
    //     LeadSoftphoneComponent_ctl.taskWrap taskElement = new LeadSoftphoneComponent_ctl.taskWrap();
    //     taskElement.subject = 'Test';
    //     taskElement.Notes = 'Test Notes';
    //     taskElement.isDisposition = true;
    //     taskElement.activityDateTime = system.now();
    //     Lead testLead = [SELECT Id FROM Lead WHERE LastName='TestLead'];
    //   //  LeadSoftphoneComponent_ctl.createDispositonTask(taskElement,testLead.Id);
    // }
    // @isTest
    // public static void testRedialCallAPI()
    // {
    //     test.startTest();
    //     test.setMock(HttpCalloutMock.class, new qsuiteUtilities_Mock());
    //     Boolean terminateCallFlag = LeadSoftphoneComponent_ctl.redialCallApi('33227ea9-d9d0-11e9-abcc-0a52c0223f8c');
    //     test.stopTest();
    // }

    @isTest
    public static void testHoldCallAPI()
    {
        test.startTest();
        test.setMock(HttpCalloutMock.class, new qsuiteUtilities_Mock());
        Boolean terminateCallFlag = AccountSoftphoneComponent_ctl.holdCallApi('33227ea9-d9d0-11e9-abcc-0a52c0223f8c','Off');
        test.stopTest();
    }

    // @isTest
    // public static void testnextCallApi()
    // {
    //     test.startTest();
    //     test.setMock(HttpCalloutMock.class, new qsuiteUtilities_Mock());
    //     LeadSoftphoneComponent_ctl.nextCallWrapper resp = LeadSoftphoneComponent_ctl.nextCallApi('33227ea9-d9d0-11e9-abcc-0a52c0223f8c');
    //     test.stopTest();
    // }
    // @isTest
    // public static void testcancelGNNAPI()
    // {
    //     test.startTest();
    //     test.setMock(HttpCalloutMock.class, new qsuiteUtilities_Mock());
    //     Boolean resp = LeadSoftphoneComponent_ctl.cancelGNNAPI();
    //     test.stopTest();
    // }

    @isTest
    public static void testtransferCallApi()
    {
        test.startTest();
        test.setMock(HttpCalloutMock.class, new qsuiteUtilities_Mock());
        Boolean resp = AccountSoftphoneComponent_ctl.transferCallApi('auth_key','speciFiedNumber','phoneNumber');
        test.stopTest();
    }

    @isTest
    public static void testtransferFlipApi()
    {
        test.startTest();
        test.setMock(HttpCalloutMock.class, new qsuiteUtilities_Mock());
        Boolean resp = AccountSoftphoneComponent_ctl.transferFlipApi('33227ea9-d9d0-11e9-abcc-0a52c0223f8c');
        test.stopTest();
    }

    @isTest
    public static void testcancelTransferCallAPI()
    {
        test.startTest();
        test.setMock(HttpCalloutMock.class, new qsuiteUtilities_Mock());
        Boolean resp = AccountSoftphoneComponent_ctl.cancelTransferCallAPI('33227ea9-d9d0-11e9-abcc-0a52c0223f8c');
        test.stopTest();
    }

    // @isTest
    // public static void testGetdataCallAPI()
    // {
    //     test.startTest();
    //     test.setMock(HttpCalloutMock.class, new qsuiteUtilities_Mock());
    //     LeadSoftphoneComponent_ctl.getCallDataAPI('33227ea9-d9d0-11e9-abcc-0a52c0223f8c');
    //     test.stopTest();
    // }
}