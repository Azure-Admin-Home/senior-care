({
    callerMethod : function(component,event,jsonString,leadId)
    {       
        var onlineFLag = component.get("v.omniOnlineFlag");
        var action = component.get("c.handleServerCall");
        var omniAPI = component.find("omniToolkit");
        var authKey = component.get("v.authKey");
        var incomingOnlyFlag = component.get("v.incomingOnlyFlag");
        var outboundOnlyFlag = component.get("v.outboundOnlyFlag");
        action.setParams({ reqJSON : jsonString});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp.isSucess)
                {
                    if(incomingOnlyFlag)
                    {
                        this.handleInboundOnly(component,event,authKey);
                    }
                    else if(outboundOnlyFlag)
                    {
                        this.handleNextCallOnOutboundOnly(component,event,authKey);
                    }
                    else{
                        this.handleInboundCallOnLead(component,event,authKey,omniAPI,leadId); 
                    }
                }
                else
                {
                    console.log(resp.errorMsg);
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    loginToQsuite : function(component,event,omniAPI,inboundOn,callback)
    {
        if(inboundOn === undefined){
            inboundOn = true;
        }
        var action = component.get("c.loginToQsuite");
        var incomingOnlyFlag = component.get('v.incomingOnlyFlag');
        var outboundOnlyFlag = component.get("v.outboundOnlyFlag");
        console.log('outboundOnlyFlag::'+outboundOnlyFlag);
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            console.log("CHECK response State: " + state);
            if (state === "SUCCESS") 
            {
                var resp = response.getReturnValue();
                console.log("CHECK response returnValue: ", resp);
                if(resp.isSucess)
                {
                    component.set("v.authKey",resp.authKey);
                    component.set("v.isLoggedInFlag",true);
                    
                    if(inboundOn){
                    	if(incomingOnlyFlag){
                            this.handleInboundOnly(component,event,resp.authKey); 
                        }
                        else if(outboundOnlyFlag){
                            console.log('inside the call for outbound only');
                            this.handleOutboundOnly(component,event,resp.authKey);
                        }else{
                            this.handleInboundCall(component,event,resp.authKey);
                        }   
                    }
                    
                    if(callback !== undefined){
                        callback();
                    }
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
                    component.set("v.lead","");
                    component.set("v.isLeadFlag",false);
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);        
    },
    loadCallOnQsuite : function(component,event,authKey,phoneNumber)
    {
        var action = component.get("c.loadCall");
        action.setParams({authKey : authKey,phoneNumber : phoneNumber});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue())
                {
                    console.log('Calling is sucessful.');
                }else{
                    console.log('Calling is failed.');
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    console.log("Error message: " + 
                                errors[0].message);
                    this.showToast(component,event,'No Lead is present in my work');
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
        var action = component.get("c.terminateCall");
        action.setParams({auth_key : authKey});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue())
                {
                    component.set("v.endCallFlag",true);
                    console.log('Calling is terminated sucessful.');
                    this.getCallDataAPI(component,event,authKey);
                    this.nextCallButtonValidation(component);
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
                    this.showToast(component,event,'No Lead is present in my work');
                    component.set("v.lead","");
                    component.set("v.isLeadFlag",false);
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);  
    },
    logOutFromQsuite : function(component,event,authKey,callback)
    {
        var action = component.get("c.logOutFromQsuite");
        action.setParams({auth_key : authKey});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue())
                {
                    component.set("v.isLoggedInFlag",false);
                    console.log('Logout from Qsuite is Sucessful.');
                }else{
                    console.log('Logout from Qsuite is failed.');
                }
                if(callback !== undefined){
                    callback();
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    console.log("Error message: " + 
                                errors[0].message);
                    this.showToast(component,event,'No Lead is present in my work');
                    component.set("v.lead","");
                    component.set("v.isLeadFlag",false);
                } else {
                    console.log("Unknown error");
                }
                if(callback !== undefined){
                    callback();
                }
            }
        });
        $A.enqueueAction(action);  
    },
    handleInboundCall : function(component,event,authKey)
    {
        var authKey = component.get("v.authKey");
        var omniOnlineFlag = component.get('v.omniOnlineFlag');
        var incomingOnlyFlag = component.get('v.incomingOnlyFlag');
        var omniAPI = component.find("omniToolkit");
        var action = component.get("c.nextCallApi");
        action.setParams({auth_key : authKey});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp.isSucess)
                {
                    console.log('Inbound call is going on.')
                    component.set("v.lead","");
                    component.set("v.isLeadFlag",false);
                    component.set("v.HideSpinner", false);
                    component.set("v.onlineFLag",true);
                    component.set("v.leadFirstName","");
                    component.set("v.leadLastName","");
                    component.set("v.callerId",resp.callerMobileNumber);
                    component.set("v.leadInputModalBox",true);
                    component.set("v.callFinished",false);
                    component.set("v.dispositionValue","");
                    component.set("v.authKey",resp.authKey);
                }
            /*    else if(omniOnlineFlag == true)
                {
                    conosle.log('Check for outbound call.');
                    window.setTimeout(
                        $A.getCallback(function() {
                            omniAPI.getAgentWorks().then(function(result) {
                                var works = JSON.parse(result.works);
                                var leadId = (works[0].workItemId);
                                if(leadId){
                                    var action = component.get("c.getLead");
                                    action.setParams({ leadId : leadId,auth_key : authKey});
                                    action.setCallback(this, function(response) {
                                        var state = response.getState();
                                        if (state === "SUCCESS") {
                                            component.set("v.HideSpinner", false);
                                            component.set("v.onlineFLag",true);
                                            var returnLead = response.getReturnValue();
                                            component.set("v.lead",returnLead);
                                            component.set("v.isLeadFlag",true);
                                            var workspaceAPI = component.find("workspace");
                                            workspaceAPI.openTab({
                                                pageReference: {
                                                    "type": "standard__recordPage",
                                                    "attributes": {
                                                        "recordId":returnLead.Id, //lead Id
                                                        "actionName":"view"
                                                    },
                                                    "state": {}
                                                },
                                                focus: true
                                            }).then(function(response) {
                                                
                                            }).catch(function(error) {
                                                console.log(error);
                                            });
                                        }
                                        else if (state === "INCOMPLETE") {
                                            // do something
                                        }else if (state === "ERROR") {
                                            var errors = response.getError();
                                            if (errors) {
                                                component.set("v.HideSpinner", false);
                                                console.log("Error message: " + 
                                                            errors[0].message);
                                                this.showToast(component,event,errors[0].message);
                                                component.set("v.lead","");
                                                component.set("v.isLeadFlag",false);
                                            } else {
                                                console.log("Unknown error");
                                            }
                                        }
                                    });
                                    $A.enqueueAction(action);
                                }else{
                                    helper.showToast(component,event,'No Lead is present in my work');
                                }
                            }).catch(function(error) {
                                console.log(error);
                            });
                        }), 
                    10000);
                }  */
                else
                {
                    var leadPhoneOnline = component.get("v.leadphoneOnlineFlag");
                    var self = this;
                    if(leadPhoneOnline)
                    {
                        window.setTimeout(
                            $A.getCallback(function() {
                                var statusString = $A.get("$Label.c.Status_Json");
                                component.set("v.callFinished",false);
                                component.set("v.dispositionValue","");
                                var statusList = JSON.parse(statusString);
                                statusList.forEach(function(status){
                                    if(status.MasterLabel === 'Online'){
                                        omniAPI.setServicePresenceStatus({statusId: status.Id}).then(function(result) {
                                            try{
                                                console.log('CHECK result: ', result);
                                            	self.addClassToStatusIcon(component,event,'Online');
                                            } catch(err){
                                                console.error('CHECK ERROR: ', err);
                                            }
                                        }).catch(function(error) {
                                            console.log(error);
                                        });
                                    }
                                });
                            }), 9000
                        );
                    }
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    console.log("Error message: " + 
                                errors[0].message);
                    this.showToast(component,event,'No Lead is present in my work');
                    component.set("v.lead","");
                    component.set("v.isLeadFlag",false);
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);  
    },
    getLead : function(component,event,leadId)
    {
        var authKey = component.get("v.authKey");
        var action = component.get("c.getLead");
        action.setParams({ leadId : leadId,auth_key : authKey});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.HideSpinner", false);
                component.set("v.onlineFLag",true);
                var returnLead = response.getReturnValue();
                component.set("v.lead",returnLead);
                if(returnLead.Phone !== '' || returnLead.Phone != undefined || returnLead.Phone != null)
                {
                    component.set("v.callerId",returnLead.Phone);
                }else{
                    component.set("v.callerId",returnLead.mobilePhone);
                }   
                component.set("v.isLeadFlag",true);
                var workspaceAPI = component.find("workspace");
                workspaceAPI.openTab({
                    pageReference: {
                        "type": "standard__recordPage",
                        "attributes": {
                            "recordId":returnLead.Id, //lead Id
                            "actionName":"view"
                        },
                        "state": {}
                    },
                    focus: true
                }).then(function(response) {
                    
                }).catch(function(error) {
                    console.log(error);
                });
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    component.set("v.HideSpinner", false);
                    console.log("Error message: " + 
                                errors[0].message);
                    this.showToast(component,event,errors[0].message);
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
    },
    addClassToStatusIcon : function(component,event,selectedClass)
    {
        var cmpDiv = component.find('selectedStatus');
        if(selectedClass === 'Online')
        {
            $A.util.removeClass(cmpDiv, 'Break');
            $A.util.removeClass(cmpDiv, 'Offline');
            $A.util.addClass(cmpDiv, selectedClass);
        }
        else if(selectedClass === 'Offline'){
            $A.util.removeClass(cmpDiv, 'Break');
            $A.util.removeClass(cmpDiv, 'Online');
            $A.util.addClass(cmpDiv, selectedClass);
        }else {
            $A.util.removeClass(cmpDiv, 'Online');
            $A.util.removeClass(cmpDiv, 'Offline');
            $A.util.addClass(cmpDiv, 'Break');
        }
    },
    createDisposition : function(component,event,taskElement,leadId)
    {
        var action = component.get("c.createDispositonTask");
        action.setParams({jsonString : taskElement, leadId : leadId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    console.log("Error message: " + 
                                errors[0].message);
                    this.showToast(component,event,'Something went wrong please contact to your administrator.');
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    enrollmentCall: function(component,event,authKey)
    {
        var uuid = event.getParam("uuid");
        var action = component.get("c.loadCallUuid");
        console.log('uuid',uuid);
        action.setParams({
            auth_key : authKey,
            uuid : uuid
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue())
                {
                    console.log('enrollment call is sucessful.');
                }else{
                    console.log('enrollment call is failed.');
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    console.log("Error message: " + 
                                errors[0].message);
                    this.showToast(component,event,'Error while enrollment call');
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);  
    },
    redialCall: function(component,event,authKey)
    {
        var action = component.get("c.redialCallApi");
        action.setParams({auth_key : authKey});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue())
                {
                    console.log('redial call is sucessful.');
                }else{
                    console.log('redial call is failed.');
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    console.log("Error message: " + 
                                errors[0].message);
                    this.showToast(component,event,'No Lead is present in my work');
                    component.set("v.lead","");
                    component.set("v.isLeadFlag",false);
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
                console.log('response::'+response.getReturnValue());
                if(holdFlag == true)
                {
                    component.set("v.holdFlag",holdFlag);
                    event.getSource().set("v.label","Un Hold");
                    console.log('call is on Hold');
                }else{
                    event.getSource().set("v.label","Hold");
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
                    this.showToast(component,event,'No Lead is present in my work');
                    component.set("v.lead","");
                    component.set("v.isLeadFlag",false);
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
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    getAgentDetails : function(component,event){
        var action = component.get("c.getAgentDetails");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                component.set("v.allAgentsList",resp);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    console.log("Error message: " + 
                                errors[0].message);
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    pauseCallApi : function(component,event)
    {
        var action = component.get("c.pauseCallApi");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                //	component.set("v.allAgentsList",resp);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    console.log("Error message: " + 
                                errors[0].message);
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    handleInboundCallOnLead : function(component,event,authKey,omniAPI,lead)
    {
        var omniAPI = component.find("omniToolkit");
        var omniOnlineFlag = component.get("v.omniOnlineFlag");
        var incomingOnlyFlag = component.get('v.incomingOnlyFlag');
        var leadId = lead.Id;
        var action = component.get("c.nextCallApi");
        action.setParams({auth_key : authKey});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp.isSucess)
                {
                    component.set("v.HideSpinner", false);
                    component.set("v.onlineFLag",true);
                    component.set("v.lead","");
                    component.set("v.isLeadFlag",false);
                    component.set("v.leadFirstName","");
                    component.set("v.leadLastName","");
                    component.set("v.callerId",resp.callerMobileNumber);
                    component.set("v.leadInputModalBox",true);
                    component.set("v.callFinished",false);
                    component.set("v.dispositionValue","");
                    component.find("callNotes").set("v.value","");
                    component.find("followupTaskNotes").set("v.value","");
                    component.find("dueDate").set("v.value","");
                }
               /* else if(lead.Inbound_Outbound__c !== 'Inbound')
                {
                    window.setTimeout(
                        $A.getCallback(function() {
                            omniAPI.getAgentWorks().then(function(result) {
                                var works = JSON.parse(result.works);
                                works.forEach(function (item){
                                    if(item.workItemId == leadId.substring(0,15))
                                    {
                                        omniAPI.closeAgentWork({workId: item.workId}).then(function(res) {
                                            if (res) {
                                                component.set("v.lead","");
                                                component.set("v.isLeadFlag",false);
                                                component.find("callNotes").set("v.value","");
                                                component.find("followupTaskNotes").set("v.value","");
                                                component.set("v.dispositionValue","");
                                            } else {
                                                console.log("Close work failed");
                                            }
                                        }).catch(function(error) {
                                            console.log(error);
                                        });
                                    }
                                });
                            });
                        }), 10000
                    );
                }
                    else if(omniOnlineFlag == true )
                    {
                        window.setTimeout(
                            $A.getCallback(function() {
                                omniAPI.getAgentWorks().then(function(result) {
                                    var works = JSON.parse(result.works);
                                    var leadId = (works[0].workItemId);
                                    if(leadId){
                                        var action = component.get("c.getLead");
                                        action.setParams({ leadId : leadId,auth_key : authKey});
                                        action.setCallback(this, function(response) {
                                            var state = response.getState();
                                            if (state === "SUCCESS") {
                                                component.set("v.HideSpinner", false);
                                                component.set("v.onlineFLag",true);
                                                var returnLead = response.getReturnValue();
                                                component.set("v.lead",returnLead);
                                                component.set("v.isLeadFlag",true);
                                                var workspaceAPI = component.find("workspace");
                                                workspaceAPI.openTab({
                                                    pageReference: {
                                                        "type": "standard__recordPage",
                                                        "attributes": {
                                                            "recordId":returnLead.Id, //lead Id
                                                            "actionName":"view"
                                                        },
                                                        "state": {}
                                                    },
                                                    focus: true
                                                }).then(function(response) {
                                                    
                                                }).catch(function(error) {
                                                    console.log(error);
                                                });
                                            }
                                            else if (state === "INCOMPLETE") {
                                                // do something
                                            }else if (state === "ERROR") {
                                                var errors = response.getError();
                                                if (errors) {
                                                    component.set("v.HideSpinner", false);
                                                    console.log("Error message: " + 
                                                                errors[0].message);
                                                    this.showToast(component,event,errors[0].message);
                                                    component.set("v.lead","");
                                                    component.set("v.isLeadFlag",false);
                                                } else {
                                                    console.log("Unknown error");
                                                }
                                            }
                                        });
                                        $A.enqueueAction(action);
                                    }else{
                                        this.showToast(component,event,'No Lead is present in my work');
                                    }
                                }).catch(function(error) {
                                    console.log(error);
                                });
                            }), 
                            9000);
                    } */
                else
                {
                    var leadPhoneOnline = component.get("v.leadphoneOnlineFlag");
                    if(leadPhoneOnline)
                    {
                        window.setTimeout(
                            $A.getCallback(function() {
                                var statusString = $A.get("$Label.c.Status_Json");
                                component.set("v.callFinished",false);
                                component.set("v.dispositionValue","");
                                var statusList = JSON.parse(statusString);
                                statusList.forEach(function(status){
                                    if(status.MasterLabel === 'Online'){
                                        omniAPI.setServicePresenceStatus({statusId: status.Id}).then(function(result) {
                                            this.addClassToStatusIcon(component,event,'Online');
                                        }).catch(function(error) {
                                            console.log(error);
                                        });
                                    }
                                });
                            }), 9000
                        );
                    }
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    console.log("Error message: " + 
                                errors[0].message);
                    this.showToast(component,event,'No Lead is present in my work');
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
                if(holdFlag == true)
                {
                    component.set("v.holdFlag",holdFlag);
                    event.getSource().set("v.label","Un Hold");
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
                    component.set("v.lead","");
                    component.set("v.isLeadFlag",false);
                } else {
                    console.log("Unknown error");	
                }
            }
        });
        $A.enqueueAction(action);    
    },
    handleCreateLead : function(component,event,jsonString)
    {
        var action = component.get("c.createLeadRecord");
        action.setParams({jsonString : jsonString});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp.isSuccess)
                {
                    component.set("v.lead",resp.lead);
                    component.set("v.isLeadFlag",true);
                    var workspaceAPI = component.find("workspace");
                    workspaceAPI.getFocusedTabInfo()
                    .then(response => {
                        var focusedTabId = response.tabId;
                        workspaceAPI.openTab({recordId: resp.lead.Id, 
                                              focus: true}
                        )
                        .then(response => {
                                workspaceAPI.closeTab({tabId: focusedTabId})
                                .catch(error => console.log(error));
                        })
                        .catch( error => console.log(error));
                    })
                    .catch( error => console.log(error));
                    
                }else{
                    console.log(resp.errorMsg);
                    this.showToast(component,event,'Some went wrong while lead creation, please contact to Administrator.');
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    console.log("Error message: " + 
                                errors[0].message);
                    this.showToast(component,event,'No Lead is present in my work');
                    component.set("v.lead","");
                    component.set("v.isLeadFlag",false);
                } else {
                    console.log("Unknown error");	
                }
            }
        });
        $A.enqueueAction(action);  
    },
    handleInboundOnly : function(component,event,authKey){
        this.callNextCallAPI(component,event,authKey);
    },
    callNextCallAPI : function(component,event,authKey){
        window.setTimeout(
            $A.getCallback(function() {
                // this.cancelGNNAPI(component,event,helper);
                // console.log('inside cancel GNN api')
                var action = component.get("c.cancelGNNAPI");
                action.setParams({auth_key : authKey});
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var resp = response.getReturnValue();
                        if(!resp)
                        {
                            console.log('Cancel the inbound call failed.')
                        }
                    }
                    else if (state === "INCOMPLETE") {
                        // do something
                    }else if (state === "ERROR") {
                    }
                });
                $A.enqueueAction(action);  
            }), 110000
        );
        var omniOnlineFlag = component.get('v.omniOnlineFlag');
        var incomingOnlyFlag = component.get('v.incomingOnlyFlag');
        console.log('Check for inbound call');
        var action = component.get("c.nextCallApi");
        action.setParams({auth_key : authKey});
        action.setCallback(this, function(response) {
            // const self= this;
            this.handleNextCallAPIResponse(component,event,authKey,response);
        });
        $A.enqueueAction(action);
    },
    handleNextCallAPIResponse : function(component,event,authKey,response){
        var incomingOnlyFlag =  component.get("v.incomingOnlyFlag");
        var state = response.getState();
        const  self= this;
        if (state === "SUCCESS") {
            var resp = response.getReturnValue();
            if(resp.isSucess)
            {
                console.log('Inbound call is going on.')
                component.set("v.lead","");
                component.set("v.isLeadFlag",false);
                component.set("v.onlineFLag",true);
                component.set("v.HideSpinner", false);
                component.set("v.leadFirstName","");
                component.set("v.leadLastName","");
                component.set("v.callerId",resp.callerMobileNumber);
                component.set("v.leadInputModalBox",true);
                component.set("v.callFinished",false);
                component.set("v.dispositionValue","");
            }
            else
            {
                if(incomingOnlyFlag)
                {
                    window.setTimeout(
                        $A.getCallback(function() {
                            component.callNextCall();
                        }),6000
                    );
                }
            }
        }
        else if (state === "INCOMPLETE") {
            // do something
        }else if (state === "ERROR") {
            var errors = response.getError();
            if (errors) {
                if(incomingOnlyFlag && errors[0].message.search('Timeout') !== -1)
                {
                    this.callNextCallAPI(component,event,authKey);
                }
                else
                {
                    console.log("Error message: " + 
                                errors[0].message);
                    this.showToast(component,event,'Error while fetching the Inbound calls, Please contact to you Administrator');
                    component.set("v.lead","");
                    component.set("v.isLeadFlag",false);
                }
            } else {
                console.log("Unknown error");
            }
        }
    },
    getCallDataAPI : function(component,event,authkey)
    {
        console.log('Inside the getCallData API');
        var action = component.get("c.getCallDataAPI");
        action.setParams({auth_key : authkey});
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state::'+state);
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp.isSuccess){
                    console.log('getCallData Sucessfull.');
                    component.set("v.getCallDataResponse",resp.respJson);
                }
                else
                {
                    console.log('getCallData failed.');
                    component.set("v.getCallDataResponse","");
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    console.log("Error message: " + 
                                errors[0].message);
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    cancelGNNAPI : function(component,event,helper)
    {
        console.log('inside cancel GNN api')
        var action = component.get("c.cancelGNNAPI");
        //  action.setParams({auth_key : authKey});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(!resp)
                {
                    console.log('Cancel the inbound call sucessfull')
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
            }
        });
        $A.enqueueAction(action);  
    },
    omniLogout : function(component,event)
    {
        var omniAPI = component.find("omniToolkit");
        omniAPI.logout().then(function(result) {
            if (result) {
                console.log("Logout successful");
            } else {
                console.log("Logout failed");
            }
        }).catch(function(error) {
            console.log(error);
        });
    },
    handleOutboundOnly : function(component,event,authKey)
    {
        console.log("CHECK callFinished", component.get("v.callFinished"));
        component.set("v.callFinished",false);
        var omniAPI = component.find("omniToolkit");
        var statusString = $A.get("$Label.c.Status_Json");
        var statusList = JSON.parse(statusString);
        statusList.forEach(function(status){
            if(status.MasterLabel === 'Online - Outbound Calls Only'){
                omniAPI.setServicePresenceStatus({statusId: status.Id}).then(function(result) {
                    this.addClassToStatusIcon(component,event,'Online');
                }).catch(function(error) {
                    console.log("ERR omniApiError: ", error);
                });
            }
        });
    },
    handleNextCallOnOutboundOnly : function(component,event)
    {
    	self = this;
        self.closeTheOmniChannelMyWork(component,event);
	},
    closeTheOmniChannelMyWork : function(component,event){
        this.closeFocusedTab(component,event);
        
        var omniAPI = component.find("omniToolkit");
        omniAPI.getAgentWorks().then(function(result) {
            console.log(result.works);
            var works = JSON.parse(result.works);
            var workId = works[0].workId;
            if(workId)
            {
                omniAPI.closeAgentWork({workId: workId}).then(function(res) {
                    if (res) {
                        component.set("v.callAssignFlag",false);
                        component.set("v.lead","");
                        component.set("v.isLeadFlag",false);
                        component.set("v.leadFirstName","");
                        component.set("v.leadLastName","");
                        component.set("v.callerId","");
                        component.set("v.dispositionValue","");
                        console.log('Work is closed now.');
                    } else {
                        console.log("Close work failed");
                    }
                }).catch(function(error) {
                    console.log(error);
                });
            }
        });
    },
    handleMiniDialerVisibility : function(component,event,visibility)
    {
        var action = component.get("c.handleMiniDialerVisibility");
        action.setParams({visibility : visibility});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('Mini Dialer Visibility is updated Successfully.');
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
            }
        });
        $A.enqueueAction(action);  
    },
    loginToQsuiteForManualDialing : function(component,event,omniAPI)
    {
        var action = component.get("c.loginToQsuite");
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                var resp = response.getReturnValue();
                if(resp.isSucess)
                {
                    component.set("v.isLoggedInFlag",true);
                    console.log('Login to Qsuite Sucessfull.');
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
                    component.set("v.lead","");
                    component.set("v.isLeadFlag",false);
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);        
    },
    closeFocusedTab : function(component, event) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
    },

    nextCallButtonValidation : function(component) {
        const isLead = component.get("v.isLeadFlag");
        const callFinished = component.get("v.callFinished");
        console.log("CHECK callFinished: ", callFinished);
        const isCallNotFinished = (callFinished === false);
        console.log("CHECK isCallNotFinished: ", isCallNotFinished);

        let disableNextCall;
        
        if(isLead === true){
            const disposition = component.get("v.dispositionValue");
            disableNextCall = this.createLeadValidation(disposition, isCallNotFinished);
        } else {
            disableNextCall = isCallNotFinished;
        }
        
        component.set("v.nextCallFlag", disableNextCall);
    },

    createLeadValidation : function(disposition, isCallNotFinished){
        const isDispUndefined = (disposition === undefined);
        const isDispEmpty = (disposition === "");
        const isDispNull = (disposition === null);
        const isDispositionNotSelected = isDispEmpty || isDispNull || isDispUndefined;
        return (isDispositionNotSelected || isCallNotFinished);
    },

    createLogCallForDefaultDispositionStatuses : function(component){
        const isPrevStatusDefaultDisp = component.get("v.defaultDispStatus");
        console.log("CHECK isPrevStatusDefaultDisp: ", isPrevStatusDefaultDisp);
        const prevStatus = component.get("v.prevStatus");
        console.log("CHECK prevStatus: ", prevStatus);
        if(isPrevStatusDefaultDisp === true){
            const isPrevStatusInboundOnly = (prevStatus === "Online – Inbound Only");
            if(isPrevStatusInboundOnly){
                this.createLogCallForInboundOnly(component);
            } else {
                this.populateDefaultDisposition(component);
            }
        }
    },

    createLogCallForInboundOnly : function(component){
        const leadFlag = component.get("v.isLeadFlag");
        console.log("CHECK leadFlag: ", leadFlag);
        const isInboundLeadCreatedThrowDialer = (leadFlag === true);
        if(isInboundLeadCreatedThrowDialer){
            this.populateDefaultDisposition(component);
        }
    },

    checkIfSelectedStatusDefaultDisposition : function(component, selectedStatus){
        const defaultDispStatusesString = $A.get("$Label.c.Disposition_Default_Statuses");
        const defaultDispStatuses = JSON.parse(defaultDispStatusesString);
        let isDefaultDispostionStatus = false;
        defaultDispStatuses.forEach( status => {
            const isSelectedStatusDefaultDisposition = (selectedStatus === status);
            if(isSelectedStatusDefaultDisposition){
                isDefaultDispostionStatus = true;
            }
        });
        component.set("v.defaultDispStatus", isDefaultDispostionStatus);
    },

    populateDefaultDisposition : function(component){
        const disposition = component.get("v.dispositionValue");
        const isDispositionNotSelected = this.checkIfDispositionNotSelected(disposition);
        if(isDispositionNotSelected){
            const defaultLog = this.createDefaultLog(component);
            this.saveDefaultLog(component, defaultLog);
        }
    },

    checkIfDispositionNotSelected: function(disposition){
        const isDispUndefined = (disposition === undefined);
        const isDispEmpty = (disposition === "");
        const isDispNull = (disposition === null);
        return isDispEmpty || isDispNull || isDispUndefined;
    },

    createDefaultLog : function(component){
        const lead = component.get("v.lead");
        const defaultDisposition = $A.get("$Label.c.Disposition_Default");
        const callNotes = component.get("v.callNotes");
        const getCallDataResponse = component.get("v.getCallDataResponse");
        
        const logCallTask = {"subject": defaultDisposition,
                             "Notes": callNotes,
                             "isDisposition": true};
        
        const createRequest = {"lead": lead,
                               "isEvent": false,
                               "isDisposition": true,
                               "dispositionName": defaultDisposition,
                               "getCallDataResp": getCallDataResponse,
                               "taskElement": logCallTask};

        return JSON.stringify(createRequest);
    },
    
    saveDefaultLog : function(component, defaultLog){
        const action = component.get("c.handleServerCall");
        action.setParams({ reqJSON : defaultLog});
        action.setCallback(this, response => {
            const state = response.getState();
            if (state === "SUCCESS") {
                const resp = response.getReturnValue();
                if(resp.isSucess){
                    console.log("Default log created successful");
                } else {
                    console.log(resp.errorMsg);
                }
            } else if (state === "ERROR") {
                const errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})