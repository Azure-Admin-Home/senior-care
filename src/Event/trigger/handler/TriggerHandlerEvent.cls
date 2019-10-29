public class TriggerHandlerEvent {
    public static void manage()
    {
    	if (Trigger.isAfter)
    	{
    		if (Trigger.isInsert)
    		{
    			Map<Id,Event> insertedEvents = (Map<Id,Event>)Trigger.NewMap;
    			EventLeadInfoUpdate.afterInsert(insertedEvents);
    		}
    	}
    }
}
