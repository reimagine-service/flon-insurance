/**
* @description       : Custom controller for Confirmation Screen Web Components
* @author            : joel.samuel.s.penke@accenture.com
* @group             : SF
* @last modified on  : 03-24-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public without sharing class RS_GuidedFlowConfScreenController {
    
    /**
* @description 
* @author joel.samuel.s.penke@accenture.com | 06-08-2022 
* @param mdtRecName : custom metadata record Name
* @param caserecordtype : case record type name
* @return List<RS_DynamicSearch__mdt> : list of custom metadata records that match the name
**/

    @AuraEnabled(cacheable=true)
    public static List<RS_DynamicSearch__mdt> fetchFields(String mdtRecName,String caserecordtype){
        String searchText;
        System.debug('mdtRecName'+mdtRecName+caserecordtype);
        if(caserecordtype!=null && mdtRecName!=null){
            searchText=mdtRecName+'+'+caserecordtype;
        }
        else if(mdtRecName!=null){
            searchText=mdtRecName;
        }
        else if(caserecordtype!=null && mdtRecName==null){
            searchText=caserecordtype;
        }
        List<RS_DynamicSearch__mdt> metarec;
        if(Schema.getGlobalDescribe().get('RS_DynamicSearch__mdt').getDescribe().isAccessible()){
            metarec=[SELECT MasterLabel, Field_Name__c,Object_Name__c,isDisabled__c,Lookup_Field_to_Link__c,Update_Case_Id__c from RS_DynamicSearch__mdt WHERE MasterLabel =:searchText WITH SECURITY_ENFORCED LIMIT 1];  
            
        }
        return metarec;
        
    }
    
    /**
* @description 
* @author joel.samuel.s.penke@accenture.com | 06-08-2022 
* @param agentChoice : agent workflow choice record name
* @param inputTextField : field apiname and value map to update on case
* @param inputLength : length of inputTextField
* @param recordtypeid : case record type
* @return Map<String,String> : a Map of Field value pairs of a Case
**/
    @AuraEnabled(cacheable=true)
    public static Map<String,String> getChoiceDetails(String agentChoice,Object inputTextField,String inputLength,String recordtypeid){
        String recordid=[Select Id from recordtype where DeveloperName=:recordtypeid]?.Id;
        Map<String,String> prepMap = new Map<String,String>();
        String s=String.valueOf(inputTextField);
        System.debug('inputTextField'+inputTextField);
        if(inputLength!='0'){
            List<String> input=s.split('},');
            for(String sr:input){
                List<String> splitdata=sr.split(',');
                String fieldname=splitdata[0].split('=').get(1);
                String value=splitdata[1].split('=').get(1);
                prepMap.put(Fieldname,value.removeEnd('})'));
            }
        }
        Map<String,RS_Agent_Workflow__c> awMap = new Map<String, RS_Agent_Workflow__c>();
        List<RS_Agent_Workflow__c> awUpdatedList = new List<RS_Agent_Workflow__c>();
        try {
            List<RS_Agent_Workflow_Choices__c> awchoiceList;
            List<String> fieldValues = new List<String>();
            //if(Schema.getGlobalDescribe().get('RS_Agent_Workflow_Choices__c').getDescribe().isAccessible()){
            // updated awchoiceList to remove the interaction references
                awchoiceList = [SELECT Id, RS_User__c,Intent__c,RS_Choices__c,RS_Account__c,RS_Contact__c,Interaction_RecordId__c FROM RS_Agent_Workflow_Choices__c WHERE Name =:agentChoice LIMIT 1];
            //}
            String choices = awchoiceList[0].RS_Choices__c;
            String notes=' ';
            
            if(String.isNotBlank(choices)){
                List<String> choiceList = choices.split(',');
                List<RS_Agent_Workflow__c> awList;
                if(Schema.getGlobalDescribe().get('RS_Agent_Workflow__c').getDescribe().isAccessible()){
                    awList = [SELECT Id,RS_Action_Name__c,RS_Action_Type__c,RS_IsIntent__c,RS_Case_Fields_to_Update__c,RS_AutomatedNotes__c from RS_Agent_Workflow__c WHERE RS_Action_Name__c IN: choiceList WITH SECURITY_ENFORCED];
                }
                for(RS_Agent_Workflow__c aw : awList){
                    awMap.put(aw.RS_Action_Name__c, aw);
                }
                for(String x : choiceList){
                    awUpdatedList.add(awMap.get(x));
                }
                for(RS_Agent_Workflow__c aw: awUpdatedList){
                    String temp = aw.RS_Case_Fields_to_Update__c;
                    if(String.isNotBlank(temp) && temp != null){
                        fieldValues.addAll(temp.split('[=;]'));
                    }
                    
                    //To capture Automated Notes
                    if(prepMap.get('Description')!=null){
                        notes=prepMap.get('Description');
                    }
                    if(String.isNotBlank(aw.RS_AutomatedNotes__c)){
                        notes = ((String.isBlank(notes))? aw.RS_AutomatedNotes__c : notes +' ' + aw.RS_AutomatedNotes__c);
                    }
                }
                prepMap.put('Description', notes);
                if(recordid!=null){
                    prepMap.put('RecordTypeId', recordid);
                }
                integer index;
                String ownerValue;
                if(fieldValues.size() >0){
                    for(Integer i=0;i<fieldValues.size();i+=2){
                        if(fieldValues[i] == 'OwnerId'){
                            ownerValue = fieldValues[i+1];
                        }
                        //if(fieldValues[i] == 'OwnerId')
                        prepMap.put(fieldValues[i],fieldValues[i+1]);
                    }
                    if(ownerValue!=NULL){
                        Group grp;
                        grp =[SELECT Id,Name,DeveloperName,Type FROM Group where Type ='Queue' and DeveloperName=:ownerValue WITH SECURITY_ENFORCED];
                        prepMap.put('OwnerId', grp.Id);
                        prepMap.put('RS_Additional_details_for_queue__c','');
                    }
                }
                
                if(awchoiceList[0].RS_Account__c != null){
                    prepMap.put('AccountId',awchoiceList[0].RS_Account__c);
                }
                
                if(awchoiceList[0].RS_Contact__c  != null){
                    prepMap.put('ContactId',awchoiceList[0].RS_Contact__c);
                }
                
            }
            
        } 
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage() + ' '+ e.getCause()+ ' '+e.getLineNumber());
        }
        
        return prepMap;
    }
    
    /**
* @description 
* @author joel.samuel.s.penke@accenture.com | 06-08-2022 
* @param choiceName : agent workflow choice record name
* @param fieldApiName: Lookup field Api name to link the case
* @param recId : newly created record's Id 
**/
    @AuraEnabled
    public static void updateChoiceRecord(String choiceName, String fieldApiName, String updateCasefield,String recId, String newRecordId){
        try{
            RS_Agent_Workflow_Choices__c choiceToUpdate;
            if(Schema.getGlobalDescribe().get('RS_Agent_Workflow_Choices__c').getDescribe().isAccessible()){
                // updated awchoiceList to remove the interaction references
                choiceToUpdate = [SELECT Id,RS_Is_Save_Successful__c,Saved_Record_Id__c,Interaction_RecordId__c from RS_Agent_Workflow_Choices__c WHERE Name=:choiceName WITH SECURITY_ENFORCED];
            }
            choiceToUpdate.RS_Is_Save_Successful__c = true;
            // Commented the below line to remove the references
            //String objectRecId = String.isBlank(choiceToUpdate.RS_Voice_Call__c) ? String.valueOf(choiceToUpdate.RS_Chat_Transcript__c) : String.valueOf(choiceToUpdate.RS_Voice_Call__c); 
            // added the below line without reference with interation fields
            String objectRecId = choiceToUpdate.Interaction_RecordId__c; 
         /*   if(String.isBlank(objectRecId)){
                objectRecId = String.valueOf(choiceToUpdate.RS_Messaging_Session__c);
            }*/
            String objName = Id.valueOf(objectRecId).getSObjectType().getDescribe().getName();            
            SObject  o = (sObject)Type.forName(objName).newInstance();
            
            o.put(fieldApiName, recId);
            if(updateCasefield != null && updateCasefield != 'undefined'){
                o.put(updateCasefield,  recId);
            }
            
            o.put('id', objectRecId);
            choiceToUpdate.Saved_Record_Id__c = newRecordId;
            
            database.SaveResult sr = database.update(o);
            database.SaveResult sr2 = database.update(choiceToUpdate);
            
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    /**
* @description 
* @author Accenture | 06-08-2022 
* @param COMMUNITYID : Community Id
* @param recId : newly created record's Id 
**/
    @AuraEnabled
    public static String getCommunityURL(String UserId){
        String customerProfileName = System.Label.RSI_Customer_Portal_Profile_Name;
        User  userInfo=[SELECT id,Profile.name from user where Id=:UserId];
        System.debug('userInfo'+userInfo);
        String communityName=System.Label.RSI_Customer_Portal_Name;
         system.debug('siteInfo'+communityName);
        if(userInfo.Profile.name==customerProfileName){
        Site siteInfo = [SELECT Name, UrlPathPrefix FROM Site WHERE Name =:communityName];
            system.debug('siteInfo'+SiteInfo.UrlPathPrefix);
        return SiteInfo.UrlPathPrefix;
        }
        return null;
    }
    
}