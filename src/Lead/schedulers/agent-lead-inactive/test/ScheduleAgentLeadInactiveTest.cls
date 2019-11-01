@isTest
private class ScheduleAgentLeadInactiveTest {
    @IsTest
    static void ScheduleAgentLeadInactive_Test(){
        
        String scheduleName = 'ScheduleAgentLeadInactive';
        String cronExp = '0 0 0 ? * * *';
        Test.startTest();
          System.schedule(scheduleName, cronExp, new ScheduleAgentLeadInactive());      
        Test.stopTest();
    }
}
