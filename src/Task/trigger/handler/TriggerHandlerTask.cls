public class TriggerHandlerTask {

public static void manage()
{
	if (Trigger.isAfter)
	{
		if (Trigger.isInsert)
		{
			Map<Id,Task> insertedTasks = (Map<Id,Task>)Trigger.NewMap;
			TaskHelper.afterInsert(insertedTasks);
            TaskDialService.execute();
			TaskLeadInfoUpdate.afterInsert(insertedTasks);
		}
	}
}

}