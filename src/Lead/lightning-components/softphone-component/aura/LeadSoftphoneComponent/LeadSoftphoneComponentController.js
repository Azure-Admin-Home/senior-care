({
    load : function(component, event, helper) {
        var omniAPI = component.find("omniToolkit");
        var today = new Date();
        var date = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate();
        var despositionStirng = $A.get("$Label.c.Disposition_List");
        var optionList = despositionStirng.split(',');
        var dispositionOptionList = [];
        var selectedStatus = component.get("v.selectedStatus");
        optionList.forEach(function(desposition){
            var element = {};
            element.label = desposition;
            element.value = desposition;
            dispositionOptionList.push(element);
        });
        component.set("v.defaultDate",date);
        component.set("v.dispositionOptionList",dispositionOptionList);
        component.set("v.getCallDataResponse","");
        
        var statusString = $A.get("$Label.c.Status_Json");
        var statusList = JSON.parse(statusString);
        
        omniAPI.getServicePresenceStatusId().then(function(result) {
            helper.addClassToStatusIcon(component,event,result.statusName);
            
            component.set("v.selectedStatus",result.statusName);
            // comopnent.find('statusMenu').set("v.value",result.statusName);
            if(result.statusName === 'Online')
            {
                component.set("v.omniOnlineFlag",true);
                var a = component.get('c.handleOnOnline');
                $A.enqueueAction(a);
            }
        }).catch(function(error) {
            console.log(error);
        });
        component.set("v.nextCallFlag",true);
        helper.getAgentDetails(component,event);
    },
    handleOmniLogOut : function(component,event,helper)
    {
      //  var omniAPI = component.find("omniToolkit");
        component.set("v.onlineFLag",false);
        component.set("v.omniOnlineFlag",false);
        var authKey = component.get("v.authKey");
       // helper.logOutFromQsuite(component,event,authKey);
    },
    handleEndCall : function(component,event,helper)
    {
        var authKey = component.get("v.authKey");
        component.set("v.endCallFlag",false);
        component.set("v.nextCallFlag",true);
        component.set("v.getCallDataResponse","");
        component.set("v.callFinished", true);
        helper.terminateQsuiteCall(component,event,authKey);
    },
    onWorkAssigned : function(component,event,helper)
    {
        var omniAPI = component.find("omniToolkit");
        omniAPI.getAgentWorks().then(function(result) {
            if(result){
                var works = JSON.parse(result.works);
                if(works)
                {
                    helper.getLead(component,event,works[0].workItemId);
                }
                else{
                    helper.showToast(component,event,'No Lead is present in my work');
                }
            }else{
                helper.showToast(component,event,'No Lead is present in my work');
            }
        }).catch(function(error) {
            console.log(error);
        }); 
    },
    closeModel : function(component, event, helper) {
        component.set("v.error",false);
        component.set("v.ErrorMsg",'');
    },
    handleOnOnline : function(component,event,helper){
        component.set("v.HideSpinner", true);
        var omniAPI = component.find("omniToolkit");
        window.setTimeout(
            $A.getCallback(function() {
                helper.cancelGNNAPI(component,event,helper);
            }), 20000
        );
        helper.loginToQsuite(component,event,omniAPI);
        
       // component.set("v.onlineFLag",true);
    },
    handleStatusMenuSelect : function(component, event, helper) {
        var omniAPI = component.find("omniToolkit");
        var selectedMenuItemValue = event.getParam("value");
        var loggedInFlag = component.get("v.isLoggedInFlag");
        var onlineFLag = component.get("v.onlineFLag");
        var lead = component.get("v.lead");
        var nextCallFlag = component.get("v.nextCallFlag");
        var incomingOnlyFlag = component.get("v.incomingOnlyFlag");
        
        if(selectedMenuItemValue === 'Online')
        {
            window.setTimeout(
                $A.getCallback(function() {
                    helper.cancelGNNAPI(component,event,helper);
                }), 20000
            );
            if(incomingOnlyFlag)
            {
                helper.logOutFromQsuite(component,event,authKey);
                window.setTimeout(
                    $A.getCallback(function() {
                        helper.loginToQsuite(component,event,omniAPI);
                    }), 7000
                );
            }
            else
            {
                helper.loginToQsuite(component,event,omniAPI);
            }
            component.set("v.leadphoneOnlineFlag",true);
            component.set("v.incomingOnlyFlag",false);
            component.set("v.enrollmentOnFlag", false);
            component.set("v.enrollmentCallFlag", false);
            component.set("v.callFinished", true);
        }else if(selectedMenuItemValue === 'Offline'){
       	  	component.set("v.incomingOnlyFlag",false);
            component.set("v.onlineFLag",false);
            component.set("v.omniOnlineFlag",false);
            //component.set("v.enrollmentOnFlag", false);
            component.set("v.enrollmentCallFlag", false);
            var authKey = component.get("v.authKey");
            helper.handleMiniDialerVisibility(component,event,false);
            helper.logOutFromQsuite(component,event,authKey);
            omniAPI.logout().then(function(result) {
                if (result) {
                    console.log("Logout successful");
                } else {
                    console.log("Logout failed");
                }
            }).catch(function(error) {
                console.log(error);
            });
            component.set("v.leadphoneOnlineFlag",false);
            component.set("v.callFinished", true);
        }else if(selectedMenuItemValue ===  'Online – Inbound Only'){
            helper.handleMiniDialerVisibility(component,event,false);
            component.set("v.incomingOnlyFlag",true);
            component.set("v.enrollmentOnFlag", false);
            component.set("v.enrollmentCallFlag", false);
            if(onlineFLag)
            {
                helper.logOutFromQsuite(component,event,authKey);
                window.setTimeout(
                    $A.getCallback(function() {
                        helper.loginToQsuite(component,event,omniAPI);
                    }), 7000
                );
            }
            else
            {
                helper.loginToQsuite(component,event,omniAPI);
            }
            component.set("v.omniOnlineFlag",false);
            component.set("v.leadphoneOnlineFlag",false);
            component.set("v.callFinished", true);
        }else if(selectedMenuItemValue ===  'Online - Outbound Calls Only'){
           
            helper.handleMiniDialerVisibility(component,event,false);
            component.set("v.outboundOnlyFlag",true);
            component.set("v.incomingOnlyFlag",false);
            component.set("v.omniOnlineFlag",false);
            component.set("v.enrollmentOnFlag", false);
            component.set("v.enrollmentCallFlag", false);
            component.set("v.callFinished", true);
            if(onlineFLag)
            {
                helper.logOutFromQsuite(component,event,authKey);
                window.setTimeout(
                    $A.getCallback(function() {
                        helper.loginToQsuite(component,event,omniAPI);
                    }), 7000
                );
            }
            else
            {
                helper.loginToQsuite(component,event,omniAPI);
            }
        }else if(selectedMenuItemValue ===  'Offline - Manual Dialing'){
            component.set("v.onlineFLag",false);
            component.set("v.incomingOnlyFlag",false);
            component.set("v.outboundOnlyFlag",false);
            component.set("v.enrollmentOnFlag", false);
            component.set("v.enrollmentCallFlag", false);
            var authKey = component.get("v.authKey");
            helper.handleMiniDialerVisibility(component,event,true);
            helper.logOutFromQsuite(component,event,authKey);
            helper.loginToQsuiteForManualDialing(component,event,omniAPI);
            component.set("v.leadphoneOnlineFlag",false);
            component.set("v.lead","");
            component.set("v.callFinished", true);
        }else if (selectedMenuItemValue === 'Inbound - Enrollment / Receive Transfer') {
            let inboundOn = false;
            console.log("CHECK in Inbound - Enrollment item");
            component.set("v.onlineFLag", false);
            component.set("v.isLeadFlag",false);
            console.log("CHECK onlineFlag: " + component.get("v.onlineFLag"));
            helper.logOutFromQsuite(component,event,authKey);
            helper.loginToQsuite(component, event, omniAPI, inboundOn, () => {
               component.set("v.onlineFLag", true);
               component.set("v.incomingOnlyFlag", false);
               component.set("v.enrollmentOnFlag", true);
               component.set("v.callFinished", true);
            });
            var statusString = $A.get("$Label.c.Status_Json");
            var statusList = JSON.parse(statusString);
            statusList.forEach(function (status) {
                if (status.MasterLabel === selectedMenuItemValue) {
                    console.log('Omni status',status.Id);
                    omniAPI.setServicePresenceStatus({ statusId: status.Id }).then(function (result) {
                        this.addClassToStatusIcon(component, event, selectedMenuItemValue);
                    }).catch(function (error) {
                        console.log("ERROR in Inbound - Enrollment: ", error);
                    });
                }
            });
            //const authKey = component.get("v.authKey");
            //const isAlreadyAuth = ((authKey !== null)||(authkey !== undefined));
            //if(isAlreadyAuth){
            //    helper.logOutFromQsuite(component,event,authKey);
            //}
            //console.log("CHECK enrollment flag: " + component.get("v.enrollmentOnFlag"));
        }else{
            component.set("v.onlineFLag",false);
            component.set("v.incomingOnlyFlag",false);
            component.set("v.outboundOnlyFlag",false);
            component.set("v.enrollmentOnFlag", false);
            component.set("v.enrollmentCallFlag", false);
            var authKey = component.get("v.authKey");
            helper.handleMiniDialerVisibility(component,event,false);
            helper.logOutFromQsuite(component,event,authKey);
            component.set("v.leadphoneOnlineFlag",false);
            component.set("v.lead","");
        }
        if(!nextCallFlag && lead)
        {
            var disposition = component.get("v.dispositionDupValue");
            var callNotes = component.get("v.callNotes");
            var followupTaskNotes = component.get("v.followUpNotes");
            var defaultDate = component.get("v.activityDate");
            component.set("v.activityDate", "");
            var getCallDataResponse = component.get("v.getCallDataResponse");
            
            var mainResp = {};
            
            mainResp['lead'] =  lead;
            mainResp['isEvent'] =  false;
            var dispositionTask = {};
            dispositionTask['subject'] = disposition;
            dispositionTask['Notes'] = callNotes;
            dispositionTask['isDisposition'] = true;
            mainResp['taskElement'] = dispositionTask;
            mainResp['getCallDataResp'] = getCallDataResponse;
            
            if(defaultDate)
            {
                var followUpEvent = {};
                followUpEvent['subject'] = "Call";
                followUpEvent['Notes'] = followupTaskNotes;
                followUpEvent['isDisposition'] = false;
                followUpEvent['activityDateTime'] = defaultDate;
                mainResp['eventElement'] = followUpEvent;
                mainResp['isEvent'] =  true;
            }
           
            var taskElement = JSON.stringify(mainResp);
            console.log(taskElement);
            helper.createDisposition(component,event,taskElement,lead.Id);
        }
        component.set("v.selectedStatus",selectedMenuItemValue);
    },
    
    handleOnMenuActive : function(component,event, helper)
    {
        var omniAPI = component.find("omniToolkit");
        var selectedClass = event.getSource().get("v.class");
        var selectedStatus =  event.getSource().get("v.value");       
        var statusString = $A.get("$Label.c.Status_Json");
        var statusList = JSON.parse(statusString);
        statusList.forEach(function(status){
            if(status.MasterLabel === selectedStatus && selectedStatus !== 'Offline' && selectedStatus !== 'Online' && selectedStatus !== 'Online - Outbound Calls Only'){
                
                omniAPI.setServicePresenceStatus({statusId: status.Id}).then(function(result) {
                    helper.closeTheOmniChannelMyWork(component,event);
                    helper.addClassToStatusIcon(component,event,selectedClass);
                }).catch(function(error) {
                    console.log(error);
                }); 
                component.set("v.dispositionValue","");
                component.set("v.onlineFLag",false);
                component.set("v.omniOnlineFlag",false);
                component.set("v.outboundOnlyFlag",false);
            }else if(selectedStatus === 'Offline')
            {
                component.set("v.onlineFLag",false);
                component.set("v.dispositionValue","");
                 component.set("v.omniOnlineFlag",false);
                helper.addClassToStatusIcon(component,event,'Offline');
                component.set("v.incomingOnlyFlag",false);
                component.set("v.outboundOnlyFlag",false);
            }
        });

        helper.createLogCallForDefaultDispositionStatuses(component);
        helper.checkIfSelectedStatusDefaultDisposition(component, selectedStatus);
        component.set("v.prevStatus", selectedStatus);
    },
    handleDispostionChange : function(component, event, helper) {
       var selectedValue = event.getSource().get("v.value");
        component.set("v.dispositionDupValue",selectedValue);
        component.set("v.dispositionFlag",false);
        if(selectedValue)
        {
            helper.nextCallButtonValidation(component);
        }
    },
    
    handleCallNotes : function(component,event,helper)
    {
        var callNotes = event.getSource().get("v.value");
        component.set("v.callNotes",callNotes);
    },
    handleFollowupNotes : function(component,event,helper)
    {
        var followUpNotes = event.getSource().get("v.value");
        component.set("v.followUpNotes",followUpNotes);
    },
    onStatusChanged : function(component, event, helper) {
        var statusId = event.getParam('statusId');
        var channels = event.getParam('channels');
        var statusName = event.getParam('statusName');
        var statusApiName = event.getParam('statusApiName');
      //  component.set("v.selectedStatus",statusName);
       if(statusName === 'Online'){
            component.set("v.omniOnlineFlag",true);
            component.set("v.incomingOnlyFlag",false);
        }else if(statusName ===  'Online - Waiting for Inbound Call'){
            component.set("v.incomingOnlyFlag",true);
        }else{
            component.set("v.lead","");
        } 
    }, 
    onActivityDateChange: function(component, event, helper) {
        component.set("v.activityDate",event.getParam("value"));
    },
    handleNextCall : function(component, event, helper)
    {
        helper.omniLogout(component,event);
        var lead = component.get("v.lead");
        var authKey = component.get("v.authKey");
        component.set("v.nextCallFlag",true);
        var leadId = '';
        var isLead = false;
        var mainResp = {};
        if(lead)
        {
            var callNotes = component.find("callNote").get("v.value");
            var followupTaskNotes = component.find("followupTaskNotes").get("v.value");
            var DueDate = component.find("dueDate").get("v.value");
            var defaultDate = component.get("v.activityDate");
            component.set("v.activityDate", "");
            console.log("CHECK activityDate: " + defaultDate);
            var getCallDataResponse = component.get("v.getCallDataResponse");
            var dispositionValue =  component.get("v.dispositionValue");
            
            mainResp['lead'] =  lead;
            leadId = lead.Id;
            mainResp['isEvent'] =  false;
            if(dispositionValue !== '')
            {
                mainResp['dispositionName'] = dispositionValue;
                var dispositionTask = {};
                dispositionTask['subject'] = dispositionValue;
                dispositionTask['Notes'] = callNotes;
                dispositionTask['isDisposition'] = true;
                mainResp['getCallDataResp'] = getCallDataResponse;
                mainResp['taskElement'] = dispositionTask;
            }
            if(defaultDate)
            {
                var followUpEvent = {};
                followUpEvent['subject'] = "Call";
                followUpEvent['Notes'] = followupTaskNotes;
                followUpEvent['isDisposition'] = false;
                followUpEvent['activityDateTime'] = defaultDate;
                mainResp['eventElement'] = followUpEvent;
                mainResp['isEvent'] =  true;
            }
            var respJson = JSON.stringify(mainResp);
            console.log("CHECK respJson: " + respJson);
            window.setTimeout(
                $A.getCallback(function() {
                    helper.cancelGNNAPI(component,event,helper);
                }), 10000
            );
            helper.callerMethod(component,event,respJson,lead);
        }
        else
        {
            console.log('Checking for the inbound call.');
            window.setTimeout(
                $A.getCallback(function() {
                    helper.cancelGNNAPI(component,event,helper);
                }), 10000
            );
            helper.handleInboundCall(component,event,authKey);
        }
        helper.resetDispositionDupValue(component);
    },
    handleInputOnlyNextCall  : function(component,event,helper){
        var authKey = component.get("v.authKey");
        var lead = component.get("v.lead");        
        var leadId = '';
        var isLead = false;
        var mainResp = {};
        component.set("v.nextCallFlag",true);
        if(lead)
        {
            var callNotes = component.get("v.callNotes");
            var followupTaskNotes = component.get("v.followUpNotes");
            var defaultDate = component.get("v.activityDate");
            component.set("v.activityDate", "");
            var getCallDataResponse = component.get("v.getCallDataResponse");
            var dispositionValue =  component.get("v.dispositionValue");
            
            mainResp['lead'] =  lead;
            leadId = lead.Id;
            mainResp['isEvent'] =  false;
            if(dispositionValue !== '')
            {
                mainResp['dispositionName'] = dispositionValue;
                var dispositionTask = {};
                dispositionTask['subject'] = dispositionValue;
                dispositionTask['Notes'] = callNotes;
                dispositionTask['isDisposition'] = true;
                mainResp['getCallDataResp'] = getCallDataResponse;
                mainResp['taskElement'] = dispositionTask;
            }
            if(defaultDate)
            {
                var followUpEvent = {};
                followUpEvent['subject'] = "Call";
                followUpEvent['Notes'] = followupTaskNotes;
                followUpEvent['isDisposition'] = false;
                followUpEvent['activityDateTime'] = defaultDate;
                mainResp['eventElement'] = followUpEvent;
                mainResp['isEvent'] =  true;
            }
            var respJson = JSON.stringify(mainResp);
            helper.callerMethod(component,event,respJson,lead);
        }
        else
        {
            helper.handleInboundOnly(component,event,authKey);
        }
        helper.resetDispositionDupValue(component);
    },
    handleOutboundOnlyNextCall : function(component,event,helper){
        var authKey = component.get("v.authKey");
        var lead = component.get("v.lead");        
        var leadId = '';
        var isLead = false;
        var mainResp = {};
        component.set("v.nextCallFlag",true);
        component.set("v.callFinished", false);
        if(lead)
        {
            var callNotes = component.get("v.callNotes");
            var followupTaskNotes = component.get("v.followUpNotes");
            var defaultDate = component.get("v.activityDate");
            component.set("v.activityDate", "");
            var getCallDataResponse = component.get("v.getCallDataResponse");
            var dispositionValue =  component.get("v.dispositionValue");
            
            mainResp['lead'] =  lead;
            leadId = lead.Id;
            mainResp['isEvent'] =  false;
            if(dispositionValue !== '')
            {
                mainResp['dispositionName'] = dispositionValue;
                var dispositionTask = {};
                dispositionTask['subject'] = dispositionValue;
                dispositionTask['Notes'] = callNotes;
                dispositionTask['isDisposition'] = true;
                mainResp['getCallDataResp'] = getCallDataResponse;
                mainResp['taskElement'] = dispositionTask;
            }
            if(defaultDate)
            {
                var followUpEvent = {};
                followUpEvent['subject'] = "Call";
                followUpEvent['Notes'] = followupTaskNotes;
                followUpEvent['isDisposition'] = false;
                followUpEvent['activityDateTime'] = defaultDate;
                mainResp['eventElement'] = followUpEvent;
                mainResp['isEvent'] =  true;
            }
            var respJson = JSON.stringify(mainResp);
            helper.callerMethod(component,event,respJson,lead);
        }
        helper.resetDispositionDupValue(component);
    },
    callNextCall : function(component,event,helper){
        var authKey = component.get("v.authKey");
		helper.callNextCallAPI(component,event,authKey);
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
    handleRedialCallAPI : function(component,event,helper)
    {
        var authKey = component.get("v.authKey");
        var endCallFlag = component.get("v.endCallFlag");
        var lead = component.get("v.lead");
        var callerId = component.get("v.callerId")
        var phoneNumber = '';
        if(lead)
        {
            if(lead.Phone !== '' || lead.Phone != undefined || lead.Phone != null)
            {
                phoneNumber = lead.Phone;
            }else{
                phoneNumber = lead.mobilePhone;
            }   
        }else
        {
            phoneNumber = callerId;
        }
        console.log('phoneNumber::'+phoneNumber);
        if(!endCallFlag && lead.Inbound_Outbound__c === 'Outbound')
        {
            helper.redialCall(component,event,authKey);
        }else{
            helper.loadCallOnQsuite(component,event,authKey,phoneNumber);
        }
    },
    handleMergeCall : function(component,event,helper){
        var authKey = component.get("v.authKey");
        helper.handlelMergeCall(component,event,authKey,'off');
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
    handleTransferFlipAPI : function(component,event,helper){
        var authKey = component.get("v.authKey");
        helper.transferFlipCallAPI(component,event,authKey);
    },
    closeTransferCallModel : function(component,event,helper)
    {
        component.set("v.openTransferCallModal",false);
        component.set("v.callAgentButtonDisableFlag",true);
        component.find("agentLookup").set("v.value","");
    },
    handleTransferCall :function(component,event,helper)
    {
        component.set("v.openTransferCallModal",true);
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
    handleCancelTransferAPI : function(component,event,helper)
    {
        var authKey = component.get("v.authKey");
        helper.cancelTransferCallAPI(component,event,authKey);
    },
    handleEnrollmentCall: function (component, event, helper) {
        component.set("v.enrollmentCallFlag", true);
        component.set("v.callFinished", false);
        helper.enrollmentCall(component, event, helper);
    },
    backToQueue: function (component, event, helper) {
        component.set("v.enrollmentCallFlag", false);
        component.set("v.callFinished", true);
        var a = component.get('c.handleEndCall');
        $A.enqueueAction(a);
    },
    saveLead : function(component,event,helper)
    {
        component.set("v.isLeadFlag",true);
        var callerId = component.get("v.callerId");
        var firstName = component.get("v.leadFirstName");
        var lastName = component.get("v.leadLastName");
        var element = {};
        element['FirstName'] = firstName;
        element['LastName'] = lastName;
        element['Phone'] = callerId;
        var jsonString = JSON.stringify(element);
        helper.handleCreateLead(component,event,jsonString);
        component.set("v.leadInputModalBox",false);
    },
    closeLeadInputModel : function(component,event,helper){
        component.set("v.isLeadFlag",false);
        component.set("v.leadInputModalBox",false);
        component.set("v.leadFirstName","");
        component.set("v.leadLastName","");
    },
    handleSelectMatchingLead : function(component,event,helper){
        const selectedLead = event.getParam("lead");
        const inboundOnlyCallPhone = component.get("v.inboundOnlyCallPhone");
        const inboundLeadResponse = component.get("v.inboundLeadResponse");
        
        const inboundOnlyModal = component.get("v.openSelectLeadModal");
        const inboundLeadModal = component.get("v.openSelectInboundLeadModal");

        component.set("v.openSelectLeadModal", false);
        component.set("v.openSelectInboundLeadModal", false);
        component.set("v.openSelectNextInboundLeadModal", false);

        const isLeadSelected = (selectedLead !== null)&&(selectedLead !== undefined);
        if(isLeadSelected){
            helper.resetDispositionValue(component);
            helper.resetDispositionDupValue(component);
            helper.openSelectedLeadInfoInDialer(component, selectedLead);
        } else if(inboundOnlyModal){
            component.set("v.inboundOnlyCallPhone", "");
            helper.openCreateInboundOnlyLeadModalWindow(component, inboundOnlyCallPhone);
        } else if(inboundLeadModal){
            component.set("v.inboundLeadResponse", null);
            helper.openCreateInboundLeadModalWindow(component, inboundLeadResponse);
        } else {
            component.set("v.inboundLeadResponse", null);
            helper.openCreateNextInboundLeadModalWindow(component, inboundLeadResponse);
        }
    }
})