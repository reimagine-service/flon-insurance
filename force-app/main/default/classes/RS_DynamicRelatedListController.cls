/**
* @description       : Controller Class for RS_DynamicRelatedListLWC
* @author            : Accenture
* @group             : 
* @last modified on  : 03-23-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class RS_DynamicRelatedListController {
    /**
* @description : Method used to fetch the related list records from any record
* @author  Accenture| 03-08-2023 
* @param tableName : Table Name
* @param recordId : Current UI RecordId 
* @return  DataTableResponse  : Wrapper Object 
**/
    @AuraEnabled(cacheable=true)
    public static DataTableResponse getWrapperOfSObjectFieldColumnActionValues(String tableName,String recordId)
    {
        List<DataTableColumns> lstDataColumns            = new List<DataTableColumns>();
        List<SObject> lstDataTableData                   = new List<SObject>();
        List<string> fieldAPINameList                    = new List<string>();
        List<String> typeAttrList                        = new List<String>();
        String query;
        List<string> headerValuesList                    = new List<string>();
        List<String> typeList                            = new List<String>();
        String field;
        String fieldOnLab;
        
        rS_Dynamic_Datatable__mdt tableComponentMetadata = [SELECT Id,DeveloperName,typeAttributes__c,type__c,Field_Value__c,Header_Value__c,ObjectAPI_Name__c,Limit__c,Static_Field__c FROM rS_Dynamic_Datatable__mdt WHERE DeveloperName =: tableName WITH SECURITY_ENFORCED];
        if(tableComponentMetadata.Header_Value__c != null)
        {
            headerValuesList = tableComponentMetadata.Header_Value__c.split(',');
        }
        if(tableComponentMetadata.Field_Value__c != null)
        {
            fieldAPINameList = tableComponentMetadata.Field_Value__c.split(',');
        }
        if(tableComponentMetadata.typeAttributes__c !=null){
            typeAttrList = tableComponentMetadata.typeAttributes__c.split('@');  
        } 
        if(tableComponentMetadata.type__c !=null){
            typeList = tableComponentMetadata.type__c.split(',');
        }  
        
        for(integer i = 0; i < headerValuesList.size(); i++)
        {
            String typeAttr='';
            String typeCol='';
            String fieldApi = fieldAPINameList[i].substringBefore(':').trim();
            String typeNewList ='';
            if(typeList.size() > 0){
                typeNewList = typeList[i].trim();
            }
            if(tableComponentMetadata.type__c == 'url'){
                string x = headerValuesList[i].trim();                     
                fieldApi = x +'Id';                    
                field = fieldApi;                
                fieldOnLab = fieldAPINameList[i];             }
            if(typeAttrList.size() > 0){
                typeAttr = typeAttrList[i].trim();
            }
            DataTableColTypeAttribute typeAttributes;    
            if(String.isNotBlank(typeAttr)){
                typeAttributes = (DataTableColTypeAttribute)System.JSON.deserialize(typeAttr,DataTableColTypeAttribute.Class);}
            else{
                typeAttributes = new DataTableColTypeAttribute(); }
            
            
            DataTableColumns datacolumns = new DataTableColumns( headerValuesList[i].trim() , 
                                                                fieldApi, 
                                                                typeNewList,
                                                                typeAttributes);
            
            lstDataColumns.add(datacolumns);
        }
        //  String objName = Id.valueOf(recordId).getSObjectType().getDescribe().getName();
        /* Removed the Dependency of direct references of Interaction Channels**/
        String relatedAccID;
        if(recordId != null && recordId != 'undefined'){
            
            String objName = Id.valueOf(recordId).getSObjectType().getDescribe().getName(); 
            objName=tablename+'_'+objName;
            System.debug('objName'+objName);
            rS_Dynamic_Datatable__mdt getaccountdata= [Select Dynamic_Field__c,Field_Value__c,Static_Field__c,ObjectAPI_Name__c,Label from rS_Dynamic_Datatable__mdt where DeveloperName=:objName WITH SECURITY_ENFORCED];
            System.debug('Select '+String.escapeSingleQuotes(getaccountdata.Field_Value__c)+' From '+String.escapeSingleQuotes(getaccountdata.ObjectAPI_Name__c)+' Where '+String.escapeSingleQuotes(getaccountdata.Static_Field__c)+'='+  +'\''+ String.escapeSingleQuotes(recordId)+'\'');
            SObject getaccountIdQuery=Database.query('Select '+String.escapeSingleQuotes(getaccountdata.Field_Value__c)+' From '+String.escapeSingleQuotes(getaccountdata.ObjectAPI_Name__c)+' Where '+String.escapeSingleQuotes(getaccountdata.Static_Field__c)+'='+  +'\''+ String.escapeSingleQuotes(recordId)+'\'');
            relatedAccID=(String)getaccountIdQuery.get(getaccountdata.Dynamic_Field__c);
            system.debug('accountId'+relatedAccID);
            system.debug('getaccountIdQuery'+getaccountIdQuery);
            String fields = String.join(fieldAPINameList,',');
            String tableComponentObjectName=String.escapeSingleQuotes(tableComponentMetadata.ObjectAPI_Name__c);
            if(relatedAccID != null && relatedAccID.startsWith('001')){
                relatedAccID=String.escapeSingleQuotes(relatedAccID);
                for(SObject sObjectItem : Database.query('Select ' +  String.escapeSingleQuotes(fields)  + ' FROM ' + String.escapeSingleQuotes(tableComponentObjectName) +' where '+String.escapeSingleQuotes(tableComponentMetadata.Static_Field__c)+'='+ +'\''+ String.escapeSingleQuotes(relatedAccID) +'\''))
                {
                    lstDataTableData.add(sObjectItem);
                }
            }
        }
        DataTableResponse finalWrapper   = new DataTableResponse();
        finalWrapper.lstDataTableColumns = lstDataColumns;
        finalWrapper.lstDataTableData    = lstDataTableData;
        return finalWrapper;
        
    }
    /**
* @description       : Inner Wrapper Class 
* @author            : Accenture
* @group             : 
**/
    public class DataTableColumns {
        /**
* @description       : Label
* @author            : Accenture
**/
        @AuraEnabled
        public String label {get;set;}
        /**
* @description       : fieldName
* @author            : Accenture
**/
        @AuraEnabled       
        public String fieldName {get;set;}
        /**
* @description       : type
* @author            : Accenture
**/
        @AuraEnabled
        public String type {get;set;}
        /**
* @description       : typeAttributes
* @author            : Accenture
**/
        @AuraEnabled
        public DataTableColTypeAttribute typeAttributes {get;set;}
        
        /**
* @description 
* @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-23-2023 
* @param label 
* @param fieldName 
* @param type 
* @param typeAttributes 
**/
        public DataTableColumns(String label, String fieldName, String type, DataTableColTypeAttribute typeAttributes)
        {
            this.label     = label;
            this.fieldName = fieldName;
            this.type      = type;    
            this.typeAttributes = typeAttributes;
        }
    }
    Public Class DataTableColTypeAttribute
    {
        @AuraEnabled
        public String target {get;set;}
        @AuraEnabled       
        public Boolean sortable{get;set;}
        @AuraEnabled
        public DataTableColTypeAttributeLabel label{get;set;}
    }
    public class DataTableColTypeAttributeLabel 
    {
        @AuraEnabled
        public String fieldName {get;set;}
    }
    /**
* @description       : Inner Wrapper Class for Inputs
* @author            : Accenture
* @group             : 
* @last modified on  : 03-23-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
    
    public class DataTableResponse {
        @AuraEnabled
        public List<DataTableColumns> lstDataTableColumns {get;set;}
        @AuraEnabled
        public List<sObject> lstDataTableData {get;set;}     
    }
}