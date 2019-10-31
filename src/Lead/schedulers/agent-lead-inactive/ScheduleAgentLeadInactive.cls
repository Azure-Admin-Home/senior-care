public class ScheduleAgentLeadInactive implements Schedulable{
    public void execute(SchedulableContext sc) {
    	Database.executeBatch(new AgentLeadInaciveBatch());
    }
}
