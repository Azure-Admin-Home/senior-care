public class AgentLeadInaciveBatch implements Database.Batchable<sObject>{
    
    private String query;
    private Id unassignedQueueId;

    public AgentLeadInaciveBatch() {
        String collectedQuery = 'SELECT Id, OwnerId FROM Lead ' +
                                'WHERE AEP_Callback_Year__c = NULL ' + 
                                'AND All_Event_Activities_for_Last_7_Days__c = 0 ';
        
        for(Group queue : [SELECT Id, DeveloperName FROM Group WHERE Type = 'Queue']){
            collectedQuery += 'AND OwnerId != \'' + queue.Id + '\' ';
            if(queue.DeveloperName == 'Unassigned'){
                this.unassignedQueueId = queue.Id;
            }
        }

        this.query = collectedQuery;
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
    	return Database.getQueryLocator(this.query);
    }

    public void execute(Database.BatchableContext bc, List<Lead> scope) {
    	for (Lead lead :scope)
    	{
    		lead.OwnerId = this.unassignedQueueId;
    	}
    	update scope;
    }

    public void finish(Database.BatchableContext bc) {

    }
}
