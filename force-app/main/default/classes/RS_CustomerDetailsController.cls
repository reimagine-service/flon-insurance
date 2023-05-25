/**
* @description       : Custom controller for Customer Profile Snapshot
* @author            : Accenture
* @group             : 
* @last modified on  : 03-23-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

public with sharing class RS_CustomerDetailsController{
    
    /**
* @description 
* @author  Accenture| 07-13-2022 
* @param recordId : Corresponding record page id
* @return   List<RS_Customer_Details__mdt>  : list of field and labels of corresponding object to be displayed on UI
**/
    @AuraEnabled
    public static List<RS_Customer_Details__mdt> getCustomerDetails(String recordId)
    {
        String recordTypeId;
        List<RS_Customer_Details__mdt> metaData = new List<RS_Customer_Details__mdt>();
        if(recordId!=NULL){
            String objName=String.escapeSingleQuotes(Id.valueOf(recordId).getSObjectType().getDescribe().getName());
            String accountId=String.escapeSingleQuotes(recordId);
            String queryString = 'SELECT Name, RecordTypeId FROM '+objName+' WHERE Id =:accountId';
            SObject recordTypeInfo = Database.query(queryString);
            recordTypeId = (String)recordTypeInfo.get('RecordTypeId');
            String recordTypeName=[Select name from RecordType where id=:recordTypeId]?.name;
            if(recordTypeName!=NULL){
                metaData = database.query('Select Fields__c,Label__c,KeyVariable__c from RS_Customer_Details__mdt where ObjectName__c=:objName AND RecordType__c=:recordTypeName order by KeyVariable__c');
            }
        }
        return metaData;
    }
    
    
    /**
* @description 
* @author  Accenture| 07-13-2022 
* @param recordId : Correspondigs record page id
* @return   List<HighlightPanelWrapper>  : list of Colorcodes and label on highlight panel
**/
    
    @AuraEnabled
    public static List<HighlightPanelWrapper> getAccountHighlightPanel(String recordId)
    {
        List<HighlightPanelWrapper> fieldWrapper = new List<HighlightPanelWrapper>();
        String recordTypeId;
        String fieldApiNames;
        list<String> fieldLabels = new List<String>();
        List<String> colorCodes = new List<String>();
        List<RS_Customer_Details__mdt> metaData = new List<RS_Customer_Details__mdt>();
        String objName=String.escapeSingleQuotes((Id.valueOf(recordId).getSObjectType().getDescribe().getName()));
        String accountId=String.escapeSingleQuotes(recordId);
        String queryString = 'SELECT Name, RecordTypeId FROM '+objName+' WHERE Id =:accountId';
        SObject recordTypeInfo = Database.query(queryString);
        recordTypeId = (String)recordTypeInfo.get('RecordTypeId');
        String recordTypeName=[Select name from RecordType where id=:recordTypeId]?.name;
        metaData = database.query('SELECT RS_HighlightPanelFields__c,HighlightPanelLabels__c,HighlightPanelColorCode__c	FROM RS_Customer_Details__mdt where ObjectName__c=:objName AND RecordType__c=:recordTypeName AND RS_HighlightPanelFields__c!=NULL');
        for(Integer i=0;i<metaData.size();i++)
        {
            fieldApiNames=String.isNotEmpty(fieldApiNames)?fieldApiNames+metaData[i].RS_HighlightPanelFields__c:metaData[i].RS_HighlightPanelFields__c;
            colorCodes=metaData[i].HighlightPanelColorCode__c.split(',');
            fieldLabels=metaData[i].HighlightPanelLabels__c.split(',');
        }
        fieldApiNames=String.escapeSingleQuotes(fieldApiNames);
        String obj ='Select '+fieldApiNames+ ' from '+objName+' Where id=:accountId';
        SObject accobj=database.query(String.escapeSingleQuotes(obj));
        String data = System.Json.serialize(accobj);
        Map<String,String> contactMap = (Map<String,String>)System.Json.deserialize(data.substringBefore('"attributes":{') + data.substringAfter('},'), Map<String,String>.class);
        Integer count=0;
        for(String key: contactMap.keySet())
        {
            if(contactMap.get(key)=='true')
            {
                HighlightPanelWrapper warpobj=new HighlightPanelWrapper(fieldLabels[count],colorCodes[count]);
                fieldWrapper.add(warpobj);
                count++;
            }
            else{
                count++;
            }
        }
        return fieldWrapper;
    }
    /**
* @description       :Wrapper Class 
* @author            : Accenture
* @group             : 
* @last modified on  : 03-23-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
    public class HighlightPanelWrapper{
        /**
* @description       :Field Label
* @author 
**/
        @AuraEnabled
        public String label{get;set;}
        
        /**
* @description :Color of the badge
* @author 
**/
        @AuraEnabled
        public string colorCode{get;set;}
              
           
    
    /**
* @description : Wrapper Output Class
* @author  Accenture| 07-13-2022 
* @param label : Account Field Label
* @param colorCode : Color of badge
**/
        public HighlightPanelWrapper(String label,String colorCode)
        {
            this.label=label;
            this.colorCode=colorCode;
        }
    }
}