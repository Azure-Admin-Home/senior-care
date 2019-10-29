public class TaskDialService {

public static void execute()
{
    Map<Id,Integer> leadMap = new Map<Id,Integer>();
    for (Task task :(List<Task>)Trigger.new)
    {
        if (task.WhoId != null && Task.TaskSubtype == 'Call' && ((String)task.WhoId).startsWith('00Q'))
        {
            if (leadMap.containsKey(task.WhoId)) leadMap.put(task.WhoId, leadMap.get(task.WhoId) + 1);
            else leadMap.put(task.WhoId, 1);
        }
    }
    List<Lead> leadList = [SELECT Id,Dial_Attempts_Today__c FROM Lead WHERE Id IN :leadMap.keySet()];
    for (Lead lead :leadList)
    {
        if (lead.Dial_Attempts_Today__c == null) lead.Dial_Attempts_Today__c = 0;
        lead.Dial_Attempts_Today__c += leadMap.get(lead.Id);
    }
    update leadList;
}

}