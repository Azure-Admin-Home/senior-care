/*************************************************************************************
Class Name     :  SkillsBasedRoutingTest
Purpose        :  Test class for SkillsBasedRouting
History:                                                            
-------                                                            
VERSION  AUTHOR         		DATE            	DETAIL
1.       Jason Fung		  		2019/09/05      	Original Version
***************************************************************************************/
@isTest
private class SkillsBasedRoutingTest {

    /******************************************************
    * Method Name   :  createTestData
    * Description   :  Create lead, service resource and service resource skill for testing
    * Return Type   :  void
    * Parameters    :  n/a
    *******************************************************/
    @testSetup 
    static void createTestData() {        
        
        // Insert Leads for testing
        list<Lead> leadsToInsert = new list<Lead>();
                
        // Lead does not have a value for the state, lead source and lead type field
        Lead testLead1 = new Lead(LastName = 'TestJason1', Status = 'New');
        leadsToInsert.add(testLead1);
        
        // Lead has a value for the state field and is in one of the State that our company provide service to
        Lead testLead2 = new Lead(LastName = 'TestJason2', Status = 'New', State = 'AZ');
        leadsToInsert.add(testLead2);
        
        // Lead has a value for the state field but is not in one of the State that our company provide service to
        Lead testLead3 = new Lead(LastName = 'TestJason3', Status = 'New', State = 'TX');
        leadsToInsert.add(testLead3);
        
        // Lead has a value for the state field and is in one of the State that our company provide service to.
        // Lead also has a value for the lead source and lead type field and it is a match with one of our rule skills
        Lead testLead4 = new Lead(LastName = 'TestJason4', Status = 'New', State = 'Arizona', LeadSource = 'CEGE', Lead_Type__c = '1');
        leadsToInsert.add(testLead4);
        
        // Lead has a value for the state field and is in one of the State that our company provide service to
        // Lead also has a value for the lead source and lead type field but it is not a match with one of our rule skills
        Lead testLead5 = new Lead(LastName = 'TestJason2', Status = 'New', State = 'Arizona', LeadSource = 'testJason', Lead_Type__c = 'testJason');
        leadsToInsert.add(testLead5);
        
        // Lead has a value for the state field but is not in one of the State that our company provide service to.
        // Lead also has a value for the lead source and lead type field and it is a match with one of our rule skills
        Lead testLead6 = new Lead(LastName = 'TestJason5', Status = 'New', State = 'Wyoming', LeadSource = 'CEGE', Lead_Type__c = '1');
        leadsToInsert.add(testLead6);        
             
        insert leadsToInsert;
        
        // Insert Service Resource for testing
        ServiceResource sr = new ServiceResource(RelatedRecordId = UserInfo.getUserId(), Name = 'Test User', IsActive = true);
        insert sr;
        
        // Get the ruleSkillId and stateSkillId
        Id theRuleSkillId; 
        Id theStateSkillId;        
        for (Skill skill : [select Id, Description from Skill]) {
            if (skill.description == 'Source: DEVTEST; Type: 11') {
                theRuleSkillId = skill.Id;
            }
            if (skill.description == 'AZ') {
                theStateSkillId = skill.Id;
            }
        }   
        
        // Insert Service Resource Skill for testing
        list<ServiceResourceSkill> srsToInsert = new list<ServiceResourceSkill>();
        ServiceResourceSkill srs1 = new ServiceResourceSkill(SkillId = theRuleSkillId, ServiceResourceId = sr.Id, Priority__c = 1, EffectiveStartDate = date.today());
        srsToInsert.add(srs1);
        ServiceResourceSkill srs2 = new ServiceResourceSkill(SkillId = theStateSkillId, ServiceResourceId = sr.Id, EffectiveStartDate = date.today());
		srsToInsert.add(srs2);
		
		insert srsToInsert;        
    }
    
    /******************************************************
    * Method Name   :  testRouteUsingSkills
    * Description   :  Test the routeUsingSkills method. 
    * Return Type   :  void
    * Parameters    :  n/a
    *******************************************************/
    @isTest
    static void testRouteUsingSkills() {   
        Group hopperQueue = [select Id from Group where Name = 'Hopper' and Type = 'Queue' limit 1];        
        list<Lead> testLeads = [select Id, OwnerId from Lead where LastName LIKE 'TestJason%'];                
        for (Lead l : testLeads) {
            l.OwnerId = hopperQueue.Id;
        }               
        // The routeUsingSkills method is invoked by a process builder called "Skills-Based Routing". 
        // The method gets run when a lead owner is updated to the Hopper queue.  
        update testLeads;        
    }
    
}
