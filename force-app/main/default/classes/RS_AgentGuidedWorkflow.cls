/**
* @description       : Controller Class for rs_GuidedWorkflowComponent
* @author            : Accenture
* @group             : 
* @last modified on  : 04-06-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class RS_AgentGuidedWorkflow{
    
    /**
* @description 
* @author  Accenture| 07-13-2022 
* @param workflowNumber : Agent Workflow Action Number
* @return  List<RS_Agent_Workflow_Navigation__c>  : list of RS_Agent_Workflow_Navigation__c records that has Parent Action Name same as workflowNumber.
**/
    
    @AuraEnabled(cacheable=true)
    public static List<RS_Agent_Workflow_Navigation__c> getAgentWorkflowWithChoices(String workflowNumber){
        List<RS_Agent_Workflow_Navigation__c> agentWorkflowNavigations = new List<RS_Agent_Workflow_Navigation__c>();
        if(Schema.getGlobalDescribe().get('RS_Agent_Workflow_Navigation__c').getDescribe().isAccessible()) {        
            agentWorkflowNavigations = [select RS_Action_Name__r.id,RS_Action_Name__r.Name,RS_Action_Name__r.RS_Agent_Instructions__c,RS_Action_Name__r.RS_Agent_Selection__c,RS_Action_Name__r.RS_Additional_Agent_Instructions__c,
                                        RS_Action_Name__r.RS_Scripting_Data__c,RS_Action_Name__r.RS_Action_Type__c,RS_Action_Name__r.RS_Component_Name__c, RS_Action_Name__r.RS_IsIntent__c,RS_Parent__r.RS_Agent_Instructions__c,RS_Parent__r.RS_Additional_Agent_Instructions__c,
                                        RS_Parent__r.name,RS_Parent__r.ID,RS_Parent__r.RS_Mandatory_Input__c,RS_Action_Name__r.RS_Mandatory_Input__c,RS_Parent__r.RS_Scripting_Data__c,RS_Parent__r.RS_Action_Name__c,RS_Action_Name__r.Text_Field_To_Update__c, RS_Action_Name__r.RS_Text_Field_Type__c, RS_Parent__r.RS_Text_Field_Type__c, RS_Parent__r.Text_Field_To_Update__c,RS_Parent__c  from RS_Agent_Workflow_Navigation__c where  RS_Parent__r.RS_Action_Name__c=:workflowNumber WITH SECURITY_ENFORCED  ORDER BY CreatedDate];
        }
        return agentWorkflowNavigations;
        
    }
    /**
* @description 
* @author  Accenture| 07-13-2022 
* @param userId :Current LoggedIn User
* @return  String  : retruns the Guided Workflow Root Action Name based on LoggedIn User
**/
    @AuraEnabled(cacheable=true)
    public static GuidedworkflowRootNodeWrapperOutputClass getWorkflowRootNode(String userId){
        Id userType = UserInfo.getProfileId();
        String profileName = [SELECT Name FROM Profile WHERE Id =: userType].Name;
        GuidedworkflowRootNodeWrapperOutputClass guidedworkflowRootData=new GuidedworkflowRootNodeWrapperOutputClass();
        if(profileName==System.Label.RSI_Customer_Portal_Profile_Name){
            guidedworkflowRootData.guidedworkflowHeadingLabel=System.Label.RS_Guided_Workflow_Heading_Label_Portal_Users;
        }
        else{
            guidedworkflowRootData.guidedworkflowHeadingLabel=System.Label.RS_Guided_Workflow_Heading_Label_Internal_Users;
        }
        String rootingCriteria=[Select RS_Guided_Workflow_Rooting_Criteria__c from User Where Id=:userId]?.RS_Guided_Workflow_Rooting_Criteria__c;
        String rootingCriteriaObjectName=[Select toLabel(RS_Guided_Workflow_Rooting_Criteria__c) from User Where Id=:userId]?.RS_Guided_Workflow_Rooting_Criteria__c;
        if(rootingCriteria!=null){
            String query;
            User loggedInUserData;
            String loggedInUserSearchParameter;
            String rootNode;
            /* Object name field name(profileId) */
            String loggedInUserId=String.escapeSingleQuotes(userId);
            String guidedRootingCriteria=String.escapeSingleQuotes(rootingCriteria);
            if(rootingCriteria=='Id'){
                //query='Select RS_Guided_Workflow_Root_Node__c from User Where Id='+'\''+loggedInUserId+'\'';
                loggedInUserData= Database.query(('Select RS_Guided_Workflow_Root_Node__c from User Where Id='+'\''+loggedInUserId+'\''));
                rootNode = (String)loggedInUserData.get('RS_Guided_Workflow_Root_Node__c');
            }
            else{
                //query='Select '+String.escapeSingleQuotes(guidedRootingCriteria)+' from User Where Id='+'\''+String.escapeSingleQuotes(UserId)+'\'';
                loggedInUserData= Database.query('Select '+String.escapeSingleQuotes(guidedRootingCriteria)+' from User Where Id='+'\''+String.escapeSingleQuotes(UserId)+'\'');
                String searchObjectId=String.escapeSingleQuotes((String)loggedInUserData.get(guidedRootingCriteria));
                RS_Guided_Workflow_Rooting_Data__mdt dynamicQueryData=[Select RS_ObjectName__c,RS_FieldName__c from RS_Guided_Workflow_Rooting_Data__mdt where RS_ObjectName__c=:rootingCriteriaObjectName  WITH SECURITY_ENFORCED LIMIT 1];
                String dynamicSearchFieldName=String.escapeSingleQuotes(dynamicQueryData.RS_FieldName__c);
                String dynamicSearchObjectName=String.escapeSingleQuotes(dynamicQueryData.RS_ObjectName__c);
                String querySearchParam='Select '+dynamicSearchFieldName+' From '+dynamicSearchObjectName+' Where Id='+'\''+searchObjectId+'\'';
                sObject searchParam =Database.query(querySearchParam);
                loggedInUserSearchParameter = (String)searchParam.get(dynamicSearchFieldName);
                rootNode=[select RS_Criteria_Name__c,RS_Workflow_Root_Action_Name__c from RS_Guided_Workflow_Rooting_Data__mdt where RS_Criteria_Name__c=:loggedInUserSearchParameter  WITH SECURITY_ENFORCED]?.RS_Workflow_Root_Action_Name__c;
            }
            guidedworkflowRootData.workflowRootNode=rootNode;
            if(rootNode!=null){
                return guidedworkflowRootData;
            }
        }
        return null;
    }
       /**
* @description : Wrapper Method to pass root node and label
* @author  Accenture| 07-13-2022 
**/
    Public class GuidedworkflowRootNodeWrapperOutputClass{
        /* Guided Workflow Root Node Based on user criteria*/
        @AuraEnabled
        public String workflowRootNode;
         /* Guided Workflow Label Based on user criteria*/
        @AuraEnabled
        public String guidedworkflowHeadingLabel;
    }
    /**
* @description 
* @author  Accenture| 07-13-2022 
* @param workflowNumber : Agent Workflow Action Number
* @return   List<RS_Agent_Workflow__c>   : list of  RS_Agent_Workflow__c records that has Action Name same as workflowNumber.
**/
    @AuraEnabled 
    public static List<RS_Agent_Workflow__c> getScriptingDataForNoChildRecord(String workflowNumber){
        List<RS_Agent_Workflow__c> agentWorkflow = new List<RS_Agent_Workflow__c>(); 
        if(Schema.getGlobalDescribe().get('RS_Agent_Workflow__c').getDescribe().isAccessible()) {      
            agentWorkflow = [Select RS_Scripting_Data__c, RS_Agent_Instructions__c,RS_Additional_Agent_Instructions__c,RS_Action_Name__c from RS_Agent_Workflow__c where RS_Action_Name__c=:workflowNumber  WITH SECURITY_ENFORCED];
        }
        return agentWorkflow;
    }
    /**
* @description : Method used to fetch picklist values
* @author  Accenture| 07-13-2022 
* @param objectName :  Api name of Object to pick the picklist values from
* @param fieldname : Api name of field to pick the picklist values from
* @return   List<RS_Agent_Workflow__c>   : list of  RS_Agent_Workflow__c records that has Action Name same as workflowNumber.
**/
    @AuraEnabled(cacheable=true)
    public static Map<String,String> getPickListValuesIntoList(String objectName,String fieldname){
        Map<String,String> pickListValuesList= new Map<String,String>();
        Schema.SObjectType objSobjectType = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult objDescribeSobject = objSobjectType.getDescribe() ;
        Map<String,Schema.SObjectField> fields = objDescribeSobject.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldname).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.put(pickListVal.getValue(), pickListVal.getLabel());
            //pickListValuesList.add(pickListVal.getLabel());
        }
        return pickListValuesList;
    }
    /**
* @description 
* @author  Accenture| 07-13-2022 
* @param actionName : Agent Workflow Name
* @return  List<String> 
**/
    @AuraEnabled(cacheable=true)
    public static List<String> getActionNumberType(String actionName){
        List<String> listActionTypeNumber = new List<String>();
        List<RS_Agent_Workflow__c> actionnumber = new List<RS_Agent_Workflow__c>();
        if(Schema.getGlobalDescribe().get('RS_Agent_Workflow__c').getDescribe().isAccessible()) {  
            actionnumber = [Select RS_Action_Name__c,RS_Action_Type__c,RS_Component_Name__c,RS_Additional_Agent_Instructions__c from RS_Agent_Workflow__c where name=:actionName WITH SECURITY_ENFORCED];
        }
        listActionTypeNumber.add(actionnumber[0].RS_Action_Name__c);
        listActionTypeNumber.add(actionnumber[0].RS_Action_Type__c);
        listActionTypeNumber.add(actionnumber[0].RS_Component_Name__c);
        listActionTypeNumber.add(actionnumber[0].RS_Additional_Agent_Instructions__c);
        return listActionTypeNumber;
    }
    
    
    
    /**
* @description 
* @author  Accenture| 07-13-2022 
* @param choices :List of action numbers clicked by agent.
* @param recordID : Record Id of Corresponding Interaction Channel.
* @param userId :  Currently LoggedIn User Id.
* @return  String : Return the Agent Workflow Choice Number Created.
**/
    @AuraEnabled
    public static String createWorkflowChoices(List<String> choices,String recordID,String userId){
        String customerProfileName = System.Label.RSI_Customer_Portal_Profile_Name;
        Id profileId = UserInfo.getProfileId();
        String sObjName;
        String profileName =[Select Id, Name from Profile where Id=:profileId].Name;
        if(recordId!=null){
            sObjName = Id.valueOf(recordID).getSObjectType().getDescribe().getName();
        }
        else if(profileName==customerProfileName){
            sObjName='User';
        }
        
        String account;
        String recId;
        String choicesList='';
        String awcnumber;
        String clickpath='Global Intro';
        List<RS_Agent_Workflow__c> agentWorkflowReclist;
        if(Schema.getGlobalDescribe().get('RS_Agent_Workflow__c').getDescribe().isAccessible()) {  
            agentWorkflowReclist = [Select RS_Agent_Selection__c from RS_Agent_Workflow__c where RS_Action_Name__c IN:choices WITH SECURITY_ENFORCED];
        }
        for(RS_Agent_Workflow__c ag:agentWorkflowReclist){
            clickpath=clickpath+'-->'+ag.RS_Agent_Selection__c;   
        }
        for(String c:choices){
            choicesList=choicesList+','+c;
        }
        String s=choicesList.substring(0,0)+choicesList.substring(1,choicesList.length());
        
        RS_Agent_Workflow_Choices__c agentWorkflowchoice = new RS_Agent_Workflow_Choices__c();
        rS_GuidedWorkflow__mdt  recordDetails=[Select ObjectName__c,Fields__c from rS_GuidedWorkflow__mdt where ObjectName__c=:sObjName  WITH SECURITY_ENFORCED];
        String query;
        String recordFieldName=String.escapeSingleQuotes(recordDetails.Fields__c);
        String recordObjectName=String.escapeSingleQuotes(recordDetails.ObjectName__c);
        if(profileName!=customerProfileName){
            String objectRecordId=String.escapeSingleQuotes(recordId);
            //query='Select ID,'+recordFieldName+' FROM '+recordObjectName+' WHERE Id='+  +'\''+ objectRecordId +'\' ';
            SObject record=Database.query('Select ID,'+recordFieldName+' FROM '+recordObjectName+' WHERE Id='+  +'\''+ objectRecordId +'\' ');
            account=(String)record.get(recordFieldName);
        }
        else{
            userId=String.escapeSingleQuotes(userId);
            //query='Select ID,'+recordFieldName+' FROM '+recordObjectName+' WHERE Id='+  +'\''+userId+'\' ';
            SObject userrecord=Database.query('Select ID,'+recordFieldName+' FROM '+recordObjectName+' WHERE Id='+  +'\''+userId+'\' ');
            String contact=(String)userrecord.get(recordDetails.Fields__c);
            account=[select id  from account where PersonContactId=:contact WITH SECURITY_ENFORCED Limit 1].Id;
        }
        
        
        // Below lines are commented to remove the Intraction references from the code
        /*if(sObjName=='VoiceCall'){
            agentWorkflowchoice.RS_Voice_Call__c=recordID;
        }
        else if(sObjName=='MessagingSession'){
            agentWorkflowchoice.RS_Messaging_Session__c=recordID;
        }
        else if(sObjName=='LiveChatTranscript'){
            agentWorkflowchoice.RS_Chat_Transcript__c=recordID;
        }*/
        if(sObjName=='Contact'){
            agentWorkflowchoice.RS_Contact__c=recordID;
        }
        else if(sObjName=='User'){
            agentWorkflowchoice.RS_Contact__c=account;
        }
        // Below code is added as part of Optimization
        else {
            agentWorkflowchoice.Interaction_RecordId__c=recordID;
        }
        agentWorkflowchoice.RS_Agent_Choices_Click_Path__c=clickpath;
        agentWorkflowchoice.RS_Choices__c=s;
        agentWorkflowchoice.RS_Account__c=account;
        agentWorkflowchoice.RS_Contact__c=[Select id from Contact where AccountId=:account WITH SECURITY_ENFORCED Limit 1]?.id;
        if(Schema.getGlobalDescribe().get('RS_Agent_Workflow_Choices__c').getDescribe().isCreateable()) {  
            insert agentWorkflowchoice;
        }
        if(Schema.getGlobalDescribe().get('RS_Agent_Workflow_Choices__c').getDescribe().isAccessible()) {
            awcnumber = [Select name from RS_Agent_Workflow_Choices__c where id=:agentWorkflowchoice.Id WITH SECURITY_ENFORCED]?.name;
        }
        return awcnumber;
    }
    
    
    /**
* @description 
* @author  Accenture| 07-13-2022 
* @param name :Choice Record Name.
* @return  String : Return the Record Type Name.
**/
    @AuraEnabled
    public static string getRecordType(String name){ 
        String recordTypename;
        if(Schema.getGlobalDescribe().get('RS_Agent_Workflow_Choices__c').getDescribe().isAccessible()) {
            RS_Agent_Workflow_Choices__c awcnumber = [Select RS_Choices__c from RS_Agent_Workflow_Choices__c where name=:name WITH SECURITY_ENFORCED];
            List<String> choiceList=awcnumber.RS_Choices__c.split(',');
            List<String> fieldValues = new List<String>();
            List<RS_Agent_Workflow__c> agentrec=[Select RS_Case_Fields_to_Update__c,RS_Action_Name__c,Record_Type__c from RS_Agent_Workflow__c where RS_Action_Name__c IN:choiceList WITH SECURITY_ENFORCED];
            for(RS_Agent_Workflow__c c:agentrec){
                if(c.Record_Type__c!=null){
                    recordTypename=c.Record_Type__c;
                }
            }
        }
        return recordTypename;
    }
}