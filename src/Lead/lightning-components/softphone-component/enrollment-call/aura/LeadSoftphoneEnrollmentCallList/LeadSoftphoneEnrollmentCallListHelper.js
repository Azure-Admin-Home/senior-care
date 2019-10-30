({
    getCalls: function (component) {
        var authKey = component.get("v.authKey");
        var queue = component.get("v.queue");
        var action = component.get("c.getQueuedCalls");
        action.setParams({
            "authKey": authKey,
            "queue": queue
        });
        action.setCallback(this, function (response) {
            var callsList = [];
            var state = response.getState();
            console.log('state', state);
            console.log('returnValue', response.getReturnValue());
            if (state === "SUCCESS") {
                if (response.getReturnValue()) {
                    var response = JSON.parse(response.getReturnValue().respJson);
                    response.calls.forEach( function(item,idx) {
                        item.call.forEach(call => {
                            var found = call.caller_id[0].match(/\<(.*)\>/);
                            let phone = found[1];
                            let uuid = call.uuid[0];
                            console.log('phone', phone);
                            console.log('uuid', uuid);
                            callsList.push({
                                idx: idx+1,
                                phone: phone,
                                uuid: uuid
                            });
                        });
                    });
                    console.log('Queue list is sucessful.');
                } else {
                    console.log('Queue list is failed.');
                }
            }
            console.log(callsList);
            component.set("v.calls", callsList);
        });
        $A.enqueueAction(action);
    }
})