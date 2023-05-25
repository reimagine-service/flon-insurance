/**
* @description       : Controller Class for rS_BestTimeToCall LWC. 
* @author            : Accenture
* @last modified on  : 03-23-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with Sharing class RS_BestTimeToCallController {
    
/**
* @description : Get Meta Records
* @author  Accenture| 03-08-2023
* @param accountId : Customer AccountId
* @param issueType : Case Issue Type
* @param month     : Month 
* @return   List<BestTimeToCall__x>  : retruns the list of BestTimeToCall__x based on input params
**/
    @AuraEnabled
    public static  List<BestTimeToCall__x> getbesttimecalldetails(String accountId,String issueType,String month){
        Map<String,BestTimeToCall__x> details=new  Map<String,BestTimeToCall__x>();
        String accountnumber=[Select AccountNumber from Account where id=:accountId]?.AccountNumber;
        List<BestTimeToCall__x> getdetails= ObjectManager.records([Select Afternoon__c,Morning__c,Evening__c,DayOfWeek__c from BestTimeToCall__x 
                                                                   where Month__c=:month and IssueType__c =:issueType and AccountNumber__c=:accountnumber]);
        return getdetails;
    }
    /**
* @description : Get Meta Records 
* @author  Accenture| 03-08-2023
* @return   List<Next_Best_Action__mdt>  : retruns the list of Next_Best_Action__mdt records
**/
    @AuraEnabled
    public static  List<Next_Best_Action__mdt> getBTTCmetaDetail(){
        
        List<Next_Best_Action__mdt> bttcMdt = Next_Best_Action__mdt.getAll().values();
        return bttcMdt;
    }
    @AuraEnabled(cacheable=true)
    public static DataTableResponse getWrapperOfSObjectFieldColumnActionValues(String tableName,String accountId,String issueType,String month)
    {
        List<DataTableColumns> lstDataColumns            = new List<DataTableColumns>();
        List<SObject> lstDataTableData                   = new List<SObject>();
        List<string> columnList                          = new List<string>();
        List<string> fieldAPINameList                    = new List<string>();
        String strRecordId;
        String query;
        List<string> headerValuesList                    = new List<string>();
        Next_Best_Action__mdt tableComponentMetadata = [SELECT Id, DeveloperName, Field_Value__c,Header_Value__c,ObjectAPI_Name__c,Month__c,CaseIssueType__c, Limit__c FROM Next_Best_Action__mdt WHERE DeveloperName =: tableName WITH SECURITY_ENFORCED];
        list<RIS_BTTC_TimeSlots_Dev__x> listtimeSlot = [select Id__c,SlotName__c,StartTime__c,EndTime__c from RIS_BTTC_TimeSlots_Dev__x WITH SECURITY_ENFORCED];
        if(tableComponentMetadata.Header_Value__c != null)
        {
            headerValuesList = tableComponentMetadata.Header_Value__c.split(',');
        }
        columnList.add(month);
        for(integer j = listtimeSlot.size(); j > 0; j--){
            String valuetoadd=listtimeSlot[j-1].SlotName__c+ '\n' +'('+listtimeSlot[j-1].StartTime__c+' '+'-'+' '+listtimeSlot[j-1].EndTime__c+')';
            columnList.add(valuetoadd);
        }
        if(tableComponentMetadata.Field_Value__c != null)
        {
            fieldAPINameList = tableComponentMetadata.Field_Value__c.split(',');
        }
        String fields = String.join(fieldAPINameList,',');
        for(integer i = 0; i < columnList.size(); i++)
        {
            
            DataTableColumns datacolumns = new DataTableColumns( columnList[i].trim() , 
                                                                fieldAPINameList[i].substringBefore(':').trim(), 
                                                                fieldAPINameList[i].substringAfter(':').trim());
            
            lstDataColumns.add(datacolumns);
        }
        String accountnumber=[Select AccountNumber from Account where id=:accountId]?.AccountNumber;
        String tableComponentObjectName=String.escapeSingleQuotes(tableComponentMetadata.ObjectAPI_Name__c);
        String tableComponentLimit=String.escapeSingleQuotes(tableComponentMetadata.Limit__c);
        if(accountnumber != null){
           // query = 'Select ' +  fields  + ' FROM ' + tableComponentObjectName; 
        
        
        //String a = 'Select ' +  fields  + ' FROM ' + tableComponentObjectName +' where AccountNumber__c = '+ +'\''+ accountnumber +'\''+' and '+' Month__c = '+ +'\''+ month +'\''+' and '+' IssueType__c = '+ +'\''+ issueType +'\''+' Limit '+ tableComponentLimit ;
        for(SObject sObjectItem : Database.query('Select ' +  String.escapeSingleQuotes(fields)  + ' FROM ' + String.escapeSingleQuotes(tableComponentObjectName) +' where AccountNumber__c = '+ +'\''+ String.escapeSingleQuotes(accountnumber) +'\''+' and '+' Month__c = '+ +'\''+ String.escapeSingleQuotes(month) +'\''+' and '+' IssueType__c = '+ +'\''+ String.escapeSingleQuotes(issueType) +'\''+' Limit '+ String.escapeSingleQuotes(tableComponentLimit)))
        {
            lstDataTableData.add(sObjectItem);
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
* @last modified on  : 03-23-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
    
    public class DataTableColumns {
        /**
* @description       : Datatable Label
**/
        @AuraEnabled
        public String label {get;set;}
/**
* @description       : FieldName
**/
        @AuraEnabled       
        public String fieldName {get;set;}
         /*Case Issue Type Lable*/
        @AuraEnabled
        public String type {get;set;}
        
        /**
        * @description 
        * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-09-2023 
        * @param label 
        * @param fieldName 
        * @param type 
        **/
        public DataTableColumns(String label, String fieldName, String type)
        {
            this.label     = label;
            this.fieldName = fieldName;
            this.type      = type;          
        }
    }
               /**
* @description       : Inner Wrapper Class to Return Output
**/
    public class DataTableResponse {
        @AuraEnabled
        public List<DataTableColumns> lstDataTableColumns {get;set;}
        @AuraEnabled
        public List<sObject> lstDataTableData {get;set;}     
    }
/**
* @description : Get List of Months
* @author  Accenture| 03-08-2023
* @return   List<String>  : retruns the list of Month Names
**/
    @AuraEnabled(cacheable=true)
    public static List<String> getPicklistValuesForMonth(){
        List<String> pickListValues = new List<String>();
        Schema.DescribeFieldResult pickList = Next_Best_Action__mdt.Month__c.getDescribe();
        for( Schema.PicklistEntry pickVal : pickList.getPicklistValues()){
            pickListValues.add(pickVal.getValue());
        }   
        return pickListValues;
    }

        /**
* @description : Get Case Type Picklist Values
* @author  Accenture| 03-08-2023
* @return   List<String>  : retruns the list of Case Issue Types Names
**/
    @AuraEnabled(cacheable=true)
    public static List<String> getPicklistValuesForIssueType(){
        List<String> pickListValues = new List<String>();
        Schema.DescribeFieldResult pickList = Next_Best_Action__mdt.CaseIssueType__c.getDescribe();
        for( Schema.PicklistEntry pickVal : pickList.getPicklistValues()){
            
            pickListValues.add(pickVal.getValue());
        }   
        return pickListValues;
    }
    
}