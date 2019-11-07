({
    init: function (component, event, helper) {
        helper.getCalls(component);
        var intId = setInterval(() => {
            helper.getCalls(component);
        }, 5000);
        component.set("v.intId", intId);
    },

    updateCallsQueue: function (component, event, helper) {
        helper.getCalls(component);
    },

    handleCallToLead: function (component, event, helper) {
        clearInterval(component.get("v.intId"));
        var uuid = event.getSource().get("v.value");
        var callToLeadEvent = component.getEvent("callToLead");
        console.log('uuid', uuid);
        callToLeadEvent.setParams({ "uuid": uuid });
        callToLeadEvent.fire();
    }
})