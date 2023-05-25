/**
 * @description       : Controller Class for RS_DynamicDatatable LWC
 * @author            : Accenture
 * @group             : 
 * @last modified on  : 03-24-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public without sharing class RS_DynamicLWCDataTableController {
    /**
    * @description 
    * @author Accenture | 03-13-2023 
    * @param label 
    * @param recordId 
    * @return DataTableResponse 
    **/
    @AuraEnabled(cacheable=true)
    public static DataTableResponse GetWrapperOfSObjectFieldColumnActionValues(String label,String recordId)
    {
        
        List<DataTableColumns> lstDataColumns            = new List<DataTableColumns>();
        List<SObject> lstDataTableData                   = new List<SObject>();
        List<string> columnList                          = new List<string>();
        List<string> fieldAPINameList                    = new List<string>();
        List<String> typeAttrList                        = new List<String>();
        List<String> typeList                            = new List<String>();
        String query;
        String field;
        String fieldOnLab;
        String strRecordId;
        RS_Dynamic_Datatable__mdt tableComponentMetadata;
        if(label != null && label != 'undefined'){
            if(Schema.getGlobalDescribe().get('RS_Dynamic_Datatable__mdt').getDescribe().isAccessible()){
                tableComponentMetadata = [SELECT Id,typeAttributes__c,type__c, Limit__c,Static_Field__c,Dynamic_Field__c, Field_Value__c, Header_Value__c,ObjectAPI_Name__c FROM RS_Dynamic_Datatable__mdt WHERE Label =: label WITH SECURITY_ENFORCED];
            }        
            if(tableComponentMetadata.Header_Value__c != null)
            {
                columnList = tableComponentMetadata.Header_Value__c.split(',');
            }
            
            if(tableComponentMetadata.Field_Value__c != null)
            {
                fieldAPINameList = tableComponentMetadata.Field_Value__c.split(',');
            }
            
            if(tableComponentMetadata.typeAttributes__c !=null){
                
                typeAttrList = tableComponentMetadata.typeAttributes__c.split('@');  
                //typeAttrList = tableComponentMetadata.typeAttributes__c.split('¬');
               
            } 
            if(tableComponentMetadata.type__c !=null){
                typeList = tableComponentMetadata.type__c.split(',');
                
            }  
            for(integer i = 0; i < columnList.size(); i++)
            {   
                String typeAttr='';
                String typeCol='';
                String fieldApi = fieldAPINameList[i].substringBefore(':').trim() ; 
                String fieldApilst;             
                
                String typeNewList ='';
                if(typeList.size() > 0){
                    typeNewList = typeList[i].trim();
                }
                
               if(tableComponentMetadata.type__c == 'url'){
                    //typeCol = fieldAPINameList[i];
                    string x = columnList[i].trim();                     
                    fieldApi = x +'Id';                    
                    
                    field = fieldApi;                
                    fieldOnLab = fieldAPINameList[i]; 
                    
                }              
                if(typeAttrList.size() > 0){
                    typeAttr = typeAttrList[i].trim();
                      
                }
                
                DataTableColTypeAttribute typeAttributes;    
                if(String.isNotBlank(typeAttr)){
                    typeAttributes = (DataTableColTypeAttribute)System.JSON.deserialize(typeAttr,DataTableColTypeAttribute.Class);}
                else{
                    typeAttributes = new DataTableColTypeAttribute(); }
                DataTableColumns datacolumns = new DataTableColumns( columnList[i].trim() , 
                                                                    fieldApi,
                                                                    typeNewList,
                                                                    typeAttributes);
                
                lstDataColumns.add(datacolumns);
                
            }
            
            if(tableComponentMetadata.ObjectAPI_Name__c == 'EmailMessage' ){
                strRecordId = ' Parent.id';
            } else if(tableComponentMetadata.ObjectAPI_Name__c == 'LiveChatTranscript'){ 
                strRecordId = ' case.id ';
            } else if(tableComponentMetadata.ObjectAPI_Name__c == 'Case'){   // case records handling
                strRecordId = ' id ';
                
            }else if(tableComponentMetadata.ObjectAPI_Name__c == 'MessagingSession') {
                strRecordId = ' case.id ';
            }
            else if(tableComponentMetadata.ObjectAPI_Name__c == 'RSI_Insurance_Policy__c') {
                strRecordId = ' RSI_Policy_Holder__r.id ';
            }else if(tableComponentMetadata.ObjectAPI_Name__c == 'AssignedResource') {
                strRecordId = ' ServiceAppointment.RS_Account__c ';
            }
            else{
                strRecordId = ' RelatedRecord.id ';            
            } 
            
            String fields = String.join(fieldAPINameList,',');
            String queryobjectName=String.escapeSingleQuotes(tableComponentMetadata.ObjectAPI_Name__c);
            if(strRecordId != null){
                strRecordId=String.escapeSingleQuotes(strRecordId);
                query = 'Select ' +  fields + ','+ strRecordId + ' FROM ' + queryobjectName; 
                
            }
            String dynamicField=String.escapeSingleQuotes( tableComponentMetadata.Dynamic_Field__c);
            String limitString =String.escapeSingleQuotes(tableComponentMetadata.Limit__c);
            recordId=String.escapeSingleQuotes(recordId);
            if(tableComponentMetadata.Static_Field__c !=null){
                String staticField=tableComponentMetadata.Static_Field__c;
                String a = (query +' where '+ dynamicField +' = '+ +'\''+ recordId +'\'' +' and '+ tableComponentMetadata.Static_Field__c +' order by CreatedDate desc Limit '+ limitString  );
                String queryeee = 'Select ' +  String.escapeSingleQuotes(fields) + ','+ String.escapeSingleQuotes(strRecordId) + ' FROM ' + String.escapeSingleQuotes(queryobjectName) +' where '+ String.escapeSingleQuotes(dynamicField) +' = '+ +'\''+ String.escapeSingleQuotes(recordId) +'\'' +' and '+ staticField +' order by CreatedDate desc Limit '+ limitString;
                
                
                for(SObject SObjectItem : Database.query('Select ' +  String.escapeSingleQuotes(fields) + ','+ String.escapeSingleQuotes(strRecordId) + ' FROM ' + String.escapeSingleQuotes(queryobjectName) +' where '+ String.escapeSingleQuotes(dynamicField) +' = '+ +'\''+ String.escapeSingleQuotes(recordId) +'\'' +' and '+ staticField +' order by CreatedDate desc Limit '+ limitString))
                {  

                    lstDataTableData.add(SObjectItem);
                }
            }  else{               
                String a = (query +' where '+ dynamicField +' = '+  +'\''+ recordId +'\' '  +' order by CreatedDate desc Limit '+ limitString );            
                 
                for(SObject SObjectItem : Database.query('Select ' +  String.escapeSingleQuotes(fields) + ','+ String.escapeSingleQuotes(strRecordId) + ' FROM ' + String.escapeSingleQuotes(queryobjectName) +' where '+ String.escapeSingleQuotes(dynamicField) +' = '+  +'\''+ String.escapeSingleQuotes(recordId) +'\' '  +' order by CreatedDate desc Limit '+ limitString))  {                
                    lstDataTableData.add(SObjectItem);
                }
            }
        }
        
         

        DataTableResponse finalWrapper   = new DataTableResponse();
        //finalWrapper.TableTitle          = tableComponentMetadata.Table_Title__c;
        finalWrapper.lstDataTableColumns = lstDataColumns;
        finalWrapper.lstDataTableData    = lstDataTableData;
        return  finalWrapper;
    }
    /**
    * @description : Wrapper Class to Store the Mapping of required parameters
    * @author Accenture | 03-13-2023 
    **/
    public class DataTableColumns {
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled       
        public String fieldName {get;set;}
        @AuraEnabled
        public String type {get;set;}
        @AuraEnabled
        public DataTableColTypeAttribute typeAttributes {get;set;}
        
        
        /**
        * @description 
        * @author Accenture | 03-13-2023 
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
     /**
    * @description : Used as a parameter in upper inner wrapper class
    * @author Accenture | 03-13-2023 
    **/
    Public Class DataTableColTypeAttribute
    {
        @AuraEnabled
        public String target {get;set;}
        @AuraEnabled       
        public Boolean sortable{get;set;}
        @AuraEnabled
        public DataTableColTypeAttributeLabel label{get;set;}
    }
    /**
    * @description : Used as a parameter in DataTableColTypeAttribute
    * @author Accenture | 03-13-2023 
    **/
    public class DataTableColTypeAttributeLabel 
    {
        @AuraEnabled
        public String fieldName {get;set;}
    }
    /**
    * @description : Wrapper used to send reponse to lwc
    * @author Accenture | 03-13-2023 
    **/
    public class DataTableResponse {
        @AuraEnabled
        public List<DataTableColumns> lstDataTableColumns {get;set;}
        @AuraEnabled
        public List<sObject> lstDataTableData {get;set;}
        @AuraEnabled
        public String TableTitle {get;set;}       
    }
}