@isTest
private class LeadSoftphoneTransferCall_ctl_Test {
    @IsTest
    static void LeadSoftphoneTransferCall_ctl_getAgentDetails_Test(){
        
        Test.startTest();
            LeadSoftphoneTransferCall_ctl.getAgentDetails();
        Test.stopTest();
    }

    @IsTest
    static void LeadSoftphoneTransferCall_ctl_transferCallApi_Test(){
        
        String authKey = 'aaaaaaa0-bbb1-ccc2-ddd3-eeeeeeeeeee4';
        String specifiedNumber = '00000000';
        String phoneNumber = '11111111';

        Test.setMock(HttpCalloutMock.class, new qsuiteUtilities_Mock());
        Test.startTest();
            LeadSoftphoneTransferCall_ctl.transferCallApi(authKey, specifiedNumber, phoneNumber);
        Test.stopTest();
    }
}
