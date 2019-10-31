@isTest
public class TestFactory {

	public static Lead newLead(){
		Lead record = new Lead(LastName = 'Test', Status = 'New');
		insert record;
		return record;
	}

	public static Task newTaskWho(SObject whoRecord){
		Task record = new Task(WhoId = (String)whoRecord.get('Id'), TaskSubtype = 'Call');
		insert record;
		return record;
	}

	public static Lead newLead(String leadName){
		Lead record = new Lead(LastName = leadName, Status = 'New');
		return record;
	}

}