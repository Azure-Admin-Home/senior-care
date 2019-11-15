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
                    const leads = proceedResponse.leads;
                    component.set("v.leads", leads);
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

    handleLeadSelect : function(component, event, helper) {
        const lead = event.getSource().get("v.value");
        const leadId = lead.Id;
        //const phoneNumber = component.get("v.phone");
        //const selectedLead = helper.generateSelectedLead(leadId, phoneNumber);
        const workspaceAPI = component.find("workspace");
        helper.openSelectedLeadTab(leadId, workspaceAPI);
        const selectLeadEvent = component.getEvent("selectMatchingLead");
        selectLeadEvent.setParams({"leadId": leadId});
        selectLeadEvent.fire();
    },

    handleCloseModal : function(component, event, helper){
        const selectLeadEvent = component.getEvent("selectMatchingLead");
        selectLeadEvent.fire();
    }
})