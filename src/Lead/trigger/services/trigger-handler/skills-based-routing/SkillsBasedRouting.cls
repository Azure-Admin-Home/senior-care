/*************************************************************************************
Class Name     :  SkillsBasedRouting
Purpose        :  Contains apex methods for routing leads based on the skill object
History:                                                            
-------                                                            
VERSION  AUTHOR                 DATE                DETAIL
1.       Jason Fung             2019/09/05          Original Version.
2.		 Jason Fung				2019/09/11			Bulkify the apex codes.
3.	     Jason Fung				2019/10/09			Updated the routing logic so that a lead is routed to an agent based on Lead State (required), Lead Source (optional) and Lead Type (optional).
4.		 Jason Fung				2019/10/11			Added getStateAbbrev() method.
5.		 Jason Fung				2019/10/18			In the scenario when a lead matches with a State and Rule skill, agent must possess the rule skill but we also need to check if agent has the license to sell in the State that the lead belongs to.
6.		 Jason Fung				2019/10/22			If leads meet the criteria ((leadObj.CreatedDate).date() == Date.Today() && leadObj.CreatedById == '0053i000001RU7g' && leadObj.Leadscorz_Id__c != null), set RoutingPriority = 1. If not, set RoutingPriority = 2.
***************************************************************************************/
global class SkillsBasedRouting {
    
    public static set<Id> agentHasBeenAssigned = new set<Id>();
    
    /******************************************************
    * Method Name   :  routeUsingSkills
    * Description   :  An invocable method that gets the lead Id from process builder and create a PSR record for routing
    * Return Type   :  void
    * Parameters    :  list<String> leadIds
    *******************************************************/  
    @InvocableMethod
    public static void routeUsingSkills(list<String> leadIds) {
        
        list<PendingServiceRouting> psrListToInsert = new list<PendingServiceRouting>();
        list<PendingServiceRouting> psrListToUpdate = new list<PendingServiceRouting>();
        list<SkillRequirement> skillRequirementToInsert = new list<SkillRequirement>();            
        ServiceChannel channel = [Select Id From ServiceChannel Where RelatedEntity = 'Lead'];
        map<Id,Lead> leadMap = new map<Id,Lead>([SELECT Id, LeadSource, Lead_Type__c, State, CreatedDate, CreatedById, Leadscorz_Id__c FROM Lead WHERE Id in :leadIds]);
        list<Skill> ruleSkills = [Select Id, Description From Skill where DeveloperName LIKE 'Rule%' order by developername];
        list<Skill> stateSkills = [Select Id, Description From Skill where DeveloperName LIKE 'State%'];
        set<Id> psrIds = new set<Id>(); 
        set<Id> agentIds = new set<Id>(); 
        map<Id, Id> leadIdToSkillIdMap = new map<Id, Id>();
        map<Id, list<Id>> skillIdToAgentIdsMap = new map<Id, list<Id>>();
        map<Id, list<Id>> stateIdToAgentIdsMap = new map<Id, list<Id>>();
        map<Id, Id> leadIdToStateIdMap = new map<Id, Id>();
        set<Id> agentsToRemove = new set<Id>();         
        set<Id> agentIsOnline = new set<Id>();  
        
        // Delete any pre-existing PSR associated with the lead. 
        list<PendingServiceRouting> existingPSR = [select id from PendingServiceRouting where WorkItemId IN :leadMap.keyset()];
        if (!existingPSR.IsEmpty()) {
            delete existingPSR;
        }
        
        for (Lead leadObj : leadMap.values()) { 
            
            // Check if the leads are located in States that our company can provide service to.
            if (leadObj.State != null) {
            	String leadStateAbbrev = getStateAbbrev(leadObj.State);
                if (String.isNotBlank(leadStateAbbrev) && !stateSkills.isEmpty()) {                    
                    Id theStateId = getStateId(leadStateAbbrev, stateSkills);
                    // StateId not null means that the lead lives in a state that our company can provide service to.                    
                    if (theStateId != null) {                                                
                        leadIdToStateIdMap.put(leadObj.Id, theStateId);                          
                        // Create a new Skill-Based PendingServiceRouting
                        PendingServiceRouting psrObj = new PendingServiceRouting(
                            RoutingPriority = 2,
                            CapacityWeight = 1,
                            IsReadyForRouting = FALSE,
                            RoutingModel  = 'LeastActive',                            
                            RoutingType = 'SkillsBased',
                            ServiceChannelId = channel.Id,
                            WorkItemId = leadObj.Id
                        );     
                        // The leads that fits the criteria below are higher priority and should be routed first. Set RoutingPriority = 1.                        
                        if ((leadObj.CreatedDate).date() == Date.Today() && leadObj.CreatedById == '0053i000001RU7g' && leadObj.Leadscorz_Id__c != null) {
                            psrObj.RoutingPriority = 1;
                        }
                        psrListToInsert.add(psrObj);                        
                    } 
                }                
            }                  
        }
        
        // Insert PSR
        if (!psrListToInsert.isEmpty()) {            
            insert psrListToInsert;            
        }
        
        // Get the PSR Ids
        for (PendingServiceRouting psr : psrListToInsert) {
            psrIds.add(psr.Id);
        }
        
        psrListToUpdate = [select id, IsReadyForRouting, WorkItemId from PendingServiceRouting where id IN: psrIds];
        
        // Loop through psrListToUpdate, add SkillRequirement(s) to the PendingServiceRouting  
        for (PendingServiceRouting psr : psrListToUpdate) {
            Id theLeadId = psr.WorkItemId;
            Lead theLead = leadMap.get(theLeadId);
            Id theStateId = leadIdToStateIdMap.get(theLeadId);            
            stateIdToAgentIdsMap.put(theStateId, new list<Id>());
            
            // Add SkillRequirement(s) to the PendingServiceRouting                    
            SkillRequirement srObj = new SkillRequirement(
                RelatedRecordId = psr.id,
                SkillId = theStateId
            );	
            skillRequirementToInsert.add(srObj);            
            
            // Get the skill Ids and skill description for each lead
            Id theSkillId = getSkillId(theLead, ruleSkills);            
            
            if (theSkillId != null) {
                leadIdToSkillIdMap.put(theLeadId, theSkillId);
                skillIdToAgentIdsMap.put(theSkillId, new list<Id>());
            }
            
        }   
        
        // Create a skill requirement for psr
        if (!skillRequirementToInsert.isEmpty()) {
            insert skillRequirementToInsert;
        }     
                
        if (!skillIdToAgentIdsMap.isEmpty()) {
            // Map the relationship between Rule Skill and Agents
            for (ServiceResourceSkill srs : [select id, ServiceResource.RelatedRecordId, SkillId from ServiceResourceSkill where SkillId IN :skillIdToAgentIdsMap.keyset() order by SkillId, Priority__c]) {
                list<Id> agentIdList = skillIdToAgentIdsMap.get(srs.SkillId);
                if (!agentIdList.isEmpty()) {
                    agentIdList.add(srs.ServiceResource.RelatedRecordId);
                    skillIdToAgentIdsMap.put(srs.SkillId, agentIdList);
                }
                else {
                    skillIdToAgentIdsMap.put(srs.SkillId, new list<Id>{srs.ServiceResource.RelatedRecordId});                 
                }
                agentIds.add(srs.ServiceResource.RelatedRecordId);
            }            
            
            if (!stateIdToAgentIdsMap.isEmpty()) {
                // Map the relationship between State Skill and Agents
                for (ServiceResourceSkill srs : [select id, SkillId, ServiceResource.RelatedRecordId from ServiceResourceSkill where SkillId IN :stateIdToAgentIdsMap.keyset()]) {
                    list<Id> agentIdList = stateIdToAgentIdsMap.get(srs.SkillId);
                    if (!agentIdList.isEmpty()) {
                        agentIdList.add(srs.ServiceResource.RelatedRecordId);
                        stateIdToAgentIdsMap.put(srs.SkillId, agentIdList);
                    }
                    else {
                        stateIdToAgentIdsMap.put(srs.SkillId, new list<Id>{srs.ServiceResource.RelatedRecordId});                 
                    }  
                }      
            }            
            
            // If Agent is online, add agent to agentIsOnline set
            for (UserServicePresence usp : [select id, UserId from UserServicePresence where iscurrentstate = true]) {
                agentIsOnline.add(usp.UserId);
            }
            
            // If Agent is online but is not currently available to work on a lead, add agent to the remove set.             
            for (AgentWork aw : [select id, UserId from AgentWork where UserId IN :agentIds and (Status = 'Opened' OR Status = 'Assigned')]) {
                agentsToRemove.add(aw.UserId);
            }
            
            // Remove agent Id if agent is not available to work on a lead
            for (Id skillId : skillIdToAgentIdsMap.keyset()) {          
                list<Id> theAgentIds = skillIdToAgentIdsMap.get(skillId);  
                if (!theAgentIds.isEmpty()) {                    
                    for (Integer i = 0; i < theAgentIds.size(); i++) {
                        if (agentsToRemove.contains(theAgentIds.get(i))) {
                            theAgentIds.remove(i);
                        }                    
                    }  
                    skillIdToAgentIdsMap.put(skillId, theAgentIds);
                }
            }        
        }
        
        // Update PSR
        if (!psrListToUpdate.isEmpty()) {
            for (PendingServiceRouting psr : psrListToUpdate) {    
                      
                Id theSkillId = leadIdToSkillIdMap.get(psr.WorkItemId);
                Id theStateId = leadIdToStateIdMap.get(psr.WorkItemId);
                if (theSkillId != null && theStateId != null) {                    
                    list<Id> theAgentIdsForSkill = skillIdToAgentIdsMap.get(theSkillId);
                    list<Id> theAgentIdsForState = stateIdToAgentIdsMap.get(theStateId);
                    // Assign the next available agent based on priority for the skill. If the agent has already been assigned, move to the next available agent. 
                    if (!theAgentIdsForSkill.isEmpty()) {
                        for (Id theAgentId : theAgentIdsForSkill) {                        
                            if (!agentHasBeenAssigned.contains(theAgentId) && agentIsOnline.contains(theAgentId) && theAgentIdsForState.contains(theAgentId)) {
                                agentHasBeenAssigned.add(theAgentId);
                                psr.PreferredUserId = theAgentId;
                                break;                        
                            }
                        }                        
                    }
                }
                // Set IsReadyForRouting to true to start the routing
                psr.IsReadyForRouting = true;  
            }  

            update psrListToUpdate;       
        }
        
    } 
    
    /******************************************************
    * Method Name   :  getStateId
    * Description   :  A getter method for State Skill Id
    * Return Type   :  String
    * Parameters    :  Lead leadObj, list<Skill> stateSkills
    *******************************************************/  
    private static Id getStateId(String stateName, list<Skill> stateSkills) {
        
        if (String.isNotBlank(stateName) && !stateSkills.isEmpty()) {
            for (Skill skill : stateSkills) {
                if (skill.Description != null && stateName.toUpperCase() == (skill.Description).toUpperCase()) {
                    Id stateId = skill.Id;
                    return stateId;
                }
            }
        }
        return null;
    }
    
    /******************************************************
    * Method Name   :  getStateAbbrev
    * Description   :  A getter method for State Abbreviation
    * Return Type   :  String
    * Parameters    :  String stateName
    *******************************************************/  
    private static String getStateAbbrev(String stateName) {     	
        
        if (String.isNotBlank(stateName)) {
            String theStateName = (stateName.trim()).toUpperCase();
            if (theStateName.length() == 2) {
            	return theStateName;
            }
            else if (theStateName.length() > 2) {                
                switch on theStateName {
                    when 'ALABAMA' {return 'AL';}
                    when 'ALASKA' {return 'AK';}
                    when 'ARIZONA' {return 'AZ';}
                    when 'ARKANSAS' {return 'AR';}                    
                    when 'CALIFORNIA' {return 'CA';}
                    when 'COLORADO' {return 'CO';}
                    when 'CONNECTICUT' {return 'CT';}
                    when 'DELAWARE' {return 'DE';}
                    when 'FLORIDA' {return 'FL';}
                    when 'GEORGIA' {return 'GA';}
                    when 'HAWAII' {return 'HI';}
                    when 'IDAHO' {return 'ID';}                    
                    when 'ILLINOIS' {return 'IL';}
                    when 'INDIANA' {return 'IN';}
                    when 'IOWA' {return 'IA';}
                    when 'KANSAS' {return 'KS';}
                    when 'KENTUCKY' {return 'KY';}
                    when 'LOUISIANA' {return 'LA';}
                    when 'MAINE' {return 'ME';}
                    when 'MARYLAND' {return 'MD';}
                    when 'MASSACHUSETTS' {return 'MA';}
                    when 'MICHIGAN' {return 'MI';}
                    when 'MINNESOTA' {return 'MN';}
                    when 'MISSISSIPPI' {return 'MS';}
                    when 'MISSOURI' {return 'MO';}
                    when 'MONTANA' {return 'MT';}
                    when 'NEBRASKA' {return 'NE';}
                    when 'NEVADA' {return 'NV';}
                    when 'NEW HAMPSHIRE' {return 'NH';}
                    when 'NEW JERSEY' {return 'NJ';}
                    when 'NEW MEXICO' {return 'NM';}
                    when 'NEW YORK' {return 'NY';}
                    when 'NORTH CAROLINA' {return 'NC';}
                    when 'NORTH DAKOTA' {return 'ND';}
                    when 'OHIO' {return 'OH';}
                    when 'OKLAHOMA' {return 'OK';}
                    when 'OREGON' {return 'OR';}
                    when 'PENNSYLVANIA' {return 'PA';}
                    when 'RHODE ISLAND' {return 'RI';}
                    when 'SOUTH CAROLINA' {return 'SC';}
                    when 'SOUTH DAKOTA' {return 'SD';}
                    when 'TENNESSEE' {return 'TN';}  
                    when 'TEXAS' {return 'TX';}
                    when 'UTAH' {return 'UT';}
                    when 'VERMONT' {return 'VT';}
                    when 'VIRGINIA' {return 'VA';}
                    when 'WASHINGTON' {return 'WA';}
                    when 'WEST VIRGINIA' {return 'WV';}
                    when 'WISCONSIN' {return 'WI';}
                    when 'WYOMING' {return 'WY';}                    
                }                
            }             
        }
    	return null;
    }    
    
    /******************************************************
    * Method Name   :  getSkillId
    * Description   :  A getter method for Skill Ids
    * Return Type   :  String
    * Parameters    :  Lead leadObj, list<Skill> ruleSkills
    *******************************************************/  
    private static Id getSkillId(Lead leadObj, list<Skill> ruleSkills) {
                
        if (leadObj.LeadSource == null) {
            leadObj.LeadSource = '(blank)';
        }
        if (leadObj.Lead_Type__c == null) {
            leadObj.Lead_Type__c = '(blank)';
        }        
        
        // Find a skill that matches with the two fields (LeadSource, Lead_Type__c).  
        for (Skill skill : ruleSkills) {
            if (skill.Description != null) {
                Boolean isMatch = true;
                list<String> leadAttributes = new list<String>();
                if (skill.Description.contains(';')) {
            		leadAttributes = skill.Description.split(';');
                }
                if (!leadAttributes.isEmpty()) {
                    for (String la : leadAttributes) {
                        String fieldName = la.substringBefore(':');
                        String fieldValue = (la.substringAfter(':')).trim();
                            
                        if (fieldName == 'Source' && (leadObj.LeadSource).toUpperCase() != fieldValue.toUpperCase()) {
                            isMatch = false; 
                            break;
                        }
                        if (fieldName == 'Type' && (leadObj.Lead_Type__c).toUpperCase() != fieldValue.toUpperCase()) {
                            isMatch = false; 
                            break;
                        }
                    }                    
                    if (isMatch) {
                        Id skillId = skill.Id;
                        return skillId;
                    }
                }
            }
        }
        
        return null;        
    }
    
}