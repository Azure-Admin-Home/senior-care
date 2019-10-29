@isTest
private class LeadSoftphoneCallToLead_ctl_Test {
    @isTest
    public static void testloginToQsuiteAPI()
    {
        test.startTest();
        test.setMock(HttpCalloutMock.class, new qsuiteUtilities_Mock());
        LeadSoftphoneCallToLead_ctl.GetQueuedCallsResponseWrapper response = LeadSoftphoneCallToLead_ctl.getQueuedCalls('authKey');
        test.stopTest();
    }
}