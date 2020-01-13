public class EventLeadInfoUpdate {
    public static void afterInsert(Map<Id, Event> newEvents){
        Set<Id> leadIds = new Set<Id>();
        for(Event event : newEvents.values()){
            Id leadId = Event.WhoId;
            leadIds.add(leadId);
        }

        List<Lead> leadRecords = [SELECT Id, All_Event_Activities__c, All_Event_Activities_for_Last_7_Days__c
                                  FROM Lead WHERE Id IN :leadIds];
        
        for(Lead lead : leadRecords){
           Id leadId = lead.Id;
		   lead.All_Event_Activities__c = [SELECT COUNT() FROM Event WHERE WhoId = :leadId];
           lead.All_Event_Activities_for_Last_7_Days__c = [SELECT COUNT() FROM Event WHERE WhoId = :leadId AND CreatedDate <= LAST_N_DAYS:7];
        }
        update leadRecords;
    }
}