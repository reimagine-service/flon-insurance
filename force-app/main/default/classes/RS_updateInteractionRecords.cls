public class RS_updateInteractionRecords {
    
    @InvocableMethod(label='Update Interaction Record')
    public static void UpdateRecords(List<InputForm> inputFormWrappers){
        Id recId = String.valueOf(inputFormWrappers[0].RecordId);
        String objectName = recId.getSObjectType().getDescribe().getName();
        String cust = inputFormWrappers[0].customerId;
        sObject records;
        
        RS_Search_and_Authentication__mdt SandAmdt = RS_Search_and_Authentication__mdt.getInstance(objectName);
        
        // Changed for optimization and removing reference of voice call and messaging session
        if(recId!=null && SandAmdt!=null){
            
            records = Database.query(String.escapeSingleQuotes(SandAmdt.Query__c) + ' where id=:recId');
            System.debug('Interaction records: '+records);
            //cust = (String)records.get(SandAmdt.Account_Field_Name__c);
            
            Account accRecord = new Account();
            if(Schema.getGlobalDescribe().get('Account').getDescribe().isAccessible()){
                accRecord = [Select id, PersonBirthdate, AccountNumber from Account where id =:cust WITH SECURITY_ENFORCED];
            }
            
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
            System.debug('updated records: '+records);
            }
           
        }
    }
    public class InputForm {
        @InvocableVariable
        public String customerId;
        @InvocableVariable
        public String RecordId;
    }

}