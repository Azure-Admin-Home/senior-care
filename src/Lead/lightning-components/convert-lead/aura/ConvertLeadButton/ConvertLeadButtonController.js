({
    doInit : function(component, event, helper) {
        const action = component.get("c.convertLead");
        const leadId = component.get("v.recordId");
        action.setParams({ "leadId" : leadId });
        var initHandler = function(response){helper.initHandler(response, component)};
        action.setCallback(this, initHandler);
        $A.enqueueAction(action);
    }
})