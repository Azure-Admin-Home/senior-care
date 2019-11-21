public with sharing class LeadSoftphoneTransferCall_ctl {
    @AuraEnabled
    public static List<User> getAgentDetails(){
        List<User> agentsList = [SELECT Name,Phone FROM User where Phone != '' AND Id !=: UserInfo.getUserId() ORDER BY Profile.Name,Name ASC ];
        return agentsList;
    }

    @AuraEnabled
    public static Boolean transferCallApi(String authKey,String specifiedNumber,String phoneNumber){
        User agent = [SELECT Id,Name,Auth_Key__c,Phone,Server_URL__c FROM User where Id =: UserInfo.getUserId()];
        authKey = String.isNotBlank(authKey)?authKey:agent.Auth_Key__c;
        String serverURL = agent.Server_URL__c;
        
        return qsuiteUtilities.transferCallAPI(authKey,specifiedNumber,phoneNumber,serverURL);
    }
}
