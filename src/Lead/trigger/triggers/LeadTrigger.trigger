trigger LeadTrigger on Lead (before insert, before update, before delete, after insert , after update, after delete, after undelete) {
	
    Lead_Trigger_Toggle__mdt settings = [SELECT Lead_Trigger_Activate__c FROM Lead_Trigger_Toggle__mdt WHERE DeveloperName = 'Settings' LIMIT 1];
    
    if(settings.Lead_Trigger_Activate__c == true){
     	TriggerHandlerLead.manage();   
    }
    
    if(trigger.isAfter && trigger.isUpdate) {
        // Call deleteLeadPSR method
        LeadTriggerHandler.deleteLeadPSR(trigger.oldMap, trigger.new); 
    }
    
}