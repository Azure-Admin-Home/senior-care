public with sharing class LeadSoftphoneMatchingLeads_ctl {
    @AuraEnabled
    public static List<Lead> getMatchingLeads(String phoneNumber){
        return [SELECT Id, Name FROM Lead WHERE Phone = :phoneNumber OR MobilePhone = :phoneNumber ORDER BY CreatedDate DESC];
    }
}
