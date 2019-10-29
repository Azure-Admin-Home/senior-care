public class TaskLeadInfoUpdate {
    public static void afterInsert(Map<Id, Task> newTasks){
        Set<Id> leadIds = new Set<Id>();
        Map<Id,Set<Id>> leadToTasks = new Map<Id,Set<Id>>();
        for(Task task : newTasks.values()){
            System.debug('CHECK task: ' + task);
            if(task.TaskSubtype == 'Call'){
                Id leadId = task.WhoId;
                Id taskId = task.Id;
                
                leadIds.add(leadId);
                
                if(leadToTasks.containsKey(leadId)){
                    leadToTasks.get(leadId).add(taskId);
                } else {
                    Set<Id> taskIds = new Set<Id>{taskId};
                    leadToTasks.put(leadId, taskIds);
                }   
            }
        }
        List<Lead> leadRecords = [SELECT id, Disposition__c, Last_Dial_Attempt__c
                                  FROM Lead WHERE Id IN :leadIds];
        for(Lead lead : leadRecords){
           System.debug('CHECK lead Name: ' + lead);
           Id leadId = lead.Id;
		   lead.All_Log_Call_Activities__c = [SELECT COUNT() FROM Task WHERE WhoId = :leadId AND TaskSubtype = 'Call'];
           Set<Id> taskIds = leadToTasks.get(leadId);
           for(Id taskId : taskIds){
               Task realtedTask = newTasks.get(taskId);
               lead.Disposition__c = realtedTask.Subject;
               lead.Last_Dial_Attempt__c = realtedTask.CreatedDate;
           }
        }
        update leadRecords;
    }
}