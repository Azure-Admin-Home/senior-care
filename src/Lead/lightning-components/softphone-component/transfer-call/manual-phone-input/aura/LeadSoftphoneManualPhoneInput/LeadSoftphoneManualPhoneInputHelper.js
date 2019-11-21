({
    checkIfPhoneNumberNotValid : function(phoneNumber) {
        const alphabetContainsRegexp = /[a-z]/i;
        const anyCharacter = phoneNumber.search(alphabetContainsRegexp);
        return anyCharacter !== -1;
    },

    checkIfPhoneIsBlank : function(phoneNumber){
        return phoneNumber === "";
    },

    resetCustomValidityMessage : function(phoneFiled){
        phoneFiled.setCustomValidity();
        // phoneFiled.reportValidity();
    }
})
