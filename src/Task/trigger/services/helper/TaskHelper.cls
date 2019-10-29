public class TaskHelper{
    public static void afterInsert(Map<Id, Task> taskRecords){
        set<Id> leadIds = new set<Id>();
        for(Task t : taskRecords.values()){
            if(t.Subject == 'Call'){
                leadIds.add(t.WhoId);
            }
        }
        List<Lead> leadRecords = [Select id, Name, (Select id, Subject, CreatedDate from ActivityHistories where Subject = 'Call' and ActivityDate = Today Order By CreatedDate Desc) from Lead where Id In: leadIds];
        for(Lead l : leadRecords){
           l.Dial_Attempts_Today__c = l.ActivityHistories.size();
           l.Last_Dial_Attempt__c = l.ActivityHistories[0].CreatedDate;
        }
    }
}