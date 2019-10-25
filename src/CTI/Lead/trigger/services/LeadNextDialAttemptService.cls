public class LeadNextDialAttemptService
{

public static void execute()
{

	for (Lead lead :(List<Lead>)Trigger.new)
	{
		if (lead.Daily_Call_Rest_Time__c == null || lead.Last_Dial_Time__c == null || lead.First_Dial_Time__c == null)
		{
			continue;
		}

		DateTime nextDialAttempt;
		DateTime lastDialAttempt = getLastDialAttempt(lead);

		if (lead.Dials_Remaining__c > 0)
		{
			if (lastDialAttempt.date() < System.today())
			{
				nextDialAttempt = DateTime.newInstance(System.today(), lead.First_Dial_Time__c).addMinutes(5);
			}
			else
			{
				DateTime startDate = DateTime.newInstance(System.today(), lead.First_Dial_Time__c).addMinutes(5);
				DateTime nextTime = lastDialAttempt.addHours(Integer.valueOf(lead.Daily_Call_Rest_Time__c));
				nextDialAttempt = nextTime > startDate ? nextTime : startDate;
			}
			if (nextDialAttempt < System.now()) nextDialAttempt = System.now().addMinutes(5);
		}
		if (isNotWorkingHours(lead, nextDialAttempt) || lead.Dials_Remaining__c <= 0)
		{
			nextDialAttempt = moveNextDay(lead);
			Group hopper = GroupUtils.getGroup('Hopper');
			if (lead.OwnerId == hopper.Id) lead.OwnerId = GroupUtils.getGroup('Unassigned').Id;
		}
		lead.Next_Dial_Attempt__c = nextDialAttempt;
	}
}

private static Boolean isNotWorkingHours(Lead lead, DateTime nextDialAttempt)
{
	if (nextDialAttempt == null ||
	    nextDialAttempt < System.now() ||
	    nextDialAttempt > DateTime.newInstance(nextDialAttempt.date(), lead.Last_Dial_Time__c))
	{
		return true;
	}
	else
	{
		return false;
	}
}

private static DateTime moveNextDay(Lead lead)
{
	return DateTime.newInstance(System.today().addDays(1), lead.First_Dial_Time__c);
}

private static DateTime getLastDialAttempt(Lead lead)
{
	if (lead.Last_Dial_Attempt__c != null) return lead.Last_Dial_Attempt__c;
	DateTime result = DateTime.newInstance(System.today(), lead.First_Dial_Time__c);
	if (result > System.now()) result = DateTime.newInstance(System.today().addDays(-1), lead.Last_Dial_Time__c);
	return result;
}

}