/**
* @description : this is RS_EmailMessageTriggerHandler class.
* @author : Accenture
* @group :
* @last modified on : 03-24-2023
* @last modified by : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class RS_EmailMessageTriggerHandler {
    /**
    * @description : This is afterInsert method.
    * @Return : void
    * @Method Name : afterInsert
    * @param em 
    **/
    public static void afterInsert(List<EmailMessage> em){
        Map<Id, Case> caseMap = new Map<Id, Case>();
        String channelname =[Select DeveloperName from RS_Einstein_Sentiment_Configuration__mdt where label='Email' WITH SECURITY_ENFORCED]?.DeveloperName;
        for(EmailMessage emailmessage: em){
            //caseMap.put(emailmessage.RelatedToId, new Case(Id=emailmessage.RelatedToId, RS_Last_Interaction_Channel__c='Email'));
            if(emailmessage.Status=='0' && emailmessage.Incoming == true){
            RS_SentimentCalculator.getSentiment(channelname,emailmessage.Id);
            }
        }
        update caseMap.values();
    }
}