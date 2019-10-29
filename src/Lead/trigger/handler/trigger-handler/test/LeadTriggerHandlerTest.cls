/****************************************************************************************************************************************************
* Test Class Name                   : LeadTriggerHandlerTest
* Created By                        : Suneel Sunkara on 04/09/2019
* Class                             : LeadTriggerHandler
* Description                       : 
*****************************************************************************************************************************************************
* Modification Log:
*****************************************************************************************************************************************************
* Story/Issue No.     Modified By        Modified Date            Modification Description                         
*****************************************************************************************************************************************************
*
****************************************************************************************************************************************************/

@isTest
public class LeadTriggerHandlerTest{
    @isTest
    public static void testLeadScoremethod(){
        List<Dail_Attempts__mdt> dailAttempts = [select id, Max_Age__c, Min_Age__c, Dails_Attempt__c, Resting_Period__c from Dail_Attempts__mdt];
        List<Last_Call_By_State__mdt> stateCallTimings = [select id, First_Dail__c, Last_Dial__c, DeveloperName from Last_Call_By_State__mdt];
        
        List<Lead> leadRecords = new List<Lead>();
        
        leadRecords.add(new Lead(LastName = 'Test 01', Disposition__c = 'Caller Disconnected - HANGUP', Batch_Job_Date__c = system.today(), LeadSource = 'Website', Lead_Type__c = '3', Sub_Id__c = 'Form',
                                 Inbound_Outbound__c = 'Outbound', State = 'Arizona', Last_Dial_Attempt__c = System.Now(), Daily_Call_Rest_Time__c = 3, Daily_Call_Attempts__c = 3, Dial_Attempts_Today__c = 0));
        leadRecords.add(new Lead(LastName = 'Test 02', Disposition__c = 'Current Member', Batch_Job_Date__c = system.today(),LeadSource = 'Facebook', Lead_Type__c = '3', Sub_Id__c = '', 
                                 Inbound_Outbound__c = 'Outbound', State = 'Arizona', Last_Dial_Attempt__c = System.Now(), Daily_Call_Rest_Time__c = 3, Daily_Call_Attempts__c = 3, Dial_Attempts_Today__c = 3));
        leadRecords.add(new Lead(LastName = 'Test 03', Disposition__c = 'AEP Callback', Batch_Job_Date__c = system.today(), LeadSource = 'Website', Lead_Type__c = 'Inbound', Sub_Id__c = '',
                                 Inbound_Outbound__c = 'Inbound'));
        leadRecords.add(new Lead(LastName = 'Test 04',Batch_Job_Date__c = system.today(), LeadSource = 'Facebook', Lead_Type__c = 'Inbound', Sub_Id__c = '',
                                 Inbound_Outbound__c = 'Inbound'));
        leadRecords.add(new Lead(LastName = 'Test 05',Batch_Job_Date__c = system.today(), LeadSource = 'Inside Response', Lead_Type__c = '16', Sub_Id__c = 'IR-35',
                                 Inbound_Outbound__c = 'Inbound'));
        leadRecords.add(new Lead(LastName = 'Test 06',Batch_Job_Date__c = system.today(), LeadSource = 'Cege', Lead_Type__c = '1', Sub_Id__c = '',
                                 Inbound_Outbound__c = 'Inbound'));
        leadRecords.add(new Lead(LastName = 'Test 07',Batch_Job_Date__c = system.today(), LeadSource = 'Inside Response', Lead_Type__c = '15',
                                 Sub_Id__c = 'IR-40', Inbound_Outbound__c = 'Inbound'));
        leadRecords.add(new Lead(LastName = 'Test 08',Batch_Job_Date__c = system.today(), LeadSource = 'Wasatch', Lead_Type__c = '14', Sub_Id__c = 'DT',
                                 Inbound_Outbound__c = 'Inbound'));       
        leadRecords.add(new Lead(LastName = 'Test 09',Batch_Job_Date__c = system.today(), LeadSource = 'Cege', Lead_Type__c = '16', Sub_Id__c = 'Text Transfer', 
                                 Inbound_Outbound__c = 'Inbound'));
        leadRecords.add(new Lead(LastName = 'Test 10',Batch_Job_Date__c = system.today(), LeadSource = 'Website', Lead_Type__c = '1', Sub_Id__c = 'Third-Party Transfer',
                                 Inbound_Outbound__c = 'Inbound')); 
        leadRecords.add(new Lead(LastName = 'Test 11',Batch_Job_Date__c = system.today(), LeadSource = 'TRG', Lead_Type__c = '3', Sub_Id__c = '', 
                                 Inbound_Outbound__c = 'Outbound'));
        leadRecords.add(new Lead(LastName = 'Test 12',Batch_Job_Date__c = system.today(), LeadSource = 'Cege', Lead_Type__c = '3', Sub_Id__c = '1724', 
                                 Inbound_Outbound__c = 'Outbound'));
        leadRecords.add(new Lead(LastName = 'Test 13',Batch_Job_Date__c = system.today(), LeadSource = 'Cege', Lead_Type__c = '3', Sub_Id__c = '465',
                                 Inbound_Outbound__c = 'Outbound'));
        leadRecords.add(new Lead(LastName = 'Test 14',Batch_Job_Date__c = system.today(), LeadSource = 'Cege', Lead_Type__c = '3', Sub_Id__c = '1720', 
                                 Inbound_Outbound__c = 'Outbound'));
        leadRecords.add(new Lead(LastName = 'Test 15',Batch_Job_Date__c = system.today(), LeadSource = 'Cege', Lead_Type__c = '3', Sub_Id__c = '851',
                                 Inbound_Outbound__c = 'Outbound'));
        leadRecords.add(new Lead(LastName = 'Test 16',Batch_Job_Date__c = system.today(), LeadSource = 'Cege', Lead_Type__c = '3', Sub_Id__c = '4092', 
                                 Inbound_Outbound__c = 'Outbound'));
        leadRecords.add(new Lead(LastName = 'Test 17',Batch_Job_Date__c = system.today(), LeadSource = 'Cege', Lead_Type__c = '3', Sub_Id__c = '4112', 
                                 Inbound_Outbound__c = 'Outbound'));
        leadRecords.add(new Lead(LastName = 'Test 18',Batch_Job_Date__c = system.today(), LeadSource = 'Cege', Lead_Type__c = '3', Sub_Id__c = '4122',
                                 Inbound_Outbound__c = 'Outbound'));
        leadRecords.add(new Lead(LastName = 'Test 19',Batch_Job_Date__c = system.today(), LeadSource = 'Cege', Lead_Type__c = '3', Sub_Id__c = '4202', 
                                 Inbound_Outbound__c = 'Outbound'));
        leadRecords.add(new Lead(LastName = 'Test 20',Batch_Job_Date__c = system.today(), LeadSource = 'Website', Lead_Type__c = '3', Sub_Id__c = 'Form', 
                                 Inbound_Outbound__c = 'Outbound'));
        leadRecords.add(new Lead(LastName = 'Test 21',Batch_Job_Date__c = system.today(), LeadSource = 'Website', Lead_Type__c = 'Inbound', Sub_Id__c = '',
                                 Inbound_Outbound__c = 'Inbound'));
        leadRecords.add(new Lead(LastName = 'Test 22',Batch_Job_Date__c = system.today(), LeadSource = 'Inside Response', Lead_Type__c = '16', Sub_Id__c = 'IR-35', 
                                 Inbound_Outbound__c = 'Inbound'));
        leadRecords.add(new Lead(LastName = 'Test 23',Batch_Job_Date__c = system.today(), LeadSource = 'Inside Response', Lead_Type__c = '15', Sub_Id__c = 'IR-40', 
                                 Inbound_Outbound__c = 'Inbound'));
        leadRecords.add(new Lead(LastName = 'Test 24',Batch_Job_Date__c = system.today(), LeadSource = 'Wasatch', Lead_Type__c = '14', Sub_Id__c = 'DT',
                                 Inbound_Outbound__c = 'Inbound'));
        leadRecords.add(new Lead(LastName = 'Test 25',Batch_Job_Date__c = system.today(), LeadSource = 'Cege', Lead_Type__c = '16', Sub_Id__c = 'Text Transfer',
                                 Inbound_Outbound__c = 'Inbound'));
        leadRecords.add(new Lead(LastName = 'Test 26',Batch_Job_Date__c = system.today(), LeadSource = 'Website', Lead_Type__c = '3', Sub_Id__c = 'Form', 
                                 Inbound_Outbound__c = 'Outbound'));
        leadRecords.add(new Lead(LastName = 'Test 27',Batch_Job_Date__c = system.today(), LeadSource = 'TRG', Lead_Type__c = '3', Sub_Id__c = '',
                                 Inbound_Outbound__c = 'Outbound'));
        leadRecords.add(new Lead(LastName = 'Test 28',Batch_Job_Date__c = system.today(), LeadSource = 'Facebook', Lead_Type__c = '3', Sub_Id__c = '',
                                 Inbound_Outbound__c = 'Outbound'));
        leadRecords.add(new Lead(LastName = 'Test 29',Batch_Job_Date__c = system.today(), LeadSource = 'Facebook', Lead_Type__c = 'Inbound', Sub_Id__c = '', 
                                 Inbound_Outbound__c = 'Inbound'));
        leadRecords.add(new Lead(LastName = 'Test 30',Batch_Job_Date__c = system.today(), LeadSource = 'Cege', Lead_Type__c = '16', Sub_Id__c = 'Text Transfer',
                                 Inbound_Outbound__c = 'Inbound'));
        leadRecords.add(new Lead(LastName = 'Test 31',Batch_Job_Date__c = system.today(), LeadSource = 'Website', Lead_Type__c = 'Cege', Sub_Id__c = 'Third-Party Transfer',
                                 Inbound_Outbound__c = 'Inbound'));
        leadRecords.add(new Lead(LastName = 'Test 32',Batch_Job_Date__c = system.today(), LeadSource = 'Cege', Lead_Type__c = '3', Sub_Id__c = '781', 
                                 Inbound_Outbound__c = 'Outbound'));
        leadRecords.add(new Lead(LastName = 'Test 33',Batch_Job_Date__c = system.today(), LeadSource = 'Cege', Lead_Type__c = '3', Sub_Id__c = '203', 
                                 Inbound_Outbound__c = 'Outbound'));
        leadRecords.add(new Lead(LastName = 'Test 34',Batch_Job_Date__c = system.today(), LeadSource = 'Cege', Lead_Type__c = '3', Sub_Id__c = '199',
                                 Inbound_Outbound__c = 'Outbound'));
        leadRecords.add(new Lead(LastName = 'Test 35',Batch_Job_Date__c = system.today(), LeadSource = 'Cege', Lead_Type__c = '3', Sub_Id__c = '4126', 
                                 Inbound_Outbound__c = 'Outbound'));
        leadRecords.add(new Lead(LastName = 'Test 36',Batch_Job_Date__c = system.today(), LeadSource = 'Cege', Lead_Type__c = '3', Sub_Id__c = '4102',
                                 Inbound_Outbound__c = 'Outbound'));
        leadRecords.add(new Lead(LastName = 'Test 37',Batch_Job_Date__c = system.today(), LeadSource = 'Cege', Lead_Type__c = '3', Sub_Id__c = '4120',
                                 Inbound_Outbound__c = 'Outbound'));
        leadRecords.add(new Lead(LastName = 'Test 38',Batch_Job_Date__c = system.today(), LeadSource = 'Cege', Lead_Type__c = '3', Sub_Id__c = '4174',
                                 Inbound_Outbound__c = 'Outbound'));
        leadRecords.add(new Lead(LastName = 'Test 39',Batch_Job_Date__c = system.today(), LeadSource = 'Cege', Lead_Type__c = '3', Sub_Id__c = '4236',
                                 Inbound_Outbound__c = 'Outbound'));
        leadRecords.add(new Lead(LastName = 'Test 40',Batch_Job_Date__c = system.today(), LeadSource = 'Website', Lead_Type__c = '3', Sub_Id__c = 'Form', 
                                 Inbound_Outbound__c = 'Outbound'));
        leadRecords.add(new Lead(LastName = 'Test 41',Batch_Job_Date__c = system.today(), LeadSource = 'Facebook', Lead_Type__c = '3', Sub_Id__c = '', 
                                 Inbound_Outbound__c = 'Outbound'));
        insert leadRecords;
        
        
        
        
        
        Datetime yesterday2 = Datetime.now().addDays(-5);
        Test.setCreatedDate(leadrecords[2].id, yesterday2);
        
        Datetime yesterday3 = Datetime.now().addDays(-9);
        Test.setCreatedDate(leadrecords[3].id, yesterday3);
        
        Datetime yesterday4 = Datetime.now().addDays(-5);
        Test.setCreatedDate(leadrecords[4].id, yesterday4);
        
        leadRecords[0]. Batch_Job_Date__c  = system.today().adddays(5);
        update leadRecords[0];
        
        Datetime yesterday = Datetime.now().addDays(-5);
        Test.setCreatedDate(leadrecords[0].id, yesterday);
        
        leadRecords[1].LeadSource='Cege';
        leadRecords[1]. Batch_Job_Date__c  = system.today().adddays(4);
        Update leadRecords[1];
        
        leadRecords[11].Sub_Id__c='781';
        leadRecords[11]. Batch_Job_Date__c  = system.today().adddays(5);
        Update leadRecords[11];
        
        leadRecords[12].Sub_Id__c='203';
        leadRecords[12]. Batch_Job_Date__c  = system.today().adddays(5);
        Update leadRecords[12];
        
        leadRecords[13].Sub_Id__c='199';
        leadRecords[13]. Batch_Job_Date__c  = system.today().adddays(5);
        Update leadRecords[13];
        
        leadRecords[14].Sub_Id__c='4126';
        leadRecords[14]. Batch_Job_Date__c  = system.today().adddays(5);
        Update leadRecords[14];
        
        leadRecords[15].Sub_Id__c='4102';
        leadRecords[15]. Batch_Job_Date__c  = system.today().adddays(5);
        Update leadRecords[15];
        
        leadRecords[16].Sub_Id__c='4120';
        leadRecords[16]. Batch_Job_Date__c  = system.today().adddays(5);
        Update leadRecords[16];
        
        leadRecords[17].Sub_Id__c='4174';
        leadRecords[17]. Batch_Job_Date__c  = system.today().adddays(5);
        Update leadRecords[17];
        
        leadRecords[18].Sub_Id__c='4236';
        leadRecords[18]. Batch_Job_Date__c  = system.today().adddays(5);
        Update leadRecords[18];
        
        leadRecords[19].LeadSource='Facebook';
        leadRecords[19].Sub_Id__c='';
        leadRecords[19]. Batch_Job_Date__c  = system.today().adddays(5);
        Update leadRecords[19];
        
        leadRecords[1].Inbound_Outbound__c='Inbound';
        leadRecords[1]. Batch_Job_Date__c  = system.today().adddays(5);
        Update leadRecords[1];
        
        leadRecords[2].Inbound_Outbound__c='Inbound';
        leadRecords[2]. Batch_Job_Date__c  = system.today().adddays(5);
        Update leadRecords[2];
        
        leadRecords[3].Inbound_Outbound__c='Inbound';
        leadRecords[3]. Batch_Job_Date__c  = system.today().adddays(5);
        Update leadRecords[3];
        
        leadRecords[28]. Batch_Job_Date__c  = system.today().adddays(5);
        Update leadRecords[28];
        test.setCreatedDate(leadRecords[28].id, system.today().adddays(9));
        
        leadRecords[21].LeadSource='Cege';
        leadRecords[21].Lead_Type__c='1';
        leadRecords[21].Sub_Id__c='';
        leadRecords[21]. Batch_Job_Date__c  = system.today().adddays(5);
        Update leadRecords[21];
    }
    
    @isTest
    public static void testDeleteLeadPSR(){
        set<Id> leadIds = new set<Id>(); 
        
        // Create a test lead for testing
        list<Lead> leadsToInsert = new list<Lead>();   
        for (Integer i = 0; i < 200; i++){
            Lead testLead = new Lead(FirstName = 'Test', LastName = 'Jason' + i, Status = 'New', State = 'AZ', LeadSource = 'Cege', Lead_Type__c = '1');
            leadsToInsert.add(testLead);
        }        
        insert leadsToInsert;
    // The routeUsingSkills method is invoked by a process builder called "Skills-Based Routing". 
        // The method gets run when a lead owner is updated to the Hopper queue.         
        Group hopperQueue = [select Id from Group where Name = 'Hopper' and Type = 'Queue' limit 1];        
        list<Lead> testLeads = [select Id, OwnerId from Lead where LastName LIKE 'Jason%'];        
        for (Lead l : testLeads) {
            l.OwnerId = hopperQueue.Id; 
            leadIds.add(l.Id);
        }
        // Reassign test leads to the Hopper queue 
        update testLeads;        
        
        list<PendingServiceRouting> psrList = [select Id from PendingServiceRouting where workItemId IN :leadIds];
        // Check if PSRs were being created. There should be 200 PSRs being created. 
        system.assertEquals(200, psrList.size());
        
        Id currentUserId = UserInfo.getUserId();
        for (Lead l : testLeads) {
            l.OwnerId = currentUserId;
        }
        // Reassign test leads to current user 
        update testLeads;

        psrList = [select Id from PendingServiceRouting where workItemId IN :leadIds];
        // Check if PSRs have been deleted. There should be no PSR now.
        system.assertEquals(0, psrList.size());        
    }
    
    
}