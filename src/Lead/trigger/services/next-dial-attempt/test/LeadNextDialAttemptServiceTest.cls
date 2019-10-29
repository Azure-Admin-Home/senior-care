@isTest
public class LeadNextDialAttemptServiceTest {

@TestSetup
static void makeData(){
	DialSettings.setDefault();
}

@isTest
static void test_not_last_dial()
{
	Lead lead = new Lead(LastName = 'Test',
	                     Status = 'New',
	                     State = 'AL',
	                     Daily_Call_Attempts__c = 3);
	insert lead;

	lead = [SELECT First_Dial_Time__c,Last_Dial_Time__c,Next_Dial_Attempt__c FROM Lead WHERE Id = :lead.Id];
}

@isTest
static void test_have_last_dial()
{
	Lead lead = new Lead(LastName = 'Test',
	                     Status = 'New',
	                     State = 'AL',
	                     Daily_Call_Attempts__c = 3,
                         Daily_Call_Rest_Time__c = 3,
	                     Last_Dial_Attempt__c = DateTime.newInstance( 2019,9,31 ));
	insert lead;

	lead = [SELECT First_Dial_Time__c,Last_Dial_Time__c,Next_Dial_Attempt__c FROM Lead WHERE Id = :lead.Id];
}

@isTest
static void test_have_last_dial_old()
{
	Lead lead = new Lead(LastName = 'Test',
	                     Status = 'New',
	                     State = 'AL',
	                     Daily_Call_Attempts__c = 0,
                         Daily_Call_Rest_Time__c = 3,
	                     Last_Dial_Attempt__c = System.now().addDays(-2));
	insert lead;

	lead = [SELECT First_Dial_Time__c,Last_Dial_Time__c,Next_Dial_Attempt__c FROM Lead WHERE Id = :lead.Id];
}

}