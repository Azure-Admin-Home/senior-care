({
    proceedInitSuccessResponse : function(response) {
        const leads = response.getReturnValue();
        
        if(leads.length > 0){
            const leadOptions = this.convertLeadsToOptions(leads);
            return {"success": true,
                    "leadOptions": leadOptions};
        } else {
            return {"success": false};
        }
    },

    convertLeadsToOptions : function(leads){
        const leadOptions = [];
        leads.forEach(lead => {
            const leadOption = {"label": lead.Name,
                                "value": lead.Id};
            leadOptions.push(leadOption);
        });
        return leadOptions;
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