public class AgentLeadInaciveBatch implements Database.Batchable<sObject>{
    
    private String query;
    private Id unassignedQueueId;

    public AgentLeadInaciveBatch() {
        String collectedQuery = 'SELECT Id, OwnerId FROM Lead ' +
                                'WHERE AEP_Callback_Year__c = NULL ' + 
                                'AND CreatedDate < LAST_N_DAYS:7 ' +
                                'AND All_Event_Activities_for_Last_7_Days__c = 0 ' +
                                'AND IsConverted = FALSE ';
        this.unassignedQueueId = GroupUtils.getGroupId('Unassigned');

        for(Group queue : [SELECT Id, DeveloperName FROM Group WHERE Type = 'Queue']){
            collectedQuery += 'AND OwnerId != \'' + queue.Id + '\' ';
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
