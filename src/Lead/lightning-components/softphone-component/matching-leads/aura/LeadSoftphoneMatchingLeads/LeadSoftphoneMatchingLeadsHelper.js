({
    proceedInitSuccessResponse : function(response) {
        const leads = response.getReturnValue();
        if(leads.length > 0){
            return {"success": true,
                    "leads": leads};
        } else {
            return {"success": false};
        }
    },

    proceedInitErrorResponse : function(response) {
        const errors = response.getError();
        if(errors && Array.isArray(errors) && errors.length > 0)
        return errors[0].message;
    },

    openSelectedLeadTab : function(leadId, workspaceAPI){
        workspaceAPI.getFocusedTabInfo()
        .then(response => {
            const focusedTabId = response.tabId;
            workspaceAPI.openTab({recordId: leadId, 
                                  focus: true}
            )
            .then(response => {
                    workspaceAPI.closeTab({tabId: focusedTabId})
                    .catch(error => console.log(error));
            })
            .catch( error => console.log(error));
        })
        .catch( error => console.log(error));
    },

    generateSelectedLead : function(leadId, phoneNumber){
        const leadObj = {"Id":leadId, 
                         "phoneNumber":phoneNumber};
        return JSON.stringify(leadObj);
    }
})