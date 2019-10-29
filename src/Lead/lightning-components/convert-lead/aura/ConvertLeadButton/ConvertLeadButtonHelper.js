({
    getErrorMessage : function(errors){
        console.log("Error: ", errors);
        if(errors && Array.isArray(errors) && errors.length > 0){
            const isMessageDefined = (errors[0].message !== undefined);
            const isErrorPageDefined = (errors[0].pageErrors[0].message !== undefined);
            if(isMessageDefined){
                return errors[0].message;
            } else if(isErrorPageDefined){
                return errors[0].pageErrors[0].message;
            } else {
                return "Error object contains exception";
            }
        }
    },

    showToast : function(toastParams){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams(toastParams);
        toastEvent.fire();
    },

    showSuccessToast : function(successMessage){
        var toastParams = {	type: "success",
                            title: "Success",
                            message: successMessage };
        this.showToast(toastParams);
    },

    showErrorToast : function(errorMessage){
        var toastParams = {	type: "error",
                            title: "Error",
                            message: errorMessage };
        this.showToast(toastParams);
    },

    openTabWithSubtab : function(accountId, opportunityId, workspaceAPI){
        
        workspaceAPI.openTab({
            url: '/lightning/r/Opportunity/' + opportunityId + '/view',
            focus: true
        })
        .then(function(response) {
            workspaceAPI.openSubtab({
                parentTabId: response,
                url: '/lightning/r/Account/' + accountId + '/view',
                focus: false
            });
        })
        .catch(function(error) {
            const errorMessage = this.getErrorMessage(error);
            console.log("Initialisation failed with state: " + state);
            console.log("Error message: " + errorMessage);
            this.showErrorToast(errorMessage);
        });
    },

    proceedWithTabs : function(component, generatedRecords) {
        const workspaceAPI = component.find("workspace");
        
        const accountId = generatedRecords.accountId;
        const opportunityId = generatedRecords.opportunityId;
        
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .then(this.openTabWithSubtab(accountId, opportunityId, workspaceAPI))
        .catch(function(error) {
            const errorMessage = this.getErrorMessage(error);
            console.log("Initialisation failed with state: " + state);
            console.log("Error message: " + errorMessage);
            this.showErrorToast(errorMessage);
        });
    },  
    
    initHandler : function(response, component) {
        const state = response.getState();
        if(state === "SUCCESS"){
            this.showSuccessToast("Lead was converted successfull");
            const generatedRecords = response.getReturnValue();
            this.proceedWithTabs(component, generatedRecords);
        } else {
            const errors = response.getError();
            console.log("ERROR: ", errors);
            const errorMessage = this.getErrorMessage(errors);
            console.log("Initialisation failed with state: " + state);
            console.log("Error message: " + errorMessage);
            this.showErrorToast(errorMessage);
        }
        $A.get("e.force:closeQuickAction").fire();
    }
})