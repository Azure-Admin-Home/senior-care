@isTest
public class TaskDialServiceTest {

@isTest
static void test_method()
{
	Lead lead = TestFactory.newLead();
	Task task1 = TestFactory.newTaskWho(lead);
	Task task2 = TestFactory.newTaskWho(lead);

	lead = [SELECT Dial_Attempts_Today__c
	        FROM Lead
	        WHERE Id = :lead.Id];

	System.assertEquals(2, lead.Dial_Attempts_Today__c);
}

}