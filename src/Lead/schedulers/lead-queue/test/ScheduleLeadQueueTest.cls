@isTest
public class ScheduleLeadQueueTest {

@TestSetup
static void makeData(){
	Lead lead = new Lead(LastName = 'Test',
	                     Status = 'New',
	                     State = 'AL',
	                     Daily_Call_Attempts__c = 3,
	                     Daily_Call_Rest_Time__c = 3,
	                     Last_Dial_Attempt__c = DateTime.newInstance( 2025,9,31, 12,0,0 ));
	insert lead;
}

@isTest
public static void test_InitJob() {
	Test.startTest();
	ScheduleLeadQueue.initJob();
	Test.stopTest();
}
}