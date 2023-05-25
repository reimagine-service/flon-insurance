/**
 * @description       : This class is used to get all the related case of the customer.
 * @author            : Accenture
 * @group             : 
 * @last modified on  : 03-24-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class RS_customerAllOpenCases {
    /**
    * @description this method is used to get all the related case of the customer.
    * @author Accenture | 04-29-2022 
    * @param recordId 
    * @param pageNumber 
    * @param pageSize 
    * @param Channel 
    * @return List<Case> 
    **/
    @AuraEnabled
    public static List<Case> allcases(String recordId,Integer pageNumber, Integer pageSize, String channel){
        String accID;
        String contactID;
        String relatedCaseID;
        sObject records;
        // Code below this is optimized to use for all channels based on metadata records
        if(channel!=null){
            RS_All_Open_Cases_on_Interaction__mdt interactionData = RS_All_Open_Cases_on_Interaction__mdt.getInstance(channel);
            records = Database.query(String.escapeSingleQuotes(interactionData.Query__c) + ' where id=:recordId WITH SECURITY_ENFORCED');
            System.debug('Interaction records: '+records);
            accID = (String)records.get(interactionData.Account_Field_Name__c);
            relatedCaseID = (String)records.get(interactionData.Related_Case_Field_Name__c);
            if(interactionData.Contact_Field_Name__c!=null){
                contactID = (String)records.get(interactionData.Contact_Field_Name__c);
            }
        }
       /* This code is commented out as it's dependent on channels
        if(channel =='SMS'){
            if(Schema.getGlobalDescribe().get('MessagingSession').getDescribe().isAccessible()) {
                List<MessagingSession> msList = new List<MessagingSession>();
                msList =[select Related_Account__c,EndUserContactId,caseID from MessagingSession where id=:recordId WITH SECURITY_ENFORCED];
                if(String.isEmpty(msList[0].Related_Account__c)){
                    accID = [Select AccountId  from contact where IsPersonAccount = true and id=:msList[0].EndUserContactId WITH SECURITY_ENFORCED]?.AccountId;                
                }else{
                    accID = msList[0]?.Related_Account__c;
                }
                relatedCaseID=msList[0]?.caseID;
            }
        }else if(channel == 'Phone'){
            
            if(Schema.getGlobalDescribe().get('VoiceCall').getDescribe().isAccessible()) {
                list<VoiceCall> lstVoiceCalls = [select Related_Account__c,RelatedRecordID from VoiceCall where id=:recordId WITH SECURITY_ENFORCED];
                
                accID =lstVoiceCalls[0]?.Related_Account__c;
                relatedCaseID=lstVoiceCalls[0]?.RelatedRecordID;
                
            }
        }else{
            if(Schema.getGlobalDescribe().get('LiveChatTranscript').getDescribe().isAccessible()) {
                list<LiveChatTranscript> lstLiveChats = [select ContactId,AccountId,caseID from LiveChatTranscript where id=:recordId WITH SECURITY_ENFORCED];
                contactID=lstLiveChats[0]?.contactID;
                accID = lstLiveChats[0]?.AccountId;
                relatedCaseID=lstLiveChats[0]?.caseID;
            }
        }*/
        
        Integer offset = (pageNumber - 1) * pageSize;
        List<Case> caselist = new List<Case> ();
        if(Schema.getGlobalDescribe().get('case').getDescribe().isAccessible()) {
            if(String.isNotBlank(accID) || String.isNotBlank(contactID)){
                Integer totalRecords = [SELECT COUNT() from case where status !='Closed'and (AccountId = :accID OR ContactId =:contactID) WITH SECURITY_ENFORCED];
                Integer recordEnd = pageSize * pageNumber;  
                caseList = [select Id,CaseNumber,Type,Status,CreatedDate,Account.Name from case where (AccountId = :accID OR ContactId =:contactID) and status !='Closed' and id!=:relatedCaseID WITH SECURITY_ENFORCED ORDER BY createddate DESC LIMIT :pageSize OFFSET :offset];
            }
            /*else if((String.isNotBlank(contactID) && channel == 'Chat')) {
                Integer totalRecords = [SELECT COUNT() from case where status !='Closed'and ContactId =:contactID WITH SECURITY_ENFORCED];
                Integer recordEnd = pageSize * pageNumber;                
                caseList = [select Id,CaseNumber,Type,Status,CreatedDate,Account.Name from case where ContactId =:contactID and status !='Closed' and id!=:relatedCaseID WITH SECURITY_ENFORCED ORDER BY createddate DESC LIMIT :pageSize OFFSET :offset];
            }*/
        }
        return caselist;    
    }
}