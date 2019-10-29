public  class LeadSoftphoneCallToLead_ctl {
    @AuraEnabled
    public static GetQueuedCallsResponseWrapper getQueuedCalls(String authKey){
        GetQueuedCallsResponseWrapper response = new GetQueuedCallsResponseWrapper();
        
        User agent = [SELECT Auth_Key__c,Server_URL__c, Agent_Queue__c FROM User where Id =: UserInfo.getUserId()];
        authKey = String.isNotBlank(authKey)?authKey:agent.Auth_Key__c;
        String serverURL = agent.Server_URL__c;
        String queue = agent.Agent_Queue__c;
        
        qsuiteUtilities.GetQueuedCallsWrapper resp = qsuiteUtilities.getQueuedCallsAPI(authKey, queue, serverURL);
     	response.isSuccess =  resp.isSucess;
        response.respJson =  resp.respJson;
        return response;
    }

    public class GetQueuedCallsResponseWrapper
    {
        @AuraEnabled
        public Boolean isSuccess {get;set;}
        @AuraEnabled
        public String respJson {get;set;}
    }
}