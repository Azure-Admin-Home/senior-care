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

	public static User createTestUser(){
		Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        User testUser = new User(ProfileId = profileId,
                                 LastName = 'last',
                                 Phone = '7896541236',
                                 Email = 'puser000@amamama.com',
                                 Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                                 CompanyName = 'TEST',
                                 Title = 'title',
                                 Alias = 'alias',
                                 TimeZoneSidKey = 'America/Los_Angeles',
                                 EmailEncodingKey = 'UTF-8',
                                 LanguageLocaleKey = 'en_US',
                                 LocaleSidKey = 'en_US',
                                 Server_URL__c = 'https://test-service.com');
		return testUser;
	}

	public static List<String> getPicklistValues(String objectApiName,String fieldApiName){
            Map<String,Schema.SobjectType> schemaMap = Schema.getGlobalDescribe();
            
            Map<String,Schema.SObjectField> fieldMap = schemaMap.get(objectApiName).getDescribe().fields.getMap();
            
            List<schema.PicklistEntry> picklistEnties = fieldMap.get(fieldApiName).getDescribe().getPickListValues();
            
            List<String> picklistValueList = new List<String>();
            
            for(Schema.PicklistEntry ple : picklistEnties){
                String value = ple.getValue();
				picklistValueList.add(value);
            }

            return picklistValueList;
    }
}