({
    init : function(component, event, helper) {
        const action = component.get("c.getAgentDetails");
        
        const responseHandler = helper.produceResponseHandlePromise(action);
        const errorHandler = helper.onErrorResponse;
        const successHandler = (returnedAgents) => {
            component.set("v.agentsList", returnedAgents); 
        };
        
        responseHandler
            .then(successHandler)
            .catch(errorHandler);
    },
    closeTransferCallModel : function(component, event, helper){
        const closeTransferModal = component.getEvent("closeTransferModal");
        closeTransferModal.fire();
    },
    handleSelectAgnetChange : function(component, event, helper){
        const agentNumber = component.find("agentSelect").get("v.value");
        const isAgentNotSelected = (agentNumber === "");
        component.set("v.callAgentDisable", isAgentNotSelected);
        component.set("v.agentNumber", agentNumber);
    },
    handleSpecifyAgentNumberManually : function(component, event, helper){
        component.set("v.openManualInputModal", true);
    },
    handleCloseManualInputModal : function(component, event, helper){
        const phoneNumber = event.getParam("phoneNumber");
        if(phoneNumber){
            component.find("agentSelect").set("v.value", "");
            component.set("v.agentNumber", phoneNumber);
            component.set("v.callAgentDisable", false);
        }
        component.set("v.openManualInputModal", false);
    },
    handleCallAgent : function(component, event, helper){
        const authKey = component.get("v.authKey");
        const agentNumber = component.get("v.agentNumber");
        const specifiedNumber = helper.formatAgentNumber(agentNumber);
        const callerId = component.get("v.callerId");
        const lead = component.get("v.lead");
        // const phoneNumber = helper.selectLeadNumber(callerId, lead);
        const action = component.get("c.transferCallApi");
        action.setParams({"authKey" : authKey,
                          "specifiedNumber" : specifiedNumber});
        
        const responseHandler = helper.produceResponseHandlePromise(action);
        const errorHandler = helper.onErrorResponse;
        const successHandler = (isTransfered) => {
                        if(isTransfered){
                            const closeTransferModal = component.getEvent("closeTransferModal");
                            closeTransferModal.fire();      
                        } else {
                            console.log('Transfer call is failed.');
                        }
        };

        responseHandler
            .then(successHandler)
            .catch(errorHandler);
    }
})
