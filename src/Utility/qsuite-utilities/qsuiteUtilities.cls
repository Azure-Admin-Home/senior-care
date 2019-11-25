public class qsuiteUtilities {
    // Method to authenticate the user for to the Qsuite
    public String auth_Key {set; get;}
    public static String authorizeToQsuiteAPI(String serverURL,String gateWayKey,String userName,String password)
    {
        String hostName = serverUrl.containsIgnoreCase('/cti')?serverUrl.substring(0,serverUrl.lastIndexOfIgnoreCase('/cti')) : serverUrl;
        
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint(serverURL+Label.Authorization_API+'gateway_key='+gateWayKey+'&username='+userName+'&password='+password+'&hostname='+hostName);
        
        request.setTimeout(120000);
        request.setMethod('GET');
        
        HttpResponse response = new HttpResponse();
        http http = new http();
        response = http.send(request); 
        authenticationWrapper authWrap = (authenticationWrapper)JSON.deserialize(response.getBody(), authenticationWrapper.class);
        string auth_Key = '';
        if(!authWrap.auth_key.isEmpty())
        {
            for(String str : authWrap.auth_key)
            {
                auth_Key = auth_Key+str;
            }
        }
        return auth_Key.trim();
    }
    //Method to authenticate the user for login
    public static Boolean loginToPhoneAPI(String auth_Key,String serverURL)
    {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(serverURL+Label.Login_API+auth_Key+'&inbound=1');      
        request.setTimeout(120000);
        request.setMethod('GET');
        request.setHeader('Content-Type','applicatin/json');
        HttpResponse response = new HttpResponse();
        system.debug('loginToPhoneAPI ::'+response.getBody());
        http http = new http();
        response = http.send(request);   
        logInWrapper resp = (logInWrapper)JSON.deserialize(response.getBody(), logInWrapper.class);
        if(resp.success[0] == '1')
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    //This method execute the getNailAPi and checking if the user assigned extension is there in the list,
    //If the user extention is available it will return the extension Id or it will return false.
    public static Boolean getNailUpAPI(String auth_Key,String serverURL)
    {
        String userExtension = [Select Id,Extension_Id__c FROM User Where Id =: userInfo.getUserId()].Extension_Id__c;
        List<String> deviceIdList = new List<String>();
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint(serverURL+Label.GetNailUp_API+auth_Key);
        request.setTimeout(12000);
        request.setMethod('GET');
        
        HttpResponse response = new HttpResponse();
        http http = new http();
        response = http.send(request); 
        nailUpWrapper resp = (nailUpWrapper)JSON.deserialize(response.getBody(), nailUpWrapper.class);
        if(resp.success[0] == '1')
        {
            return true;
        }else{
            return false;
        }
        
    }
    //Method for NailDown API
    public Static Boolean nailDownAPI(String auth_Key,String serverURL)
    {
        String userExtension = [Select Id,Extension_Id__c FROM User Where Id =: userInfo.getUserId()].Extension_Id__c;
        List<String> deviceIdList = new List<String>();
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint(serverURL+Label.NailDown_API+auth_Key+'&mode=initiate&extension='+userExtension);
        request.setTimeout(120000);
        request.setMethod('GET');
        
        HttpResponse response = new HttpResponse();
        http http = new http();
        response = http.send(request); 
        system.debug('nailDown API ::'+response.getBody());
        nailDownWrapper resp = (nailDownWrapper)JSON.deserialize(response.getBody(), nailDownWrapper.class);
        if(!resp.error.isEmpty())
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    //Method for creteLead API
    public Static String createLeadAPI(String authKey,String phoneNumber,String serverURL)
    {
        Integer userCampaign =(Integer)[Select Id,Campaign_Id__c FROM User Where Id =: userInfo.getUserId()].Campaign_Id__c;
        HttpRequest request = new HttpRequest();
        request.setEndpoint(serverURL+Label.CreatedLead_API+authKey+'&phone_number='+phoneNumber+'&list='+userCampaign);
        request.setTimeout(12000);
        request.setMethod('GET');
        
        HttpResponse response = new HttpResponse();
        http http = new http();
        response = http.send(request); 
        system.debug('create lead API ::'+response.getBody());
        createLeadWrapper resp = (createLeadWrapper)JSON.deserialize(response.getBody(), createLeadWrapper.class);
        String callId = '';
        if(!resp.call_list_id.isEmpty())
        {
            for(String str : resp.call_list_id)
            {
                callId += str;
            }
        }
        return callId.trim();
    }
    //Method for load a call API
    public Static Boolean loadCallAPI(String callListId,String authKey,String serverURL)
    {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(serverURL+Label.Load_Call_API+authKey+'&call_list_id='+callListId);
        request.setTimeout(12000);
        request.setMethod('GET');
        
        HttpResponse response = new HttpResponse();
        http http = new http();
        response = http.send(request); 
        system.debug('Load Call API ::'+response.getBody());
        loadCallWrapper resp = (loadCallWrapper)JSON.deserialize(response.getBody(), loadCallWrapper.class);
        if(!resp.error.isEmpty())
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    //Method for load a call by UUID API
    public Static Boolean loadCallUuidAPI(String authKey, String uuid, String serverURL)
    {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(serverURL+Label.Load_Call_API+authKey+'&uuid='+uuid);
        request.setTimeout(12000);
        request.setMethod('GET');
        
        HttpResponse response = new HttpResponse();
        http http = new http();
        response = http.send(request); 
        system.debug('Load Call API ::'+response.getBody());
        loadCallWrapper resp = (loadCallWrapper)JSON.deserialize(response.getBody(), loadCallWrapper.class);
        if(!resp.error.isEmpty())
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    //Method for redial a call API
    public Static Boolean redialCallAPI(String authKey,String serverURL)
    {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(serverURL+Label.Redial_API+authKey);
        request.setTimeout(12000);
        request.setMethod('GET');
        
        HttpResponse response = new HttpResponse();
        http http = new http();
        response = http.send(request); 
        system.debug('redial response::'+response.getBody());
        redialCallWrapper resp = (redialCallWrapper)JSON.deserialize(response.getBody(), redialCallWrapper.class);
        if(resp.success[0] == '1')
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    //Method for terminate call API
    public Static Boolean terminateCallAPI(String authKey,String serverURL)
    {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(serverURL+Label.Terminate_Call+authKey+'&disposition=28');
        request.setTimeout(12000);
        request.setMethod('GET');
        
        HttpResponse response = new HttpResponse();
        http http = new http();
        response = http.send(request); 
        system.debug('terminate call API ::'+response.getBody());
        termminateCallWrapper resp = (termminateCallWrapper)JSON.deserialize(response.getBody(), termminateCallWrapper.class);
        if(!resp.error.isEmpty())
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    // Method for destroy form the Qsuite API's
    public Static Boolean destroyCallAPI(String auth_Key,String serverURL)
    {
        String userExtension = [Select Id,Extension_Id__c FROM User Where Id =: userInfo.getUserId()].Extension_Id__c;
        HttpRequest request = new HttpRequest();
        request.setEndpoint(serverURL+Label.Destroy_API+auth_key+'&mode=destroy&extension='+userExtension);
        request.setTimeout(12000);
        request.setMethod('GET');
        System.debug('CHECK request: ' + request);
        
        HttpResponse response = new HttpResponse();
        http http = new http();
        response = http.send(request); 
        system.debug('destroyCallAPI ::'+response.getBody());
        logInWrapper resp = (logInWrapper)JSON.deserialize(response.getBody(), logInWrapper.class);
        if(!resp.error.isEmpty())
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    // Method for next call Qsuite API (Inbound call API)
    public Static inboundCallResponseWrapper nextCallApi(String auth_Key,String serverURL)
    {
        try
        {
            HttpRequest request = new HttpRequest();
            request.setEndpoint(serverURL+Label.Next_call_API+auth_key);
            request.setTimeout(120000);
            request.setMethod('GET');
            
            HttpResponse response = new HttpResponse();
            http http = new http();
            response = http.send(request); 
            system.debug('response next call	::'+response.getBody());
            
            nextCallWrapper resp = (nextCallWrapper)JSON.deserialize(response.getBody(), nextCallWrapper.class);
            if(resp.success[0] == '1')
            {
                String callerNumber = resp.inbound[0].callerid[0];
                String did = resp.inbound[0].did[0];
                
                inboundCallResponseWrapper returnResp = new inboundCallResponseWrapper();
                returnResp.callerMobileNumber = callerNumber.substringBetween('<', '>');
                returnResp.did = did;
                returnResp.isSucess = true;
                
                return returnResp;
            }
            else
            {
                inboundCallResponseWrapper returnResp = new inboundCallResponseWrapper();
                returnResp.did = '';
                returnResp.callerMobileNumber = '';
                returnResp.isSucess = false;
                return returnResp;
            }
            
        }catch(Exception e){
            inboundCallResponseWrapper returnResp = new inboundCallResponseWrapper();
            returnResp.did = '';
            returnResp.callerMobileNumber = '';
            returnResp.isSucess = false;
            return returnResp;
        }
    }
    //Method forlogout form the Qsuite API's
    public Static Boolean logoutCallAPI(String auth_Key,String serverURL)
    {
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint(serverURL+Label.LogOut_API+auth_Key+'&reason=End%20of%20Shift');
        request.setTimeout(12000);
        request.setMethod('GET');
        
        HttpResponse response = new HttpResponse();
        http http = new http();
        response = http.send(request); 
        
        system.debug('logout Body::'+response.getBody());
        logOutCallWrapper resp = (logOutCallWrapper)JSON.deserialize(response.getBody(), logOutCallWrapper.class);
        if(!resp.error.isEmpty())
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    //method for hangup call API
/*    public Static Boolean hangUpCallAPI(String authKey)
    {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(Label.Hangup_call_API+authKey);
        request.setTimeout(12000);
        request.setMethod('GET');
        
        HttpResponse response = new HttpResponse();
        http http = new http();
        response = http.send(request); 
        system.debug('hangUpCallAPI ::'+response.getBody());
        hangUpCallWrapper resp = (hangUpCallWrapper)JSON.deserialize(response.getBody(), hangUpCallWrapper.class);
        if(!resp.error.isEmpty())
        {
            return true;
        }
        else
        {
            return false;
        }
    } */
    //method for cancel GNN call API
    public Static Boolean cancelGNNAPI(String authKey,String serverURL)
    {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(serverURL+Label.cancel_GNN_API+authKey);
        request.setTimeout(12000);
        request.setMethod('GET');
        
        HttpResponse response = new HttpResponse();
        http http = new http();
        response = http.send(request); 
        system.debug('cancelGNNAPI ::'+response.getBody());
        hangUpCallWrapper resp = (hangUpCallWrapper)JSON.deserialize(response.getBody(), hangUpCallWrapper.class);
        if(!resp.error.isEmpty())
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    // Method for hold a ongoing call API.
    public Static Boolean HoldCallAPI(String auth_Key,String mode,String serverURL)
    {
        Boolean returnFlag = false;
        HttpRequest request = new HttpRequest();
        request.setEndpoint(serverURL+Label.onHold_Call_API+auth_Key+'&mode='+mode);
        request.setTimeout(12000);
        request.setMethod('GET');
        
        HttpResponse response = new HttpResponse();
        http http = new http();
        response = http.send(request); 
        holdCallWrapper resp = (holdCallWrapper)JSON.deserialize(response.getBody(), holdCallWrapper.class);
        if(!resp.error.isEmpty() && resp.onHold[0] == '1')
        {
            returnFlag = true;
        }
        else if(!resp.error.isEmpty() && resp.onHold[0] == '0')
        {
            returnFlag = false;
        }
        system.debug('returnFlag :: '+returnFlag);
        return returnFlag;
    }
    //Method for the transfer call
    public static Boolean transferCallAPI(String auth_Key,String specifiedNumber,String phoneNumber,String serverURL){
        Boolean returnFlag = false;
        HttpRequest request = new HttpRequest();
        request.setEndpoint(serverURL+Label.Transfer_call_API+auth_Key+'&type=3&specified_number='+specifiedNumber+'&specified_trunk=1&caller_id='+phoneNumber+'&id=6');
        request.setTimeout(12000);
        request.setMethod('GET');
        
        HttpResponse response = new HttpResponse();
        http http = new http();
        response = http.send(request); 
        
        transferCallAPIWrapper resp = (transferCallAPIWrapper)JSON.deserialize(response.getBody(), transferCallAPIWrapper.class);
        if(!resp.error.isEmpty())
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    //Method for the transefer Flip API
    public static Boolean transferFlipAPI(String auth_Key,String serverURL){
        Boolean returnFlag = false;
        HttpRequest request = new HttpRequest();
        request.setEndpoint(serverURL+Label.Transfer_flip_API+auth_Key);
        request.setTimeout(12000);
        request.setMethod('GET');
        
        HttpResponse response = new HttpResponse();
        http http = new http();
        response = http.send(request); 
        trasferFlipWrapper resp = (trasferFlipWrapper)JSON.deserialize(response.getBody(), trasferFlipWrapper.class);
        if(!resp.error.isEmpty())
        {
            return true;
        }
        else
        {
            return false;
        }        
    }
    //Method for transfer cancel API
    public static Boolean cancelTransferCallAPI(String auth_Key,String serverURL){
        Boolean returnFlag = false;
        HttpRequest request = new HttpRequest();
        request.setEndpoint(serverURL+Label.Cancel_Transfer_call_API+auth_Key);
        request.setTimeout(12000);
        request.setMethod('GET');
        
        HttpResponse response = new HttpResponse();
        http http = new http();
        response = http.send(request); 
        trasferCancelWrapper resp = (trasferCancelWrapper)JSON.deserialize(response.getBody(),trasferCancelWrapper.class);
        if(!resp.error.isEmpty())
        {
            return true;
        }
        else
        {
            return false;
        }     
        
    }
   //Method for get call data API
    public static getCallDataResponseWrapper getCallDataAPI(String auth_Key,String serverURL){
       // Boolean returnFlag = false;
        getCallDataResponseWrapper resp = new getCallDataResponseWrapper();
        try
        {
            HttpRequest request = new HttpRequest();
            request.setEndpoint(serverURL+Label.Get_call_data_API+auth_Key);
            request.setTimeout(120000);
            request.setMethod('GET');
            
            HttpResponse response = new HttpResponse();
            http http = new http();
            response = http.send(request);
            resp.isSucess = true;
            resp.respJson = response.getBody();
            
        }Catch(Exception e){
            resp.isSucess = false;
            resp.respJson = '';           
        }
        return resp;
    }
    //Method for get queued call API
    public static GetQueuedCallsWrapper getQueuedCallsAPI(String authKey, String queue, String serverURL){
        GetQueuedCallsWrapper resp = new GetQueuedCallsWrapper();
        try{    
            HttpRequest request = new HttpRequest();
            request.setEndpoint(serverURL+Label.GetQueuedCalls_API+authKey+'&queue='+queue);
            request.setTimeout(12000);
            request.setMethod('GET');

            HttpResponse response = new HttpResponse();
            http http = new http();
            response = http.send(request);
            resp.isSucess = true;
            resp.respJson = response.getBody();
            
        }catch(Exception e){
            resp.isSucess = false;
            resp.respJson = '';           
        }
        return resp; 
    }
    //Wrapper to parse the Authentication response
    public class authenticationWrapper
    {
        public List<String> server;
        public List<String> auth_key;
        public List<String> user_specified_login;
        public List<String> tenant;
        public List<Error> error;
        public List<String> success;
        public List<String> employee;
        public List<String> session;
    }
    //wrapper for loggin response
    public class logInWrapper{
        public list<String> success{get;set;}
        public list<Error> error{get;set;}
    }
    //wrapper for redial response
    public class redialCallWrapper{
        public list<String> success{get;set;}
        public list<error> error{get;set;}
    }
    //Transfer flip API wrapper
    public class trasferFlipWrapper{
        public list<String> success{get;set;}
        public list<error> error{get;set;}
    }
    //Transfer flip API wrapper
    public class trasferCancelWrapper{
        public list<String> success{get;set;}
        public list<error> error{get;set;}
    }
    //wrapper for getNailUpTarger
    public class nailUpWrapper{
        public list<devices> devices{get;set;}
        public list<String> agent_specified_extension{get;set;}
        public list<error> error{get;set;}
        public list<String> success{get;set;}
    }
    public class devices{
        public list<device> device{get;set;}
    }
    public class device{
        public list<String> id{get;set;}
        public list<String> name{get;set;}
    }
    //wrapper for nailDown API
    public class nailDownWrapper{
        public list<manual> manual{get;set;}
        public list<String> action{get;set;}
        public list<String> success{get;set;}
        public list<error> error{get;set;}
    }
    public class manual{
        public list<message> message{get;set;}
        public list<String> seat{get;set;}
    }
    public class message{
    }
    //Wrapper for createLeadAPI
    public class createLeadWrapper{
        public list<String> campaign{get;set;}
        public list<String> success{get;set;}
        public list<error> error{get;set;}
        public list<String> call_list_id{get;set;}
    }
    //wrapper for loadCall API
    public class loadCallWrapper{
        public list<String> success{get;set;}
        public list<error> error{get;set;}
        public list<String> call_type_text{get;set;}
        public list<manual_call> manual_call{get;set;}
        public list<String> call_list_id{get;set;}
        public list<String> call_history_id{get;set;}
    }
    public class manual_call{
    }
    // wrapper for terminate call API
    public class termminateCallWrapper{
        public list<String> denail{get;set;}
        public list<String> success{get;set;}
        public list<String> logout{get;set;}
        public list<next_call_lead_id> next_call_lead_id{get;set;}
        public list<error> error{get;set;}
    }
    public class next_call_lead_id{
    }
    //Wrapper for the logoutCallAPI
    public class logOutCallWrapper{
        public list<String> message{get;set;}
        public list<error> error{get;set;}
        public list<String> success{get;set;}
    }
    //Wrapper for holdCall
    public class holdCallWrapper{
        public list<error> error{get;set;}
        public list<String> onHold{get;set;}
        public list<String> success{get;set;}
    }
    //wrapper for nextCall method
       public class nextCallWrapper{
        public list<String> on_hook{get;set;}
        public list<String> transfer_conference{get;set;}
        public list<String> success{get;set;}
        public list<String> call_list_id{get;set;}
        public list<String> abandoned{get;set;}
        public list<String> callback_alert{get;set;}
        public list<String> campaign{get;set;}
        public list<String> action{get;set;}
        public list<String> non_media_event{get;set;}
        public list<String> call_type_text{get;set;}
        public list<String> type{get;set;}
        public list<String> uuid{get;set;}
        public list<inwaiting_audio> inwaiting_audio{get;set;}
        public list<String> transfer_type{get;set;}
        public list<inbound> inbound{get;set;}
        public list<error_code> error_code{get;set;}
        public list<String> transfer_starter{get;set;}
        public list<error> error{get;set;}
        
    }
    public class inbound{
        public list<String> wait_time{get;set;}
        public list<String> queue{get;set;}
        public list<String> callerid{get;set;}
        public list<String> did{get;set;}
    }
    public class error_code{
        
    }
    public class error{
        
    }
    public class inwaiting_audio{
        
    }
    //wrapper for hangup call API
    public class hangUpCallWrapper{
        public list<String> success{get;set;}
        public list<error> error{get;set;}
    }
    //wrapper to send the ibound call response
    public class inboundCallResponseWrapper
    {
        public String callerMobileNumber{get;set;}
        public String did{get;set;}
        public Boolean isSucess {get;set;}
    }
    //wrapper for transfer call API
    public class transferCallAPIWrapper{
        public list<String> success{get;set;}
        public list<String> type{get;set;}
        public list<error> error{get;set;}
        public list<timers> timers{get;set;}
    }
    public class timers{
        
    }
    //get callData response wrapper
    public class getCallDataResponseWrapper{
		public Boolean isSucess{get;set;}
        public String respJson{get;set;}
    }
    //get queuedCalls response wrapper
    public class GetQueuedCallsWrapper{
		public Boolean isSucess{get;set;}
        public String respJson{get;set;}
    }
}