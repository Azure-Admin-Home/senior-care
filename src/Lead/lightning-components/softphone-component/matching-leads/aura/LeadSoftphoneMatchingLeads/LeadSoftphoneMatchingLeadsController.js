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
                    const leadResponse = proceedResponse.leadResponse;
                    const leadOptions = leadResponse.leadOptions;
                    const leadsMap = leadResponse.leadsMap;
                    component.set("v.leadOptions", leadOptions);
                    component.set("v.leadsMap", leadsMap);
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
        const leadsMap = component.get("v.leadsMap");
        const lead = leadsMap[leadId];
        console.log("lead: " + JSON.stringify(lead));
        component.set("v.selectedLead", lead);
        const workspaceAPI = component.find("workspace");
        helper.openSelectedLeadTab(leadId, workspaceAPI);
    },

    handleLeadSelect : function(component, event, helper) {
        const lead = component.get("v.selectedLead");
        const selectLeadEvent = component.getEvent("selectMatchingLead");
        selectLeadEvent.setParams({"lead": lead});
        selectLeadEvent.fire();
    },

    handleCloseModal : function(component, event, helper){
        const selectLeadEvent = component.getEvent("selectMatchingLead");
        selectLeadEvent.fire();
    }
})