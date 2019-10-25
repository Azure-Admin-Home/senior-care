public with sharing class LeadDialService {

public static void execute()
{
	Map<String,List<Task>> taskMap = new Map<String,List<Task>>();
	if (Trigger.newMap != null)
	{
		List<Task> tasks = [SELECT Id FROM Task WHERE WhoId IN :Trigger.newMap.keySet() AND TaskSubtype = 'Call' AND CreatedDate = TODAY];
		for (Task task :tasks)
		{
			if (!taskMap.containsKey(task.WhoId))
			{
				taskMap.put(task.WhoId,new List<Task>{task});
			}
			else
			{
				taskMap.get(task.WhoId).add(task);
			}
		}
	}
	for (Lead lead :(List<Lead>)Trigger.new)
	{
		if (lead.State != null)
		{
			Dial_Settings__c dialSetting = DialSettings.getSettings(lead.State);

			List<String> time_s = dialSetting.First_Dial_Time__c.split(':');
			Integer hour_s = time_s.size() > 0 ? Integer.valueOf(time_s[0]) : 0;
			Integer minute_s = time_s.size() > 1 ? Integer.valueOf(time_s[1]) : 0;
			lead.First_Dial_Time__c = Time.newInstance(hour_s,minute_s,0,0);

			List<String> time_e = dialSetting.Last_Dial_Time__c.split(':');
			Integer hour_e = time_e.size() > 0 ? Integer.valueOf(time_e[0]) : 0;
			Integer minute_e = time_e.size() > 1 ? Integer.valueOf(time_e[1]) : 0;
			lead.Last_Dial_Time__c = Time.newInstance(hour_e,minute_e,0,0);
		}
		if (taskMap.containsKey(lead.Id))
		{
			lead.Dial_Attempts_Today__c = taskMap.get(lead.Id).size();
		}
		else 
		{
			lead.Dial_Attempts_Today__c = 0;
		}
	}
}

}