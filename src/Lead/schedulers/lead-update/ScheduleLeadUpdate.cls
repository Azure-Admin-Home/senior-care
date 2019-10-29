global class ScheduleLeadUpdate implements Database.Batchable<sObject>, Schedulable
{
    
// Batch variables
String query;

// Schedule variables
static String scheduleName = 'ScheduleLeadUpdate_v1.0';
static String cronExp = '0 0 17-23 ? * * *';

global ScheduleLeadUpdate()
{
	this('SELECT Id,(SELECT Id,CreatedDate FROM Tasks WHERE TaskSubtype = \'Call\' AND CreatedDate = TODAY) FROM Lead');
}

global ScheduleLeadUpdate(String query)
{
	this.query = query;
}

global static void initJob()
{
	abortJob();

	// Schedule new one
	System.schedule(scheduleName, cronExp, new ScheduleLeadUpdate());
}

global static void abortJob()
{
    // Abourt previous Job
	List<CronTrigger> cronJob = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name = :scheduleName];
	if (cronJob.size() > 0) System.abortJob(cronJob[0].id);
}

global void execute(SchedulableContext sc) {
	Database.executeBatch(new ScheduleLeadUpdate());
}

global Database.QueryLocator start(Database.BatchableContext bc) {
	return Database.getQueryLocator(query);
}

global void execute(Database.BatchableContext bc, List<Lead> scope) {
	for (Lead lead :scope)
	{
		if (lead.Tasks != null) lead.Dial_Attempts_Today__c = lead.Tasks.size();
	}
	update scope;
}

global void finish(Database.BatchableContext bc) {

}

}