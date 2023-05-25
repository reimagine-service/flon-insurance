/**
 * @description       : Controller for rsi_insuranceAgentDetailsOnPortal LWC
 * @author            : Accenture
 * @group             : 
 * @last modified on  : 03-24-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class RS_InsuranceDetailsPortalView {
    
    /**
    * @description 
    * @author Accenture | 03-13-2023 
    * @param userId 
    * @return List<User> 
    **/
    @AuraEnabled(cacheable=true)
    public static List<User> getInsuranceAgentDetails(Id userId){
        User accountId=[SELECT Id,ContactId,Name,Email FROM User WHERE id=:userId WITH SECURITY_ENFORCED];
        String contactId=accountId.ContactId;
        if(contactId!=null){
        Contact con=[select AccountId,Id from contact where id=:contactId WITH SECURITY_ENFORCED];
        Account acc = [select RSI_Insurance_Agent__c,Id from Account where Id =:con.AccountId WITH SECURITY_ENFORCED];
        List<User> insuranceUserDetails=[select Id,Name,email,address,phone,RSI_Name__c,SmallPhotoUrl,FullPhotoUrl  from user where Id=:acc.RSI_Insurance_Agent__c WITH SECURITY_ENFORCED];
        return insuranceUserDetails;
        }
        return null;
    }

}