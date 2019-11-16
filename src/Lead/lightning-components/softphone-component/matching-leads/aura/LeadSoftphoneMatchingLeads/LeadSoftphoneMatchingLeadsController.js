({
    init : function(component, event, helper) {
        const phoneNumber = component.get("v.phone");
        const action = component.get("c.getMatchingLeads");
        action.setParams({"phoneNumber": phoneNumber});
        action.setCallback(this, response => {
            const state = response.getState();
            if(state === "SUCCESS"){
                const proceedResponse = helper.proceedInitSuccessResponse(response);
                if(proceedResponse.success){
                    const leadOptions = proceedResponse.leadOptions;
                    component.set("v.leadOptions", leadOptions);
                } else {
                    const error = "Unexpected error occurs. Please, contact developer support";
                    component.set("v.errorResponse", error); 
                }
            } else {
                const errorResponse = helper.proceedInitErrorResponse(response);
                component.set("v.errorResponse", errorResponse);
            }
        });
        $A.enqueueAction(action);
    },

    handleLeadChange : function(component, event, helper){
        const leadId = event.getParam("value");
        component.set("v.selectedLeadId", leadId);
        const workspaceAPI = component.find("workspace");
        helper.openSelectedLeadTab(leadId, workspaceAPI);
    },

    handleLeadSelect : function(component, event, helper) {
        const leadId = component.get("v.selectedLeadId");
        const selectLeadEvent = component.getEvent("selectMatchingLead");
        selectLeadEvent.setParams({"leadId": leadId});
        selectLeadEvent.fire();
    },

    handleCloseModal : function(component, event, helper){
        const selectLeadEvent = component.getEvent("selectMatchingLead");
        selectLeadEvent.fire();
    }
})