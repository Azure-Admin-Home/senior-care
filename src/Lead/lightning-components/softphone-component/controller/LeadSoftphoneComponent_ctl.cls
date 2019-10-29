public class LeadSoftphoneComponent_ctl
{
    @AuraEnabled
    public static List<User> getAgentDetails(){
        List<User> agentsList = [SELECT Id,Name,Phone,Server_URL__c,Profile.Name,Auth_Key__c FROM User where Phone != '' AND Id !=: UserInfo.getUserId() ORDER BY Profile.Name,Name ASC ];
        return agentsList; 
    }
    @AuraEnabled
    public static String getAgentAuthKey(){
        String authKey = [SELECT Id,Name,Phone,Server_URL__c,Profile.Name,Auth_Key__c FROM User WHERE Id =: UserInfo.getUserId()].Auth_Key__c;
        return authKey; 
    }
    @AuraEnabled
    public static void handleMiniDialerVisibility(Boolean visibility){
        // Visibility true = show, false = Hide.
        User user = new User(Id = userInfo.getUserId(),Mini_Dialer_Visible__c =visibility);
        try{
            update user;
        }
        catch(Exception e)
        {
            system.debug('Error::'+e.getMessage());
            system.debug('Trace::'+e.getStackTraceString());
        }
    }
    @AuraEnabled
    public static leadResponseWrapper createLeadRecord(String jsonString){
        leadResponseWrapper wrap= new leadResponseWrapper();
        try
        {
            Lead newLead = (Lead)system.JSON.deserialize(jsonString, Lead.class);
            newLead.Inbound_Outbound__c = 'Inbound';
            //newLead.Company = 'Dummy Company';
            insert newLead;
            
            Lead respLead = [SELECT Id,Name,Phone,MobilePhone,Inbound_Outbound__c FROM Lead WHERE Id =: newLead.Id];
            
            wrap.isSuccess = true;
            wrap.lead = respLead;
            wrap.errorMsg = '';
        }
        catch(Exception e)
        {
            wrap.isSuccess = false;
            wrap.errorMsg = e.getMessage()+e.getStackTraceString();
        }
        return wrap;
    }
    
    @AuraEnabled
    public static loginResponseWrapper loginToQsuite(){
        
        User agent = [SELECT Id,Name,Phone,Server_URL__c,Gateway__c,CTI_User_Name__c,CTI_Password__c FROM User where Id =: UserInfo.getUserId()];
        String serverURL = agent.Server_URL__c;
        Boolean extension = false;
        Boolean loginFlag = false;
        Boolean nailDownFlag = false;
        String auth_Key = qsuiteUtilities.authorizeToQsuiteAPI(serverURL,agent.Gateway__c,agent.CTI_User_Name__c,agent.CTI_Password__c);
        loginResponseWrapper returnResponse = new loginResponseWrapper();
        if(String.isNotBlank(auth_Key))
        {
            loginFlag = qsuiteUtilities.loginToPhoneAPI(auth_Key,serverURL);
        }
        if(loginFlag)
        {
            extension = qsuiteUtilities.getNailUpAPI(auth_Key,serverURL);
        }
        if(extension)
        {
            nailDownFlag = qsuiteUtilities.nailDownAPI(auth_Key,serverURL);
        }
        if(nailDownFlag)
        {
            returnResponse.authKey = auth_Key;
            returnResponse.isSucess = true;
           
            User user = new User(Id = userInfo.getUserId());
            user.Auth_Key__c = auth_Key;
            update  user;
            //inbound call will happen if sucess store the Auth key to user and return the authkey 
            //and return the flag of inbound to stop the outbound call
            return returnResponse;
        }
        else
        {
            //  returnResponse.isInbound = false;
            returnResponse.authKey = '';
            returnResponse.isSucess = false;
            returnResponse.errorMsg = 'Error :: Something went wrong, Please contact to your administrator'; 
            return returnResponse;
        }
    }
    @AuraEnabled
    public static Boolean loadCall(String authKey,String phoneNumber){ 
        User agent = [SELECT Id,Name,Auth_Key__c,Phone,Server_URL__c FROM User where Id =: UserInfo.getUserId()];
        authKey = String.isNotBlank(authKey)?authKey:agent.Auth_Key__c;
        String serverURL = agent.Server_URL__c;
        
        String callListId = qsuiteUtilities.createLeadAPI(authKey, phoneNumber,serverURL);
        Boolean loadCallFlag = false;
        Boolean redialflag = false;
        if(string.isNotBlank(callListId))
        {
            loadCallFlag = qsuiteUtilities.loadCallAPI(callListId,authKey,serverURL);
        }
        if(loadCallFlag)
        {
            redialflag = qsuiteUtilities.redialCallAPI(authKey,serverURL);
        }
        if(redialflag)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    @AuraEnabled
    public static Boolean loadCallUuid(String authKey,String uuid){ 
        User agent = [SELECT Id,Name,Auth_Key__c,Phone,Server_URL__c FROM User WHERE Id =: UserInfo.getUserId()];
        authKey = String.isNotBlank(authKey)?authKey:agent.Auth_Key__c;
        String serverURL = agent.Server_URL__c;
        System.debug('CHECK URL: ' + serverURL);
        
        return qsuiteUtilities.loadCallUuidAPI(authKey, uuid, serverURL);
    }
    @AuraEnabled
    public static Boolean redialCallApi(String auth_key){
        User agent = [SELECT Id,Name,Auth_Key__c,Phone,Server_URL__c FROM User where Id =: UserInfo.getUserId()];
        auth_key = String.isNotBlank(auth_key)?auth_key:agent.Auth_Key__c;
        String serverURL = agent.Server_URL__c;
        return qsuiteUtilities.redialCallAPI(auth_key,serverURL);
    }
   
    @AuraEnabled
    public static Boolean cancelGNNAPI(){
        Boolean cancelGNNFlag = false;
        User agent = [SELECT Id,Name,Auth_Key__c,Phone,Server_URL__c FROM User where Id =: UserInfo.getUserId()];
       // String auth_Key = String.isNotBlank(authKey)?authKey:agent.Auth_Key__c;
        String serverURL = agent.Server_URL__c;
        cancelGNNFlag = qsuiteUtilities.cancelGNNAPI(agent.Auth_Key__c,serverURL);
        if(cancelGNNFlag)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    @AuraEnabled
    public static Boolean holdCallApi(String auth_key,String mode){
        User agent = [SELECT Id,Name,Auth_Key__c,Phone,Server_URL__c FROM User where Id =: UserInfo.getUserId()];
        auth_key = String.isNotBlank(auth_key)?auth_key:agent.Auth_Key__c;
        String serverURL = agent.Server_URL__c;
        
        return qsuiteUtilities.HoldCallAPI(auth_key,mode,serverURL);
    }
    @AuraEnabled
    public static Boolean terminateCall(String auth_key){
        User agent = [SELECT Id,Name,Auth_Key__c,Phone,Server_URL__c FROM User where Id =: UserInfo.getUserId()];
        auth_key = String.isNotBlank(auth_key)?auth_key:agent.Auth_Key__c;
        String serverURL = agent.Server_URL__c;
        return qsuiteUtilities.terminateCallAPI(auth_key,serverURL);
    }
    @AuraEnabled
    public static Boolean logOutFromQsuite(String auth_key)
    {
        User agent = [SELECT Id,Name,Auth_Key__c,Phone,Server_URL__c FROM User where Id =: UserInfo.getUserId()];
        auth_key = String.isNotBlank(auth_key)?auth_key:agent.Auth_Key__c;
        String serverURL = agent.Server_URL__c;
        
        Boolean destroyFlag =  qsuiteUtilities.destroyCallAPI(auth_key,serverURL);
        if(destroyFlag)
        {
            Boolean logoutFlag = qsuiteUtilities.logoutCallAPI(auth_key,serverURL);
            if(logoutFlag)
            {
                User user = new User(Id = userInfo.getUserId());
                user.Auth_Key__c = '';
                update  user;
            }
            return true;
        }
        else
        {
            return false;
        }
    }
    @AuraEnabled
    public static Lead getLead(String leadId,String auth_key){
        
        Lead returnLead = [SELECT ID,Name,Phone,MobilePhone FROM Lead where Id =: leadId];
        loadCall(auth_key,returnLead.Phone != null ?returnLead.Phone : returnLead.MobilePhone);
        return returnLead;
    }
    @AuraEnabled
    public static nextCallWrapper nextCallApi(String auth_key){
        
        User agent = [SELECT Id,Name,Auth_Key__c,Phone,Server_URL__c FROM User where Id =: UserInfo.getUserId()];
        auth_key = String.isNotBlank(auth_key)?auth_key:agent.Auth_Key__c;
        String serverURL = agent.Server_URL__c;
        
        qsuiteUtilities.inboundCallResponseWrapper response =  qsuiteUtilities.nextCallApi(auth_key,serverURL);  
        nextCallWrapper returnResp = new nextCallWrapper();
        returnResp.isSucess = response.isSucess;
        returnResp.callerMobileNumber = response.callerMobileNumber;
        return returnResp;
    }
    @AuraEnabled
    public static Boolean transferCallApi(String auth_key,String speciFiedNumber,String PhoneNumber){
        User agent = [SELECT Id,Name,Auth_Key__c,Phone,Server_URL__c FROM User where Id =: UserInfo.getUserId()];
        auth_key = String.isNotBlank(auth_key)?auth_key:agent.Auth_Key__c;
        String serverURL = agent.Server_URL__c;
        
        return qsuiteUtilities.transferCallAPI(auth_key,speciFiedNumber,phoneNumber,serverURL);
    }
    @AuraEnabled
    public static Boolean transferFlipApi(String auth_key){
        User agent = [SELECT Id,Name,Auth_Key__c,Phone,Server_URL__c FROM User where Id =: UserInfo.getUserId()];
        auth_key = String.isNotBlank(auth_key)?auth_key:agent.Auth_Key__c;
        String serverURL = agent.Server_URL__c;
        
        return qsuiteUtilities.transferFlipAPI(auth_key,serverURL);
    }
    @AuraEnabled
    public static getCallDataResponseWrapper getCallDataAPI(String auth_key){
        getCallDataResponseWrapper response = new getCallDataResponseWrapper();
        
        User agent = [SELECT Id,Name,Auth_Key__c,Phone,Server_URL__c FROM User where Id =: UserInfo.getUserId()];
        auth_key = String.isNotBlank(auth_key)?auth_key:agent.Auth_Key__c;
        String serverURL = agent.Server_URL__c;
        
        qsuiteUtilities.getCallDataResponseWrapper resp = qsuiteUtilities.getCallDataAPI(auth_key,serverURL);
     	response.isSuccess =  resp.isSucess;
        response.respJson =  resp.respJson;
        return response;
    }
    @AuraEnabled
    public static Boolean cancelTransferCallAPI(String auth_key){
        User agent = [SELECT Id,Name,Auth_Key__c,Phone,Server_URL__c FROM User where Id =: UserInfo.getUserId()];
        auth_key = String.isNotBlank(auth_key)?auth_key:agent.Auth_Key__c;
        String serverURL = agent.Server_URL__c;
       
        return qsuiteUtilities.cancelTransferCallAPI(auth_key,serverURL);
    }
    
    @AuraEnabled
    public static void createDispositonTask(String jsonString,String leadId)
    {
        wrapper request = (wrapper)System.JSON.deserialize(jsonString,wrapper.class);
        try
        {
            Task task = new Task();
            task.OwnerId = UserInfo.getUserId();
            task.ActivityDate = system.today();
            task.Subject = String.isNotBlank( request.taskElement.subject)? request.taskElement.subject :  'Disposition Not selected.';
            task.Description = request.taskElement.Notes;
            task.WhoId = leadId;
            task.TaskSubtype = 'Call';
            task.Status = 'Open';                           
            
            Insert task;
            if(String.isNotBlank(request.getCallDataResp))
            {
                Attachment att = new Attachment();
                att.body = Blob.valueOf(request.getCallDataResp);
                att.Name = 'Call Data.txt';
                att.ParentId =  task.Id;
                att.ContentType = 'application/text';
                insert att;
            }
            if(request.isEvent)
            {
                Event event = new Event();
                DateTime tempDate = request.eventElement.activityDateTime;
                
                event.Subject = 'Call';
                event.type = 'Call';
                event.WhoId = leadId;
                event.IsReminderSet = true;
                event.OwnerId = UserInfo.getUserId();
                event.Description = request.eventElement.Notes;
                event.DurationInMinutes = 300;
                event.ActivityDateTime = tempDate;
                event.ReminderDateTime = tempDate.addMinutes(-10);
                Insert event;
            }
            
        }Catch(Exception e){
            system.debug('Error ::'+e.getMessage());
            system.debug('Line No.::'+e.getLineNumber());
            system.debug('Error ::'+e.getStackTraceString());
        }
    }
    @AuraEnabled
    public static responseWrapper handleServerCall(String reqJSON)
    {
        try
        { 
            wrapper request = (wrapper)System.JSON.deserialize(reqJSON,wrapper.class);
            List<Task> taskToInsertList = new List<Task>();
            Lead lead = request.lead;
            lead.Inbound_Outbound__c = String.isBlank(request.lead.Inbound_Outbound__c) ? 'Outbound' :request.lead.Inbound_Outbound__c ;
            lead.Disposition__c = request.dispositionName;
            lead.Timestamp__c = system.now();
            if(request.taskElement != null)
            {
                Task task = new Task();
                task.OwnerId = UserInfo.getUserId();
                task.ActivityDate = system.today();
                task.Subject = request.taskElement.subject;
                task.Description = request.taskElement.Notes;
                task.WhoId = lead.Id;
                task.TaskSubtype = 'Call';
                task.Status = 'Open';
                Insert task;
                
                Attachment att = new Attachment();
                att.body = Blob.valueOf(request.getCallDataResp);
                att.Name = 'Call Data.txt';
                att.ParentId =  task.Id;
                att.ContentType = 'application/text';
                insert att;
            }
            if(request.isEvent)
            {
                Event event = new Event();
                DateTime tempDate = request.eventElement.activityDateTime;
                
                event.Subject = 'Call';
                event.type = 'Call';
                event.WhoId = lead.Id;
                event.IsReminderSet = true;
                event.OwnerId = UserInfo.getUserId();
                event.Description = request.eventElement.Notes;
                event.DurationInMinutes = 300;
                event.ActivityDateTime = tempDate;
                event.ReminderDateTime = tempDate.addMinutes(-10);
                Insert event;
            }
            update lead;
            return new responseWrapper(true,'');
        }catch(Exception e)
        {
            system.debug('Error::'+e.getMessage());
            system.debug('Line No::'+e.getLineNumber());
            System.debug('Trace::'+e.getStackTraceString());
            return new responseWrapper(false,e.getMessage());
        }
    }
    // Wrapper class to get the task data
    public class wrapper{
        @AuraEnabled 
        public Lead lead {get;set;}
        @AuraEnabled 
        public Boolean isEvent {get;set;}
        @AuraEnabled 
        public taskWrap taskElement {get;set;}
        @AuraEnabled 
        public taskWrap eventElement {get;set;}
        @AuraEnabled
        public String dispositionName {get;set;}
        @AuraEnabled
        public string getCallDataResp {get;set;}
        
    }
    public class agentDetailsWrapper{
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled
        public String value {get;set;}
        @AuraEnabled
        public DateTime phoneNumber {get;set;}
    }
    public class taskWrap
    {
        @AuraEnabled
        public String subject {get;set;}
        @AuraEnabled
        public String Notes {get;set;}
        @AuraEnabled
        public DateTime activityDateTime {get;set;}
        @AuraEnabled
        public Boolean isDisposition {get;set;}
    }
    // Wrapper for response to the Lightinig component.
    public class responseWrapper
    {
        @AuraEnabled
        public String errorMsg {get;set;}
        @AuraEnabled
        public Boolean isSucess {get;set;}
        responseWrapper(Boolean isSucess,String errorMsg)
        {
            this.isSucess = isSucess;
            this.errorMsg = errorMsg;
        }
    }
    public class nextCallWrapper{
        @AuraEnabled
        public String callerMobileNumber{get;set;}
        @AuraEnabled
        public Boolean isSucess {get;set;}
    }
    //Login response wrapper, this wrappper will return the response of AuthKey.
    //If inbound call happened it will return the generate lead Id and phone details and other details.
    // This will open the tab in edit mode agent will fill the details about callee and same time lead will come to the dialer.
    public class loginResponseWrapper
    {
        @AuraEnabled
        public String authKey {get;set;}
        @AuraEnabled
        public Boolean isInbound {get;set;}
        @AuraEnabled
        public Boolean isSucess {get;set;}
        @AuraEnabled
        public String errorMsg {get;set;}
        @AuraEnabled
        public lead inboundCallLead {get;set;}
    }
    public class leadResponseWrapper
    {
        @AuraEnabled
        public Boolean isSuccess {get;set;}
        @AuraEnabled
        public String errorMsg {get;set;}
        @AuraEnabled
        public lead lead {get;set;}
    }
    public class getCallDataResponseWrapper
    {
        @AuraEnabled
        public Boolean isSuccess {get;set;}
        @AuraEnabled
        public String respJson {get;set;}
    }
}