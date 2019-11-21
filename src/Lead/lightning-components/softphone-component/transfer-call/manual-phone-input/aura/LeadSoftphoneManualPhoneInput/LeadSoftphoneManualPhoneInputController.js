({
    handlePhoneNumberChanged : function(component, event, helper){
        const phoneNumber = event.getParam("value");
        const isPhoneNumberBlank = helper.checkIfPhoneIsBlank(phoneNumber);
        component.set("v.acceptDisabled", isPhoneNumberBlank);
    },
    handleAcceptManualPhone : function(component, event, helper){
        //debugger;
        const phoneFiled = component.find("phoneNumber");
        const phoneNumber = phoneFiled.get("v.value");
        const isPhoneNumberNotVaild = helper.checkIfPhoneNumberNotValid(phoneNumber);
        if(isPhoneNumberNotVaild){
            component.set("v.acceptDisabled", isPhoneNumberNotVaild);
            phoneFiled.setCustomValidity("Phone number must contains only numbers");
            phoneFiled.reportValidity();
        } else {
            const phoneSpecifiedEvent = component.getEvent("manualSpecifyPhone");
            phoneSpecifiedEvent.setParams({"phoneNumber": phoneNumber});
            phoneSpecifiedEvent.fire();
        }
    },
    closeManualInputModal : function(component, event, helper){
        const phoneNotSpecifiedEvent = component.getEvent("manualSpecifyPhone");
        phoneNotSpecifiedEvent.fire();
    }
})
