public with sharing class ConvertLeadButtonController {
    
    @AuraEnabled
    public static Map<String, Id> convertLead(String leadId){
        LeadStatus convertStatus = [SELECT MasterLabel FROM LeadStatus WHERE IsConverted = TRUE LIMIT 1];            
           
        Database.LeadConvert leadConvert = new database.LeadConvert();
                             leadConvert.setLeadId(leadId);         
                             leadConvert.setConvertedStatus(convertStatus.MasterLabel);                
        Database.LeadConvertResult leadConvertResult = Database.convertLead(leadConvert);
        
        Id accountId = leadConvertResult.getAccountId();
        Id opportunityId = leadConvertResult.getOpportunityId();
        
        return new Map<String, Id>{ 'accountId' => accountId,
                                    'opportunityId' => opportunityId};
    }
}