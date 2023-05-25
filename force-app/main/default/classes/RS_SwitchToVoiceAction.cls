/**
* @description       : Controller Class for SwitchToVoice LWC
* @author            : Accenture
* @group             : 
* @last modified on  : 03-24-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class RS_SwitchToVoiceAction{
    /**
    * @description : Method to update the messaging session record to switch to voice
    * @author Accenture | 03-24-2023 
    * @param recordId 
    **/
    @AuraEnabled
    Public static void UpdateSwitchToVoice(String recordId ){
        if(Schema.getGlobalDescribe().get('MessagingSession').getDescribe().isAccessible()) {
        MessagingSession ms =[select RS_Switching_Requested_Time__c,RS_switchtovoice__c,RS_Switching_Status__c from MessagingSession where id=:recordId WITH SECURITY_ENFORCED];
        if(MessagingSession.sObjectType.getDescribe().isUpdateable()){
            ms.RS_Switching_Requested_Time__c = system.now();
            ms.RS_switchtovoice__c =True;
            ms.RS_Switching_Status__c ='Requested';
            update ms;
        }
        }
    }
    
    
    
    
}