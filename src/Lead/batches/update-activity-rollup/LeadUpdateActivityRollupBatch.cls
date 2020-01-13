public class LeadUpdateActivityRollupBatch implements Database.Batchable<sObject>{
    private String query;
    
    public LeadUpdateActivityRollupBatch() {
        this.query = 'SELECT All_Event_Activities__c, '+
                            'All_Event_Activities_for_Last_7_Days__c, '+
                            'All_Log_Call_Activities__c '+
                      'FROM Lead';
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
    	return Database.getQueryLocator(this.query);
    }

    public void execute(Database.BatchableContext bc, List<Lead> scope) {
    	for (Lead lead :scope)
    	{
            Id leadId = lead.Id;
            System.debug('CHECK BEGIN aggregate queries LIMIT: ' + Limits.getQueries());
    		lead.All_Event_Activities__c = [SELECT COUNT() FROM Event WHERE WhoId = :leadId];
            lead.All_Event_Activities_for_Last_7_Days__c = [SELECT COUNT() FROM Event WHERE WhoId = :leadId AND CreatedDate <= LAST_N_DAYS:7];
            lead.All_Log_Call_Activities__c = [SELECT COUNT() FROM Task WHERE WhoId = :leadId AND TaskSubtype = 'Call'];
    	    System.debug('CHECK END aggregate queries LIMIT: ' + Limits.getQueries());
        }
    	update scope;
    }

    public void finish(Database.BatchableContext bc) {

    }
}