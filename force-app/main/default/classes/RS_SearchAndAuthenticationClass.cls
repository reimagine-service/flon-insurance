public class RS_SearchAndAuthenticationClass {

    @InvocableMethod(label='Get Account Details')
    public static List<Account> getAccDetails(List<String> RecordId) {
        
        String InteractionId = String.valueOf(RecordId[0]);
        String ObjectCode = InteractionId.substring(0, 3);
        Id recId = String.valueOf(RecordId[0]);
        String objectName = recId.getSObjectType().getDescribe().getName();
        sObject records;
        String accID;
        
        RS_Search_and_Authentication__mdt SandAmdt = RS_Search_and_Authentication__mdt.getInstance(objectName);
            records = Database.query(String.escapeSingleQuotes(SandAmdt.Query__c) + ' where id=:recId');
            System.debug('Interaction records: '+records);
            accID = (String)records.get(SandAmdt.Account_Field_Name__c);
            
        List<Account> accounts = [SELECT Id, FirstName, LastName, AccountNumber, Phone, PersonEmail FROM Account where id =:accID];
        return accounts;
    }
}