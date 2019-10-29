({
    afterRender: function(component, helper)
    {
        this.superAfterRender();
        var currentStatus = component.get("v.selectedStatus");
        var utilityBarAPI = component.find("utilitybar");
        var eventHandler = function(response){
            helper.handleUtilityClick(component, response);
        };
        if(currentStatus === 'Online'){
            
            utilityBarAPI.onUtilityClick({ 
                eventHandler: eventHandler 
            }).then(function(result){
                console.log(result);
            }).catch(function(error){
                console.log(error);
            });
            
            // now manually invoke action for the first time
            helper.getCurrentWorkId(component); 
        } 
    }   
})