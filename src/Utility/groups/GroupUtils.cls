public class GroupUtils {

	static Map<String,Group> groupMap = new Map<String,Group>();

	public static Group getGroup(String groupName)
	{
		if (!groupMap.containsKey(groupName))
		{
			List<Group> result = [SELECT Id FROM Group WHERE Type = 'Queue' AND NAME =:groupName];
			if (result.size() > 0) groupMap.put( groupName, result[0] );
			else groupMap.put( groupName, null );
		}
		return groupMap.get(groupName);
	}

	public static Id getGroupId(String groupName){
		Group retrievedGroup = getGroup(groupName);
		return retrievedGroup.Id;
	}

}