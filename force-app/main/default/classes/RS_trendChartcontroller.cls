/**
* @Description       : This class is used to list down all the  sentiments corresponding to a Case 
* @Author            : Accenture
* @Last modified on  : 03-24-2023
* @Last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class RS_trendChartcontroller {
    /**
    * @description :This method is used to list down all the  sentiments corresponding to a Case 
    * @author Accenture | 03-24-2023 
    * @param caseId 
    * @return List<Sentiment_Score__c> 
    **/
  @AuraEnabled(cacheable=true)
    public static List<Sentiment_Score__c> getSentimentsById(String caseId){
        List<Sentiment_Score__c> sentiments = new List<Sentiment_Score__c>();
        
        if(Schema.getGlobalDescribe().get('Sentiment_Score__c').getDescribe().isAccessible()) {
        sentiments =  [SELECT Case__r.id,sentiment_value__c,Customer_Sentiments__c,Conversation_Channel__c,Case__r.Casenumber,Case__r.Status,  LastModifiedDate from Sentiment_Score__c where Case__r.Id=: caseId WITH SECURITY_ENFORCED ORDER BY LastModifiedDate];
        }
        return sentiments;
    }
    /**
    * @description : This class is used to list down all the  sentiments corresponding to a Account 
    * @author Accenture | 03-24-2023 
    * @param accountId 
    * @param tabDetails 
    * @return List<Sentiment_Score__c> 
    **/
    @AuraEnabled(cacheable=true)
    public static List<Sentiment_Score__c> getSentimentsByIdForAccount(String accountId,String tabDetails){
        List<Sentiment_Score__c> sentimentList = new List<Sentiment_Score__c>();
        List<Case> caseList = new List<Case>();
        String strWhereCondition='';
        List<rS_Dynamic_Datatable__mdt> dataTableMetaData = getObjectDetails(tabDetails);
        String recAccountId=String.escapeSingleQuotes(accountId);
        String strTabName = JSON.serialize(dataTableMetaData.get(0).get('DeveloperName'));
        String strTabNameFinal = strTabName.substringAfter('_');
        strTabNameFinal = strTabNameFinal.replace('_', ' ');
        strTabNameFinal = strTabNameFinal.replace('"', '');
        if(dataTableMetaData.get(0).get('ObjectAPI_Name__c') == 'Sentiment_Score__c'){ 
            strWhereCondition = ' where Case__r.accountid= ';
        }
        String sentiList = 'SELECT Case__r.id,Case__r.Type,sentiment_value__c,Customer_Sentiments__c,Case__r.Casenumber,Case__r.Status,LastModifiedDate from ' + dataTableMetaData.get(0).get('ObjectAPI_Name__c') + String.escapeSingleQuotes(strWhereCondition) + '\'' + String.escapeSingleQuotes(recAccountId) + '\'' + ' and CreatedDate = LAST_N_DAYS: ' +  dataTableMetaData.get(0).get('RS_LastNDays__c') + ' ORDER BY LastModifiedDate';
        sentimentList =  Database.query('SELECT Case__r.id,Case__r.Type,sentiment_value__c,Customer_Sentiments__c,Case__r.Casenumber,Case__r.Status,LastModifiedDate from ' + dataTableMetaData.get(0).get('ObjectAPI_Name__c') + String.escapeSingleQuotes(strWhereCondition) + '\'' + String.escapeSingleQuotes(recAccountId) + '\'' + ' and CreatedDate = LAST_N_DAYS: ' +  dataTableMetaData.get(0).get('RS_LastNDays__c') + ' ORDER BY LastModifiedDate');
        return sentimentList;
    }
    
    /**
    * @description : Get Selected Object Details
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-24-2023 
    * @param TabObjectDetails 
    * @return List<rS_Dynamic_Datatable__mdt> 
    **/
     @AuraEnabled
    public static List<rS_Dynamic_Datatable__mdt> getObjectDetails(String tabObjectDetails){
        String sObjectString = 'rS_Dynamic_Datatable__mdt'; // Metadata object name for configuration
        String fieldString = 'ObjectAPI_Name__c,RS_LastNDays__c,DeveloperName '; // Selected aggregated query details 
        String strwhereConidtion = '  where MasterLabel=';
        String strMasterLabel = String.escapeSingleQuotes(tabObjectDetails);
        String strSOQL = 'SELECT ' + fieldString + ' FROM ' + sObjectString + strwhereConidtion + '\'' + strMasterLabel + '\'';
        List<rS_Dynamic_Datatable__mdt> dataTableMetaData = Database.query(strSOQL);
        return dataTableMetaData;
    }
}