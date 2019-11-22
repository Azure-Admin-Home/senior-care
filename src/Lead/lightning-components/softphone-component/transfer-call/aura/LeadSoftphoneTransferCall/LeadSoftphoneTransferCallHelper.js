({
    produceResponseHandlePromise : function(action){
        return new Promise(
                $A.getCallback((resolve, reject) => {
                    action.setCallback(this, result => {
                        if (result.getState() === 'SUCCESS') {
                            const responseBody = result.getReturnValue();
                            return resolve(responseBody);
                        }
                        if (result.getState() === 'ERROR') {
                          console.log('ERROR', result.getError());
                          return reject(result.getError());
                        }
                    });
                    $A.enqueueAction(action);
                })
        );
    },
    onErrorResponse : function(errors){
        if(errors){
            console.log("Error message: " + errors[0].message);
        } else {
            console.log("Unknown error");
        }
    },
    formatAgentNumber : function(agentNumber){
        return agentNumber.replace(/[^0-9\.]+/g, '');
    },
    selectLeadNumber : function(callerId, lead){
        if(callerId == undefined){
            return this.getPhoneFromLead(lead);
        } else {
            return callerId;
        }
    },
    getPhoneFromLead : function(lead){
        if(lead != undefined){
            if(lead.Phone){
                return lead.Phone;
            } else if(lead.MobilePhone){
                return lead.MobilePhone;
            } else {
                console.log("Transfer call exception occurs! No inbound and outbound lead specified");
            }
        } else {
            console.log("Transfer call exception occurs! No inbound and outbound lead specified");
        }
    }
})
