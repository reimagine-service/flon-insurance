public class RS_SearchAndAuthenticateController {
    
    /**
    * @description 
    * @author Accenture | 03-13-2023 
    * @param firstname 
    * @param lastname 
    * @param accNumber 
    * @param emailId 
    * @param phoneNumber 
    * @param condition 
    * @return DataTableResponse 
    **/
    @AuraEnabled(cacheable=true)
    public static DataTableResponse getAccountList(String firstname, string lastname, String accNumber, string emailId,String phoneNumber,string condition){
        String qrystr;
        
        List<DataTableColumns> lstDataColumns            = new List<DataTableColumns>();
        List<SObject> lstDataTableData                   = new List<SObject>();
        List<string> columnList                          = new List<string>();
        List<string> fieldAPINameList                    = new List<string>();
        List<String> typeAttrList                        = new List<String>();
        String query;
        String field;
        String fieldOnLab;
        RS_Dynamic_Datatable__mdt tableComponentMetadata;
        if(Schema.getGlobalDescribe().get('RS_Dynamic_Datatable__mdt').getDescribe().isAccessible()){
            tableComponentMetadata = [SELECT Id, Field_Value__c, Header_Value__c,ObjectAPI_Name__c,typeAttributes__c FROM RS_Dynamic_Datatable__mdt WHERE Label = 'Account List' WITH SECURITY_ENFORCED];
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
            typeAttrList = tableComponentMetadata.typeAttributes__c.split('-');
        }
        
        
        for(integer i = 0; i < columnList.size(); i++)
        {
            String typeAttr='';
            String typeCol='';
            String fieldApi = fieldAPINameList[i].substringBefore(':').trim();
            if(typeAttrList.size() > 0 && fieldAPINameList[i].contains(typeAttrList[0])){
                typeAttr = typeAttrList[1];
            }   
            if(fieldAPINameList[i].contains(':')){
                typeCol = fieldAPINameList[i].split(':')[1];
                fieldAPINameList[i] = fieldAPINameList[i].split(':')[0];
                
                if(typeCol.equalsIgnoreCase('url')){
                    string x = columnList[i].trim();
                    fieldApi = x +'Id'; 
                    field = fieldApi;
                    fieldOnLab = fieldAPINameList[i]; 
                }
            }
            DataTableColTypeAttribute typeAttributes;
            if(String.isNotBlank(typeAttr)){
                typeAttributes = (DataTableColTypeAttribute)System.JSON.deserialize(typeAttr,DataTableColTypeAttribute.Class);}
            else{
                typeAttributes = new DataTableColTypeAttribute();}
            
            DataTableColumns datacolumns = new DataTableColumns( columnList[i].trim() , 
                                                                fieldApi, 
                                                                typeCol,
                                                                typeAttributes);
            
            lstDataColumns.add(datacolumns);
        }
        String fields = String.join(fieldAPINameList,',');
        String objName=String.escapeSingleQuotes(TableComponentMetadata.ObjectAPI_Name__c);
        query = 'Select ' +  fields + ' FROM ' + objName; 
        
        String filterCondition;
        if(condition == 'AND'){
            filterCondition = (String.isNotBlank(firstname) ? 'FirstName ='+ +'\''+ String.escapeSingleQuotes(firstname) +'\'' : '');
            filterCondition += (String.isNotBlank(lastname) ? (String.isNotBlank(filterCondition) ? +' AND ' : '') + ' LastName ='+ +'\''+ String.escapeSingleQuotes(lastname) +'\'' : '');
            filterCondition += (String.isNotBlank(accNumber) ? (String.isNotBlank(filterCondition) ? +' AND ' : '') + ' AccountNumber ='+ +'\''+ String.escapeSingleQuotes(accNumber) +'\'' : '');
            filterCondition += (String.isNotBlank(emailId) ? (String.isNotBlank(filterCondition) ? +' AND ' : '') + ' PersonEmail ='+ +'\''+ String.escapeSingleQuotes(emailId) +'\'' : '');
            filterCondition += (String.isNotBlank(phoneNumber) ? (String.isNotBlank(filterCondition) ? +' AND ' : '') + ' Phone ='+ +'\''+ String.escapeSingleQuotes(phoneNumber) +'\'' : '');
        }
        if(condition == 'OR'){
            filterCondition = (String.isNotBlank(firstname) ? 'FirstName ='+ +'\''+ String.escapeSingleQuotes(firstname) +'\'' : '');
            filterCondition += (String.isNotBlank(lastname) ? (String.isNotBlank(filterCondition) ? +' OR ' : '') + ' LastName ='+ +'\''+ String.escapeSingleQuotes(lastname) +'\'' : '');
            filterCondition += (String.isNotBlank(accNumber) ? (String.isNotBlank(filterCondition) ? +' OR ' : '') + ' AccountNumber ='+ +'\''+ String.escapeSingleQuotes(accNumber) +'\'' : '');
            filterCondition += (String.isNotBlank(emailId) ? (String.isNotBlank(filterCondition) ? +' OR ' : '') + ' PersonEmail ='+ +'\''+ String.escapeSingleQuotes(emailId) +'\'' : '');
            filterCondition += (String.isNotBlank(phoneNumber) ? (String.isNotBlank(filterCondition) ? +' OR ' : '') + ' Phone ='+ +'\''+ String.escapeSingleQuotes(phoneNumber) +'\'' : '');
        }
        
        
        if (String.isNotBlank(filterCondition)) {
            
            
            for(SObject SObjectItem : Database.query('Select ' +  String.escapeSingleQuotes(fields) + ' FROM ' + String.escapeSingleQuotes(objName) +' where '+ filterCondition))
            {
                lstDataTableData.add(SObjectItem);
            }
        } else {
            for(SObject SObjectItem : Database.query('Select ' +  String.escapeSingleQuotes(fields) + ' FROM ' + String.escapeSingleQuotes(objName)))
            {
                lstDataTableData.add(SObjectItem);
            }
        }
        
        DataTableResponse finalWrapper   = new DataTableResponse();
        finalWrapper.lstDataTableColumns = lstDataColumns;
        finalWrapper.lstDataTableData    = lstDataTableData;
        return  finalWrapper;
        
    } 
    
    /**
    * @description 
    * @author Accenture | 03-13-2023 
    * @param custId 
    * @param interactionId 
    **/
    @AuraEnabled
    public static void verifyCustomer(Id custId, Id interactionId){
        String objId = String.valueOf(interactionId);
        String interaction = String.escapeSingleQuotes(interactionId);
        String cust = String.escapeSingleQuotes(custId);
        String ObjectCode = objId.substring(0, 3);
        String objectName = interactionId.getSObjectType().getDescribe().getName();
        sObject records;
        
        RS_Search_and_Authentication__mdt SandAmdt = RS_Search_and_Authentication__mdt.getInstance(objectName);
        
        Account accRecord = new Account();
        if(Schema.getGlobalDescribe().get('Account').getDescribe().isAccessible()){
            accRecord = [Select id, PersonBirthdate, AccountNumber from Account where id =:cust WITH SECURITY_ENFORCED];
        }
        // Changed for optimization and removing reference of voice call and messaging session
        if(custId!=null && SandAmdt!=null){
            
            records = Database.query(String.escapeSingleQuotes(SandAmdt.Query__c) + ' where id=:interactionId');
            System.debug('Interaction records: '+records);
            //accID = (String)records.get(SandAmdt.Account_Field_Name__c);
            if(SandAmdt.Customer_Verified_field_name__c!=null){
            records.put(SandAmdt.Customer_Verified_field_name__c, true);
            }
            if(SandAmdt.customer_Identified_field_name__c!=null){
            records.put(SandAmdt.customer_Identified_field_name__c, true);
            }
            if(SandAmdt.Customer_DOB_field__c!=null){
            records.put(SandAmdt.Customer_DOB_field__c, accRecord.PersonBirthdate);
            }
            if(SandAmdt.Account_Field_Name__c!=null){
            records.put(SandAmdt.Account_Field_Name__c, accRecord.Id );
            }
            if(SandAmdt.customer_account_number__c!=null){
            records.put(SandAmdt.customer_account_number__c, accRecord.AccountNumber);
            }
            
            if(Schema.getGlobalDescribe().get(objectName).getDescribe().isUpdateable()) {
				update records; 
			}
            
            
            /*
            List<VoiceCall> listVC= New List<VoiceCall>();
            if(objId.startsWith('0LQ')){
                VoiceCall vcObj = new VoiceCall();
                if(Schema.getGlobalDescribe().get('VoiceCall').getDescribe().isAccessible()){    
                    vcObj = [Select id, RS_Customer_Identified__c, RS_CustomerVerified__c, Related_Account__c, RS_CustomerAccountNumber__c, RS_DateOfBirth__c,CallType,RS_Previous_Call__r.Related_Account__c,RS_Previous_Call__r.RS_Previous_Call__r.Related_Account__c from VoiceCall where id =:interaction WITH SECURITY_ENFORCED];
                }
                vcObj.RS_Customer_Identified__c = true;
                vcObj.RS_CustomerVerified__c = true;
                vcObj.Related_Account__c = accRecord.Id;
                vcObj.RS_CustomerAccountNumber__c = accRecord.AccountNumber;
                vcObj.RS_DateOfBirth__c = accRecord.PersonBirthdate;
                listVC.add(vcObj);
                VoiceCall vcObj2 = new VoiceCall(Id=vcObj.RS_Previous_Call__r.Id);
                if(vcObj.CallType=='Callback' && vcObj.RS_Previous_Call__c!=NULL){
                    //if(vcObj.RS_Previous_Call__c!=NULL){
                        vcObj2.Related_Account__c=accRecord.Id;
                        vcObj2.RS_CustomerVerified__c = true;
                        vcObj2.RS_CustomerAccountNumber__c = accRecord.AccountNumber;
                        vcObj2.RS_DateOfBirth__c = accRecord.PersonBirthdate;
                        vcObj2.RS_Customer_Identified__c=true;
                        VoiceCall vcObj3 = new VoiceCall(Id=vcObj.RS_Previous_Call__r.RS_Previous_Call__r.Id);
                        vcObj3.Related_Account__c=accRecord.Id;
                        vcObj3.RS_CustomerVerified__c = true;
                        vcObj3.RS_CustomerAccountNumber__c = accRecord.AccountNumber;
                        vcObj3.RS_DateOfBirth__c = accRecord.PersonBirthdate;
                        vcObj3.RS_Customer_Identified__c=true;
                        listVC.add(vcObj2);
                        listVC.add(vcObj3);
                        
                   // }
                }
                else if(vcObj.CallType=='Transfer' && vcObj.RS_Previous_Call__c!=NULL){
                   // if(vcObj.RS_Previous_Call__c!=NULL){
                        vcObj2.Related_Account__c=accRecord.Id;
                        vcObj2.RS_CustomerVerified__c = true;
                        vcObj2.RS_CustomerAccountNumber__c = accRecord.AccountNumber;
                        vcObj2.RS_DateOfBirth__c = accRecord.PersonBirthdate;
                        vcObj2.RS_Customer_Identified__c=true;
                        listVC.add(vcObj2);
                    //}
                    
                }
                if(Schema.getGlobalDescribe().get('VoiceCall').getDescribe().isUpdateable()){   
                    update listVC;
                }
            }else if(objId.startsWith('0Mw')){
                MessagingSession msObj = new MessagingSession();
                if(Schema.getGlobalDescribe().get('MessagingSession').getDescribe().isAccessible()){   
                    msObj = [Select id, RS_Customer_authenticated__c, RS_Customer_verified__c, Related_Account__c, RS_Customer_Account_Number__c, RS_DateOfBirth__c from MessagingSession where id =:interaction WITH SECURITY_ENFORCED];
                }
                msObj.RS_Customer_authenticated__c = true;
                msObj.RS_Customer_verified__c = true;
                msObj.Related_Account__c = accRecord.Id;
                msObj.RS_Customer_Account_Number__c = accRecord.AccountNumber;
                msObj.RS_DateOfBirth__c = accRecord.PersonBirthdate;
                if(Schema.getGlobalDescribe().get('MessagingSession').getDescribe().isUpdateable()){   
                    update msObj;
                }
            }*/
        }
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