({
    load :  function(component, event, helper) {
        component.set("v.showDetails",true);
        helper.getAgentAuthKey(component,event);
        helper.getAgentDetails(component,event);
    },
    closeModel : function(component, event, helper) {
        component.set("v.error",false);
        component.set("v.ErrorMsg",'');
    },
	handleMakeCall : function(component, event, helper) {
        // This will be moved to the call Initial method
		//component.set("v.isInboundCall",true);
      //  helper.loginToQsuite(component, event);
        component.set("v.isLoggedInFlag",true);
        helper.getLead(component,event);
        component.set("v.isInboundCall",true);
    },
    handleHoldCall : function(component,event,helper)
    {
        var authKey = component.get("v.authKey");
        var holdFlag = component.get("v.holdFlag");
        if(!holdFlag)
        {
            helper.holdCall(component,event,authKey,"on");
        }
        else if(holdFlag)
        {
             helper.holdCall(component,event,authKey,"off");
        }
    },
    handleEndCall : function(component,event,helper)
    {
        var authKey = component.get("v.authKey");
        helper.terminateQsuiteCall(component,event,authKey);
        //helper.logOutFromQsuite(component,event,authKey);
    },
    handleTransferCall :function(component,event,helper)
    {
        component.set("v.openTransferCallModal",true);
        component.set("v.callAgentButtonDisableFlag",true);
        component.find("agentLookup").set("v.value","");
    },
    handleMergeCall : function(component,event,helper){
        var authKey = component.get("v.authKey");
        helper.handlelMergeCall(component,event,authKey,'off');
    },
    handleTransferFlipAPI : function(component,event,helper){
        var authKey = component.get("v.authKey");
        helper.transferFlipCallAPI(component,event,authKey);
    },
    handleCancelTransferAPI : function(component,event,helper)
    {
        var authKey = component.get("v.authKey");
        helper.cancelTransferCallAPI(component,event,authKey);
    },
    closeTransferCallModel : function(component,event,helper)
    {
        component.set("v.openTransferCallModal",false);
        component.set("v.callAgentButtonDisableFlag",true);
        component.find("agentLookup").set("v.value","");
    },
    handleSelectAgnetChange : function(component,event,helper)
    {
        var agentValue = component.find("agentLookup").get("v.value");
        if(agentValue !== '')
        {
        	component.set("v.callAgentButtonDisableFlag",false);   
        }
        else
        {
            component.set("v.callAgentButtonDisableFlag",true);
        }
    },
    handleCallAgent : function(component,event,helper){
        var tempAgentNumber = component.get("v.agentNumber");
        var agentNumber = tempAgentNumber.replace(/[^0-9\.]+/g, '');
        var prospectPhoneNumber = component.get("v.callerId");
        var authKey = component.get("v.authKey");
        var lead = component.get("v.lead");
        if((prospectPhoneNumber == undefined))
        {
            if( lead != undefined &&(lead.Phone !== '' || lead.Phone != undefined || lead.Phone != null))
            {
                prospectPhoneNumber = lead.Phone;
            }else{
                prospectPhoneNumber = lead.mobilePhone;
            }
        }
        helper.transferCallAPI(component,event,authKey,agentNumber,prospectPhoneNumber);
    },
})