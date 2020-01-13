@isTest
private class LeadSoftphoneMatchingLeads_ctl_Test {
    @IsTest
    private static void methodName(){
        
        Test.startTest();
            List<Lead> response = LeadSoftphoneMatchingLeads_ctl.getMatchingLeads('111111');
        Test.stopTest();
    }
}