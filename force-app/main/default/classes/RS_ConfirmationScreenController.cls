/**
* @description       : 
* @author            : Accenture
* @group             : 
* @last modified on  : 07-13-2022
* @last modified by  : Accenture
**/

public with sharing class RS_ConfirmationScreenController {
    
    /**
* @description 
* @author  Accenture| 07-13-2022 
* @param tableName : Name of the table
* @return  String  : Comma separated field values
**/
    @AuraEnabled(cacheable=true)
    public static String getCaseFields(String tableName){
        RS_Dynamic_Datatable__mdt tableComponentMetadata;
        if(Schema.getGlobalDescribe().get('RS_Dynamic_Datatable__mdt').getDescribe().isAccessible()) { 
            tableComponentMetadata = [SELECT Id, DeveloperName, Limit__c, Field_Value__c, Header_Value__c, Query__c, Table_Title__c FROM RS_Dynamic_Datatable__mdt WHERE DeveloperName =:TableName WITH SECURITY_ENFORCED];
        }
        String fieldvalues = tableComponentMetadata.Field_Value__c;
        return fieldvalues;
    }
}