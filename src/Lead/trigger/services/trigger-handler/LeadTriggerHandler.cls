/****************************************************************************************************************************************************
* Class Name                     : LeadTriggerHandler
* Created By                     : Suneel Sunkara 09/04/2019
* Test Class                     : LeadTriggerHandlerTest
* Description                    : 
*****************************************************************************************************************************************************
* Modification Log:
*****************************************************************************************************************************************************
* Story/Issue No.     Modified By        Modified Date            Modification Description                         
*****************************************************************************************************************************************************
* TASK-392832014      Suneel             09/04/2019          	  Added methods to calcualte Lead Score
* N/A         		  Jason Fung         10/03/2019      		  Remove PendingServiceRouting from lead when a lead is reassigned from Hopper to another person/queue
* N/A				  Jason Fung		 10/24/2019				  Seperate the deleteLeadPSR() method from the Lead Trigger Toggle so that it is not affected by the toggle in custom metadata setting. 
*****************************************************************************************************************************************************/

public class LeadTriggerHandler {
    
    private static set<Id> deleteLeadPSRHasRun = new set<Id>();    
    
    public static void beforeInsertHandler(List<Lead> newLeadList){
        updateLeadScore(newLeadList);
    }
    
    public static void beforeUpdateHandler(map<id , Lead> oldLeadMap , List<Lead> newLeadList){ 
        List<Lead> finalLeadList = new List<Lead>();
        for(Lead l : newLeadList){
            Lead oldLead = oldLeadMap.get(l.id);
            if(l.Batch_Job_Date__c != oldLead.Batch_Job_Date__c && l.Lead_Score_Concatenate__c != oldlead.Lead_Score_Concatenate__c)  {
                finalLeadList.add(l);
            }
        }
        if(!finalLeadList.isEmpty()){
            updateLeadScore(finalLeadList);
        }
    }
    
    public static void afterUpdateHandler(map<Id, Lead> oldLeadMap , List<Lead> newLeadList){
                  
    }
    
    // Remove PendingServiceRouting from lead when a lead is reassigned from Hopper to another person/queue
    public static void deleteLeadPSR(map<Id, Lead> oldLeadMap, list<Lead> newLeadList) {
        
        set<Id> leadIds = new set<Id>(); 
        
        for (Lead l : newLeadList) {
            Lead oldLead = oldLeadMap.get(l.Id);
            // 00G3i000000mIf6 is the SFDC Id for the "Hopper" queue
            // Check if a lead has been reassigned from "Hopper" queue to another user/queue
            if (!deleteLeadPSRHasRun.contains(l.Id) && oldLead.OwnerId == '00G3i000000mIf6' && l.OwnerId != '00G3i000000mIf6') {
                leadIds.add(l.Id);
                deleteLeadPSRHasRun.add(l.Id);
            }            
        }
        
        if (!leadIds.isEmpty()) {
            // Query for all PSRs that are associted with the leads
            list<PendingServiceRouting> psrToDeleteList = [select Id from PendingServiceRouting where WorkItemId IN :leadIds];
            
            // Delete PSRs
            if (!psrToDeleteList.isEmpty()) {
                delete psrToDeleteList;
            }            
        }
    }
    
    public static void leadReassignment(List<Lead> leadRecords, map<Id , Lead> oldLeadMap){
        List<String> lastCallDisposition = new List<String>{'Caller Disconnected - HANGUP', 'MISC - Hang-up', 'Not Available', 'Not Interested', 'Skip Lead - NRTS (Not Ready To Sell)', 'Skip Lead - Other', 'Unexpected Disconnection', 'Working with External Agent/Broker'};
        List<String> unqualifiedDisposition = new List<String>{'Current Member', 'Deceased', 'Ghost Call', 'Language Barrier', 'Not Eligible', 'Not Eligible - No SEP', 'Not interested - Benefits', 'Not Interested - Drugs not covered', 'Not Interested - Group/Union Coverage', 'Not interested - PCP not in network', 'Not Interested - Premium', 'Not Interested - TriCare', 'Wrong Number', 'NO Plans in Area - Bad Lead'};
        List<String> qualifiedDisposition = new List<String>{'AEP Callback', 'Committed Enrollment Customer to Callback', 'Enrollment - New Single', 'Follow up - Agent Owned', 'Post Enrollment', 'Transfer to RTS Agent', 'No Plans in Area - AEP Call back'};
        List<Group> Unassigned  = [select Id from Group where  Type = 'Queue' AND NAME = 'Unassigned'];
        List<Dail_Attempts__mdt> dailAttempts = [select id, Max_Age__c, Min_Age__c, Dails_Attempt__c, Resting_Period__c from Dail_Attempts__mdt];
        List<Last_Call_By_State__mdt> stateCallTimings = [select id, First_Dail__c, Last_Dial__c, DeveloperName from Last_Call_By_State__mdt];
        for(Lead ld : leadRecords){
            Lead oldLead = new Lead();
            Integer ageOfCall = 1;
            
            if(!oldLeadMap.isEmpty()) {
                oldLead = oldLeadMap.get(ld.Id);
                Date myDate = date.newinstance(ld.CreatedDate.year(), ld.CreatedDate.month(), ld.CreatedDate.day());
                ageOfCall = myDate.daysbetween(System.Today());
            }    
            if(ld.Disposition__c <> oldLead.Disposition__c){
                if(lastCallDisposition.contains(ld.Disposition__c)){
                    ld.Timestamp__c = ld.Last_Dial_Attempt__c;
                    if(!Unassigned.isEmpty()) ld.OwnerId = Unassigned[0].Id;
                }    
                if(unqualifiedDisposition.contains(ld.Disposition__c)){
                    ld.Status = 'Unqualified';
                }
                if(qualifiedDisposition.contains(ld.Disposition__c)){
                    ld.Status = 'Qualified';
                } 
           } 
           for(Dail_Attempts__mdt at : dailAttempts){
               if(ageOfCall >= at.Min_Age__c && ageOfCall <= at.Max_Age__c ){
                  ld.Daily_Call_Attempts__c = at.Dails_Attempt__c;
                  ld.Daily_Call_Rest_Time__c = at.Resting_Period__c;
                  break;
               }
           }
           for(Last_Call_By_State__mdt at : StateCallTimings){
               if(at.DeveloperName == ld.State){
                  ld.First_Dial_Time__c = convertStringToTime(at.First_Dail__c);
                  ld.Last_Dial_Time__c = convertStringToTime(at.Last_Dial__c);
                  break;
               }
           }
           if(ld.Last_Dial_Attempt__c <> null && ld.Daily_Call_Rest_Time__c <> null){
               if(ld.Dials_Remaining__c > 0){
                    ld.Next_Dial_Attempt__c = ld.Last_Dial_Attempt__c + ld.Daily_Call_Rest_Time__c;
                }
                else{
                    ld.Next_Dial_Attempt__c = ld.Last_Dial_Attempt__c.addDays(1) + ld.Daily_Call_Rest_Time__c;
                }
            }    
        }
    }
    public static Time convertStringToTime(String value){
        Integer hours = Integer.valueOf(value.substringBefore(':'));
        String timeZone = value.substringAfter(' ');
        Time myTime = Time.newInstance(hours, 0, 0, 0);
        if(timeZone.trim() == 'PM'){
            myTime = myTime.addHours(12);
        }
        return myTime;
    }
    
    
    
    //TASK-392832014  
    private static void updateLeadScore(List<Lead> newLeadList){
        for(Lead l : newLeadList){
            string leadSource = '';
            string leadType = '';
            string subId = '';
            string inOutbound = '';
            
            if(l.LeadSource != null && l.LeadSource !=''){
                leadSource = l.LeadSource;
            }
            if(l.Lead_Type__c != null && l.Lead_Type__c !=''){
                leadType = l.Lead_Type__c;
            }
            if(l.Sub_ID__c != null && l.Sub_ID__c !=''){
                subId = l.Sub_ID__c;
            }
            if(l.Inbound_Outbound__c != null && l.Inbound_Outbound__c !=''){
                inOutbound = l.Inbound_Outbound__c;
            }
            
            string concatenate =  leadSource + l.Age_of_Lead__c + leadType + subId + inOutbound;
            
            if(concatenate=='Website13FormOutbound')
                l.Leadscore__c = 100;
            
            else if(concatenate=='Facebook13Outbound')
                l.Leadscore__c = 99;
            
            else if(concatenate=='Website1InboundInbound')
                l.Leadscore__c = 98;
            
            else if(concatenate=='Facebook1InboundInbound')
                l.Leadscore__c =  97;
            
            else if(concatenate=='Inside Response116IR-35Inbound')
                l.Leadscore__c =  96;
            
            else if(concatenate=='Cege11Inbound')
                l.Leadscore__c =  95;
            
            else if(concatenate=='Inside Response115IR-40Inbound')
                l.Leadscore__c =  94;
            
            else if(concatenate=='Wasatch114DTInbound')
                l.Leadscore__c =  93;
            
            else if(concatenate=='Cege116Text TransferInbound')
                l.Leadscore__c =  92;
            
            else if(concatenate=='Website11Cege Third-Party TransferInbound')
                l.Leadscore__c =  91;
            
            else if(concatenate=='TRG13Outbound')
                l.Leadscore__c =  90;
            
            else if(concatenate=='Cege131724Outbound')
                l.Leadscore__c =  89;
            
            else if(concatenate=='Cege13781Outbound')
                l.Leadscore__c =  88;
            
            else if(concatenate=='Cege13465Outbound')
                l.Leadscore__c =  87;
            
            else if(concatenate=='Cege13203Outbound')
                l.Leadscore__c =  86;
            
            else if(concatenate=='Cege131720Outbound')
                l.Leadscore__c =  85;
            
            else if(concatenate=='Cege13199Outbound')
                l.Leadscore__c =  84;
            
            else if(concatenate=='Cege13851Outbound')
                l.Leadscore__c =  83;
            
            else if(concatenate=='Cege134126Outbound')
                l.Leadscore__c =  82;
            
            else if(concatenate=='Cege134092Outbound')
                l.Leadscore__c =  81;
            
            else if(concatenate=='Cege134102Outbound')
                l.Leadscore__c =  80;
            
            else if(concatenate=='Cege134112Outbound')
                l.Leadscore__c =  79;
            
            else if(concatenate=='Cege134120Outbound')
                l.Leadscore__c =  78;
            
            else if(concatenate=='Cege134122Outbound1')
                l.Leadscore__c =  77;
            
            else if(concatenate=='Cege134174Outbound')
                l.Leadscore__c =  76;
            
            else if(concatenate=='Cege134202Outbound')
                l.Leadscore__c =  75;
            
            else if(concatenate=='Cege134236Outbound')
                l.Leadscore__c =  74;
            
            else if(concatenate=='Website2-73FormOutbound')
                l.Leadscore__c =  73;
            
            else if(concatenate=='Facebook2-73Outbound')
                l.Leadscore__c =  72;
            
            else if(concatenate=='Website2-7InboundInbound')
                l.Leadscore__c =  71;
            
            else if(concatenate=='Facebook2-7InboundInbound')
                l.Leadscore__c =  70;
            
            else if(concatenate=='Inside Response2-716IR-35Inbound')
                l.Leadscore__c =  69;
            
            else if(concatenate=='Cege2-71Inbound')
                l.Leadscore__c =  68;
            
            else if(concatenate=='Inside Response2-715IR-40Inbound')
                l.Leadscore__c =  67;
            
            else if(concatenate=='Wasatch2-714DTInbound')
                l.Leadscore__c =  66;
            
            else if(concatenate=='Cege2-716Text TransferInbound')
                l.Leadscore__c =  65;
            
            else if(concatenate=='Website2-71Cege Third-Party TransferInbound')
                l.Leadscore__c =  64;
            
            else if(concatenate=='TRG2-73Outbound')
                l.Leadscore__c =  63;
            
            else if(concatenate=='Cege2-731724Outbound')
                l.Leadscore__c =  62;
            
            else if(concatenate=='Cege3781Outbound')
                l.Leadscore__c =  61;
            
            else if(concatenate=='Cege2-73465Outbound')
                l.Leadscore__c =  60;
            
            else if(concatenate=='Cege2-73203Outbound')
                l.Leadscore__c =  59;
            
            else if(concatenate=='Cege2-731720Outbound')
                l.Leadscore__c =  58;
            
            else if(concatenate=='Cege2-73199Outbound')
                l.Leadscore__c =  57;
            
            else if(concatenate=='Cege2-73851Outbound')
                l.Leadscore__c =  56;
            
            else if(concatenate=='Cege2-734126Outbound')
                l.Leadscore__c =  55;
            
            else if(concatenate=='Cege2-734092Outbound')
                l.Leadscore__c =  54;
            
            else if(concatenate=='Cege2-734102Outbound')
                l.Leadscore__c =  53;
            
            else if(concatenate=='Cege2-734112Outbound')
                l.Leadscore__c =  52;
            
            else if(concatenate=='Cege2-734120Outbound')
                l.Leadscore__c =  51;
            
            else if(concatenate=='Cege2-734122Outbound')
                l.Leadscore__c =  50;
            
            else if(concatenate=='Cege2-734174Outbound')
                l.Leadscore__c =  49;
            
            else if(concatenate=='Cege2-734202Outbound')
                l.Leadscore__c =  48;
            
            else if(concatenate=='Cege2-734236Outbound')
                l.Leadscore__c =  47;
            
            else if(concatenate=='Website8+3FormOutbound')
                l.Leadscore__c =  46;
            
            else if(concatenate=='Facebook8+3Outbound')
                l.Leadscore__c =  45;
            
            else if(concatenate=='Website8+InboundInbound')
                l.Leadscore__c =  44;
            
            else if(concatenate=='Facebook8+InboundInbound')
                l.Leadscore__c =  43;
            
            else if(concatenate=='Inside Response8+16IR-35Inbound')
                l.Leadscore__c =  42;
            
            else if(concatenate=='Cege8+1Inbound')
                l.Leadscore__c =  41;
            
            else if(concatenate=='Inside Response8+15IR-40Inbound')
                l.Leadscore__c =  40;
            
            else if(concatenate=='Wasatch8+14DTInbound')
                l.Leadscore__c =  39;
            
            else if(concatenate=='Cege8+16Text TransferInbound')
                l.Leadscore__c =  38;
            
            else if(concatenate=='Website8+CegeThird-Party TransferInbound')
                l.Leadscore__c =  37;
            
            else if(concatenate=='TRG8+3Outbound')
                l.Leadscore__c =  36;
            
            else if(concatenate=='Cege8+31724Outbound')
                l.Leadscore__c =  35;
            
            else if(concatenate=='Cege8+3781Outbound')
                l.Leadscore__c =  34;
            
            else if(concatenate=='Cege8+3465Outbound')
                l.Leadscore__c =  33;
            
            else if(concatenate=='Cege8+3203Outbound')
                l.Leadscore__c =  32;
            
            else if(concatenate=='Cege8+31720Outbound')
                l.Leadscore__c =  31;
            
            else if(concatenate=='Cege8+3199Outbound')
                l.Leadscore__c =  30;
            
            else if(concatenate=='Cege8+3851Outbound')
                l.Leadscore__c =  29;
            
            else if(concatenate=='Cege8+34126Outbound')
                l.Leadscore__c =  28;
            
            else if(concatenate=='Cege8+34092Outbound')
                l.Leadscore__c =  27;
            
            else if(concatenate=='Cege8+34102Outbound')
                l.Leadscore__c =  26;
            
            else if(concatenate=='Cege8+34112Outbound')
                l.Leadscore__c =  25;
            
            else if(concatenate=='Cege8+34120Outbound')
                l.Leadscore__c =  24;
            
            else if(concatenate=='Cege8+34122Outbound')
                l.Leadscore__c =  23;
            
            else if(concatenate=='Cege8+34174Outbound')
                l.Leadscore__c =  22;
            
            else if(concatenate=='Cege8+34202Outbound')
                l.Leadscore__c =  21;
            
            else if(concatenate=='Cege8+34236Outbound')
                l.Leadscore__c =  20;
            
        }
    }
}