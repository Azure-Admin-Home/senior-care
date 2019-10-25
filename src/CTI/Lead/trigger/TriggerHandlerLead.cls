public class TriggerHandlerLead {

public static void manage()
{
	if(Trigger.isBefore)
	{
		if(Trigger.isInsert)
		{
			LeadTriggerHandler.beforeInsertHandler(Trigger.new);
			LeadTriggerHandler.leadReassignment(Trigger.New, new Map<Id, Lead>());
			LeadDialService.execute();
			LeadNextDialAttemptService.execute();
		}
		else if (Trigger.isUpdate)
		{
			LeadTriggerHandler.beforeUpdateHandler((Map<Id, Lead>)Trigger.oldMap, Trigger.New);
			LeadTriggerHandler.leadReassignment(Trigger.New, (Map<Id, Lead>)Trigger.OldMap);
			LeadDialService.execute();
			LeadNextDialAttemptService.execute();
		}
		else if(Trigger.isDelete)
		{
			//LeadTriggerHandler.beforeDeleteHandler(trigger.old );
		}
	}
	// If the trigger is not a before trigger, it must be an after trigger.
	else
	{
		if(Trigger.isInsert)
		{
			// LeadTriggerHandler.afterInsertHandler(trigger.new);
		}
		else if(Trigger.isUpdate)
		{
			// LeadTriggerHandler.afterUpdateHandler((Map<Id, Lead>)Trigger.OldMap, trigger.new);
		}
	}
}

}