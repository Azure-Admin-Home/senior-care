global class ScheduleLeadQueue implements Database.Batchable<sObject>, Schedulable
{

// Batch variables
String query;
DateTime rangeMin = System.now().addMinutes(-5);
DateTime rangeMax = System.now().addMinutes(10);

// Schedule variables
static String scheduleName = 'ScheduleLeadQueue_v1.0';
static String cronExp = '0 5,15,25,35,45,55 * ? * * *';
static Integer delayMinutes = 10;

global ScheduleLeadQueue()
{
	this('SELECT Id FROM Lead WHERE Owner.Name = \'Unassigned\' AND Next_Dial_Attempt__c >= :rangeMin AND Next_Dial_Attempt__c <= :rangeMax');
}

global ScheduleLeadQueue(String query)
{
	System.debug('rangeMin::'+rangeMin);
	System.debug('rangeMax::'+rangeMax);
	this.query = query;
	if (Test.isRunningTest()) this.query = 'SELECT Id FROM Lead';
}

global static void initJob()
{
	abortJob();

	// Schedule new jobs
	for (Integer i=5; i < 60; i+=delayMinutes)
	{
		cronExp = '0 '+i+' * ? * * *';
		System.schedule(scheduleName+'job'+i, cronExp, new ScheduleLeadQueue());
	}
}

global static void abortJob()
{
	String filterName = '%'+scheduleName+'%';
	List<CronTrigger> cronJob = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name LIKE :filterName];
	for (CronTrigger job :cronJob)
	{
		System.abortJob(job.id);
	}
}

global void execute(SchedulableContext sc) {
	Database.executeBatch(new ScheduleLeadQueue());
}

global Database.QueryLocator start(Database.BatchableContext bc) {
	return Database.getQueryLocator(query);
}

global void execute(Database.BatchableContext bc, List<Lead> scope) {
	for (Lead lead :scope)
	{
		lead.OwnerId = GroupUtils.getGroup('Hopper').Id;
	}
	System.debug(scope);
	Database.update(scope, false);
}

global void finish(Database.BatchableContext bc) {

}

}