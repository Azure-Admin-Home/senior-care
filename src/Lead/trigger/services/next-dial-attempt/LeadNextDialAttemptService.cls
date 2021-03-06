public class LeadNextDialAttemptService
{

public static void execute()
{
	Organization org = [SELECT Id, TimeZoneSidKey FROM Organization];
	Timezone tz = Timezone.getTimeZone(org.TimeZoneSidKey);

	for (Lead lead :(List<Lead>)Trigger.new)
	{
		if (lead.Daily_Call_Rest_Time__c == null || lead.Last_Dial_Time__c == null || lead.First_Dial_Time__c == null)
		{
			continue;
		}

		DateTime nextDialAttempt;
		DateTime firstDialTime = DateTime.newInstanceGMT(System.today(), lead.First_Dial_Time__c).addMinutes(5);
		DateTime lastDialTime = DateTime.newInstanceGMT(System.today(), lead.Last_Dial_Time__c);
		System.debug(firstDialTime);
		System.debug(tz.getOffset(firstDialTime));
		System.debug(tz.getOffset(firstDialTime)/60000);
		firstDialTime = firstDialTime.addMinutes(-tz.getOffset(firstDialTime)/60000);
		lastDialTime = lastDialTime.addMinutes(-tz.getOffset(lastDialTime)/60000);

		System.debug('firstDialTime::'+firstDialTime);
		System.debug('lastDialTime::'+lastDialTime);
		System.debug('Now::'+System.now());
		if (lead.Last_Dial_Attempt__c != null)
		{
			if (lead.Dials_Remaining__c > 0)
			{
				DateTime nextTime = lead.Last_Dial_Attempt__c.addHours(Integer.valueOf(lead.Daily_Call_Rest_Time__c));
				if (nextTime < System.now()) nextTime = System.now().addMinutes(5);
				if (nextTime < firstDialTime) nextTime = firstDialTime;
				if (nextTime > lastDialTime) nextTime = firstDialTime.addDays(1);
				nextDialAttempt = nextTime;
			} else
			{
				DateTime nextTime = firstDialTime.addDays(1);
				nextDialAttempt = nextTime;
			}
		} else
		{
			DateTime nextTime = System.now().addMinutes(5);
			if (nextTime < firstDialTime) nextTime = firstDialTime;
			if (nextTime > lastDialTime) nextTime = firstDialTime.addDays(1);
			nextDialAttempt = nextTime;
		}

		if (System.now() < nextDialAttempt.addMinutes(-20) )
		{
			Group hopper = GroupUtils.getGroup('Hopper');
			if (lead.OwnerId == hopper.Id) lead.OwnerId = GroupUtils.getGroup('Unassigned').Id;
		}
		System.debug('nextDialAttempt::'+nextDialAttempt);
		lead.Next_Dial_Attempt__c = nextDialAttempt;
	}
}

}