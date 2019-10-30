({
    getAgentDetails : function(component,event){
        var action = component.get("c.getAgentDetails");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.allAgentsList",response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    console.log("Error message: " + 
                                errors[0].message);
                    this.showToast(component,event,'Opps, Something went wrong please contact to your Adminstrator.');
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
     getAgentAuthKey : function(component,event){
        var action = component.get("c.getAgentAuthKey");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.authKey",response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    console.log("Error message: " + 
                                errors[0].message);
                    this.showToast(component,event,'Opps, Something went wrong please contact to your Adminstrator.');
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    getleadDetails : function(component,event){
        var action = component.get("c.getLeadDetails");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.allAgentsList",response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    console.log("Error message: " + 
                                errors[0].message);
                    this.showToast(component,event,'Opps, Something went wrong please contact to your Adminstrator.');
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    loginToQsuite : function(component,event)
    {
        var action = component.get("c.loginToQsuite");
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                var resp = response.getReturnValue();
                if(resp.isSucess)
                {
                    component.set("v.authKey",resp.authKey);
                    component.set("v.isLoggedInFlag",true);
                    this.getLead(component,event);
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                component.set("v.HideSpinner", false);
                var errors = response.getError();
                if (errors) {
                    console.log("Error message: " + 
                                errors[0].message);
                    this.showToast(component,event,'Sorry, You are not logged in to the Zoiper.');
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);        
    },
    getLead : function(component,event)
    {
        console.log('Get Lead Sucess');
        var authKey = component.get("v.authKey");
        var action = component.get("c.getLead");
        var leadId = component.get("v.recordId");
        action.setParams({ leadId : leadId,auth_key : authKey});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('Get Lead Sucess');
                var returnLead = response.getReturnValue();
                component.set("v.lead",returnLead);
                component.set("v.isOutboundCall",true);
                component.set("v.showDetails",false);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    component.set("v.HideSpinner", false);
                    console.log("Error message: " + 
                                errors[0].message);
                    this.showToast(component,event,"Oops, Something went wrong, Please contact to your administrator.");
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    holdCall : function(component,event,authKey,mode)
    {
        var action = component.get("c.holdCallApi");
        
        action.setParams({auth_key : authKey,mode : mode});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var holdFlag = response.getReturnValue();
                if(holdFlag == true)
                {
                     component.set("v.holdFlag",holdFlag);
                    event.getSource().set("v.label","Un Hold");
                    console.log('call is on Hold');
                }else{
                     component.set("v.holdFlag",holdFlag);
                    event.getSource().set("v.label","Hold");
                    console.log('Call is not on hold');
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    console.log("Error message: " + 
                                errors[0].message);
                    this.showToast(component,event,'Opps, Something went wrong please contact to your Adminstrator.');
                    component.set("v.lead","");
                    component.set("v.isLeadFlag",false);
                } else {
                    console.log("Unknown error");	
                }
            }
        });
        $A.enqueueAction(action);          
    },
    terminateQsuiteCall : function(component,event,authKey)
    {
        console.log('Inside the terminate call');
        var action = component.get("c.terminateCall");
        action.setParams({auth_key : authKey});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue())
                {
                    component.set("v.showDetails",true);
                    component.set("v.isOutboundCall",false);
                    console.log('Calling is terminated sucessful.');
                }else{
                    console.log('Calling is termination failed.');
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    console.log("Error message: " + 
                                errors[0].message);
                    this.showToast(component,event,'Opps, Something went wrong please contact to your Adminstrator.');
                    component.set("v.lead","");
                    component.set("v.isLeadFlag",false);
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);  
    },
    handlelMergeCall : function(component,event,authKey,mode)
    {
        var action = component.get("c.holdCallApi");
        action.setParams({auth_key : authKey,mode : mode});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var holdFlag = response.getReturnValue();
                console.log(holdFlag);
                if(holdFlag === true)
                {
                    component.set("v.holdFlag",holdFlag);
                    console.log('call is on Hold');
                }else{
                    component.set("v.holdFlag",holdFlag);
                    console.log('Call is not on hold');
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    console.log("Error message: " + 
                                errors[0].message);
                    this.showToast(component,event,'Opps, Something went wrong please contact to your Adminstrator.');
                    component.set("v.lead","");
                    component.set("v.isLeadFlag",false);
                } else {
                    console.log("Unknown error");	
                }
            }
        });
        $A.enqueueAction(action);    
    },
    transferFlipCallAPI : function(component,event,authkey)
    {
        var action = component.get("c.transferFlipApi");
        action.setParams({auth_key : authkey});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp)
                {
                    console.log('Transfer flip is Sucessful.');
                }
                else
                {
                    console.log('Transfer flip is failed.');
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    console.log("Error message: " + 
                                errors[0].message);
                    this.showToast(component,event,'Opps, Something went wrong please contact to your Adminstrator.');
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    cancelTransferCallAPI : function(component,event,authkey)
    {
        var action = component.get("c.cancelTransferCallAPI");
        action.setParams({auth_key : authkey});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp)
                {
                    console.log('Cancel Transfer call is Sucessful.');
                }
                else
                {
                    console.log('Cancel Transfer call is failed.');
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    console.log("Error message: " + 
                                errors[0].message);
                    this.showToast(component,event,'Opps, Something went wrong please contact to your Adminstrator.');
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    transferCallAPI : function(component,event,authkey,agentNumber,prospectPhoneNumber)
    {
        var action = component.get("c.transferCallApi");
        action.setParams({auth_key : authkey,speciFiedNumber : agentNumber,PhoneNumber : prospectPhoneNumber});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                
                if(resp)
                {
                    component.set("v.openTransferCallModal",false);
                    console.log('Transfer call is Sucessful.');
                }
                else
                {
                    console.log('Transfer call is failed.');
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    console.log("Error message: " + 
                                errors[0].message);
                    this.showToast(component,event,'Opps, Something went wrong please contact to your Adminstrator.');
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    logOutFromQsuite : function(component,event,authKey)
    {
        var action = component.get("c.logOutFromQsuite");
        action.setParams({auth_key : authKey});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue())
                {
                    console.log('Logout from Qsuite is Sucessful.');
                }else{
                    console.log('Logout from Qsuite is failed.');
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    console.log("Error message: " + 
                                errors[0].message);
                    this.showToast(component,event,'Opps, Something went wrong please contact to your Adminstrator.');
                    component.set("v.lead","");
                    component.set("v.isLeadFlag",false);
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);  
    },
    showToast : function(component,event,msg)
    {
        component.set("v.error",true);
        component.set("v.ErrorMsg",msg);
    }
})