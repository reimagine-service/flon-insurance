/**
* @description       : Custom controller for RS_CustomerProfileRelatedList
* @author            : Accenture
* @group             : 
* @last modified on  : 03-13-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

public with sharing class RS_CustomerProfileChartController {
    
        /**
	* @description 
	* @author  Accenture| 07-13-2022 
	* @param accountId : Corresponding AccountId
	* @param tabDetails
	* @return   List<AggregateResult>
	**/
    
    @AuraEnabled(cacheable=true)
    public static List<AggregateResult> getAggregateRecordsByAccountId(String accountId, String tabDetails){
        String strWhereCondition='';
        List<rS_Dynamic_Datatable__mdt> dataTableMetaData = getObjectDetails(tabDetails);
        String recAccountId=String.escapeSingleQuotes(accountId);
        String strTabName = JSON.serialize(dataTableMetaData.get(0).get('DeveloperName'));
        String strTabNameFinal = strTabName.substringAfter('_');
        strTabNameFinal = strTabNameFinal.replace('_', ' ');
        strTabNameFinal = strTabNameFinal.replace('"', '');
         if(strTabNameFinal == 'Account Information'){
            strTabNameFinal = 'Account Information Update';
        }
        if(strTabNameFinal == 'Incorrect Invoice'){
            strTabNameFinal = 'Incorrect Invoicing';
        }


        
        if(dataTableMetaData.get(0).get('ObjectAPI_Name__c') == 'EmailMessage'){
            strWhereCondition = ' where Parent.Account.id= ';
        } else if(dataTableMetaData.get(0).get('ObjectAPI_Name__c') == 'LiveChatTranscript'){ 
            strWhereCondition = ' where Case.Account.id= ';
        }else if(dataTableMetaData.get(0).get('ObjectAPI_Name__c') == 'AssignedResource') {
             if(tabDetails.substringAfter(':')=='SME_Assistance' || tabDetails.substringAfter(':')=='Incorrect_Invoice' || tabDetails.substringAfter(':')=='Renewals'){
                strWhereCondition = ' where ServiceAppointment.WorkType.Name= '+ '\'' + strTabNameFinal + '\'' +' and ServiceAppointment.RS_Account__c= ';
            }else if(tabDetails.substringAfter(':')=='Upcoming_Appointments'){
                strWhereCondition = ' where ServiceAppointment.Status= '+ '\'' + 'Scheduled' + '\'' +' and ServiceAppointment.RS_Account__c= ';
            }else if(tabDetails.substringAfter(':')=='Past_Appointments'){
                strWhereCondition = ' where ServiceAppointment.Status= '+ '\'' + 'Closed' + '\'' +' and ServiceAppointment.RS_Account__c= ';
            }
            else{
               strWhereCondition = ' where ServiceAppointment.RS_Account__c= ';
            }
             
        } else if(dataTableMetaData.get(0).get('ObjectAPI_Name__c') == 'Case'){   // case records handling
            if(tabDetails.substringAfter(':')<>'All_Cases'){
                strWhereCondition = ' where type= '+ '\'' + strTabNameFinal + '\'' +' and Account.id= ';
            } else{
                strWhereCondition = ' where Account.id= ';
            }
        } else {
            strWhereCondition = ' where Related_Account__r.id= ';            
        }
       String dataTableObjectName=String.escapeSingleQuotes(String.valueOf((dataTableMetaData.get(0).get('ObjectAPI_Name__c'))));
       String dataTableLimit=String.escapeSingleQuotes(String.valueOf((dataTableMetaData.get(0).get('RS_LastNDays__c'))));
        String strSOQL = 'SELECT DAY_ONLY(CreatedDate) CRDATE,Count(id) Total from ' + dataTableObjectName + strWhereCondition + '\'' + recAccountId + '\'' + ' and CreatedDate = LAST_N_DAYS: ' +  dataTableLimit  + ' group by DAY_ONLY(CreatedDate) order by DAY_ONLY(CreatedDate)';
        
        List<AggregateResult> aggregateRecords =  Database.query(strSOQL);
        return aggregateRecords;
    }
    
            /**
	* @description 
	* @author  Accenture| 07-13-2022 
	* @param tabObjectDetails
	* @return  List<rS_Dynamic_Datatable__mdt>
	**/

    @AuraEnabled
    public static List<rS_Dynamic_Datatable__mdt> getObjectDetails(String tabObjectDetails){
        
        String sObjectString = String.escapeSingleQuotes('rS_Dynamic_Datatable__mdt'); // Metadata object name for configuration
        String fieldString = String.escapeSingleQuotes('ObjectAPI_Name__c,RS_LastNDays__c,DeveloperName '); // Selected aggregated query details 
        String strwhereConidtion = String.escapeSingleQuotes('  where MasterLabel=');
        String strMasterLabel = String.escapeSingleQuotes(tabObjectDetails);
        String strSOQL = 'SELECT ' + fieldString + ' FROM ' + sObjectString + strwhereConidtion + '\'' + strMasterLabel + '\'';
        List<rS_Dynamic_Datatable__mdt> dataTableMetaData = Database.query(strSOQL);
        return dataTableMetaData;
    }
}