@isTest
public class LeadDialServiceTest {

@TestSetup
static void makeData(){
	DialSettings.setDefault();
}

@isTest
static void test_method()
{
	Lead lead = new Lead(LastName = 'Test', Status = 'New', State = 'AL');
    insert lead;

    lead = [SELECT First_Dial_Time__c,Last_Dial_Time__c FROM Lead WHERE Id = :lead.Id];

	System.assertEquals(Time.newInstance(10,0,0,0), lead.First_Dial_Time__c);
	System.assertEquals(Time.newInstance(21,0,0,0), lead.Last_Dial_Time__c);
}

@isTest
static void test_method_logs()
{
	Lead lead = new Lead(LastName = 'Test', Status = 'New', State = 'AL');
    insert lead;

	Task task = new Task(WhatId = lead.Id, TaskSubtype = 'Call');
	insert task;

	update lead;
}

}