/**
* @description       : This class is to show all the Callback Intercations happend with customer.
* @author            : Accenture
* @group             : 
* @last modified on  : 03-23-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

public with sharing class RS_CallbackInteractionController {
    
     /**
    * @description 
    * @author  Accenture| 07-13-2022 
    * @param accountId : Account Record Id
    * @return  list<CallBackWrapper>  : list of callback voicecall records that match the Account name
    **/
	
    @AuraEnabled
    public static list<CallBackWrapper> getCallbackInteraction(String accountId){
        List<CallBackWrapper> lstInteraction = new List<CallBackWrapper>();
        Integer count;
        //adding voice call details
        if(Schema.getGlobalDescribe().get('VoiceCall').getDescribe().isAccessible()) {
            Decimal timeZone=[SELECT Time_Zone__c from RS_VoiceCall_OwnerId__mdt  where DeveloperName ='Integration_User']?.Time_Zone__c;
            Integer timeZoneInt = Integer.valueOf(timeZone);
            DateTime todayDate = DateTime.Now();
            DateTime tomorrowsDate=DateTime.Now().addDays(1);
            List<VoiceCall> vclist = [SELECT Id,IVRType__c ,IVRIntent__c,RS_Preferred_Callback_Time__c,CallDurationInSeconds,CallAcceptDateTime, CallType,RS_ID__c, Description, FromPhoneNumber, CallDisposition,Related_Account__c FROM VoiceCall where Related_Account__c =:accountId AND  (RS_Callback_Status__c='Requested' OR RS_Callback_Status__c='RequestedViaCaip') AND CallType='Inbound' and RS_Preferred_Callback_Time__c>=:todayDate and RS_Preferred_Callback_Time__c<:tomorrowsDate WITH SECURITY_ENFORCED];
            Count =vclist.size();
            for(VoiceCall vc : [SELECT Id,IVRType__c ,IVRIntent__c,RelatedRecordId,CallDurationInSeconds,CreatedDate, CallType, Description,RS_ID__c, FromPhoneNumber, CallDisposition,Related_Account__c,RS_Preferred_Callback_Time__c FROM VoiceCall where Related_Account__c =:accountId AND  (RS_Callback_Status__c='Requested' OR RS_Callback_Status__c='RequestedViaCaip')  AND CallType='Inbound' and RS_Preferred_Callback_Time__c>=:todayDate and RS_Preferred_Callback_Time__c<:tomorrowsDate WITH SECURITY_ENFORCED]){
                string s = string.valueof(vc.RS_Preferred_Callback_Time__c);
                String receiveddatetime = String.ValueOf(vc.CreatedDate);
                CallBackWrapper wrapObj = new CallBackWrapper (vc.id,vc.IVRIntent__c, s, vc.FromPhoneNumber,vc.CallDisposition,vc.RS_ID__c,count,vc.IVRType__c,receiveddatetime);  
                count--;
                lstInteraction.add(wrapObj);
            }
        } 
        return lstInteraction;
    }
    public class CallBackWrapper
    {
        // String name
        @AuraEnabled
        public String name{get;set;}
        //Interaction Received Date Time
        @AuraEnabled
        public String receivedDateTime{get;set;} 
        //Customer Call Reason
        @AuraEnabled
        public String callReason{get;set;} 
        // Integer counter
        @AuraEnabled
        public Integer counter{get;set;}
        // String ChannelID
        @AuraEnabled
        public String channelID{get;set;}
        //Case Issue Type
        @AuraEnabled
        public string issueType{get;set;} 
        //Scheduled Callback time
        @AuraEnabled
        public String preferredCallbackTime{get;set;} 
        // Customer Phone Number
        @AuraEnabled
        public string phone{get;set;} 
        // Interaction Status
        @AuraEnabled
        public string callDisposition{get;set;} 
        
        /**
        * @description 
        * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-13-2023 
        * @param channelID 
        * @param issueType 
        * @param preferredCallbackTime 
        * @param phone 
        * @param disp 
        * @param name 
        * @param counter 
        * @param callReason 
        * @param receivedDateTime 
        **/
        public CallBackWrapper(string channelID,string issueType,String preferredCallbackTime,string phone,string disp,String name,Integer counter,String callReason,String receivedDateTime){
            this.name=name;
            this.receivedDateTime=receivedDateTime;
            this.callReason=callReason;
            this.channelID=channelID;
            this.issueType = issueType;
            this.preferredCallbackTime= preferredCallbackTime;
            this.phone = phone;
            this.callDisposition =disp;
            this.counter=counter;
        }
        //string s = string.valueof(interactionWrapper.recievedDate);
    }
     /**
    * @description 
    * @author  Accenture| 07-13-2022 
    * @return String :Domain Url
    **/
    @AuraEnabled   
    public static string getmydomain(){   
        String urlInstance=String.valueof(System.URL.getSalesforceBaseURL().gethost()); 
        return urlInstance;
    } 

   
}