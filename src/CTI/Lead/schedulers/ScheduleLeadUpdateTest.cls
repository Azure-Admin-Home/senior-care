@isTest
public class ScheduleLeadUpdateTest {

@TestSetup
static void makeData(){
    insert new Lead(LastName = 'test', Company = 'test');
}

@isTest
public static void test_InitJob() {
	Test.startTest();
	ScheduleLeadUpdate.initJob();
	Test.stopTest();
}
}