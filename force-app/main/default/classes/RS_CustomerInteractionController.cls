/**
* @description       : This class is to show all the communication happend with customer from diff. diff. channels.
* @author            : Accenture
* @group             : 
* @last modified on  : 05-03-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class RS_CustomerInteractionController
{
    
    /**
* @description 
* @author Accenture | 03-14-2022 
* @param caseId 
* @return list<InteractionWrapper> 
**/
    @AuraEnabled
    public static list<InteractionWrapper> getCaseInteraction(String caseId)
    {
        List<InteractionWrapper> lstInteraction = new List<InteractionWrapper>();
        Integer count;
        decimal decHours=0;
       List<RS_Customer_Interaction_Per_Case__mdt> customerIntercationsChannelsList=[Select Interaction_Type__c,Interaction_Call_Type__c,Interaction_From__c,Interaction_Name__c,Interaction_Status__c,Interaction_Duration__c,Interaction_Time_Field__c,OrderBy_Field__c,Dynamic_Field__c,Static_Field__c,Query__c from RS_Customer_Interaction_Per_Case__mdt WITH SECURITY_ENFORCED];
       for(RS_Customer_Interaction_Per_Case__mdt geteachInteractionChannel:customerIntercationsChannelsList){
        List<sObject> intercationsPerCase = new List<sObject>();
        String interactionDate=geteachInteractionChannel.Interaction_Time_Field__c;
        String interactionDiration=geteachInteractionChannel.Interaction_Duration__c;
        if(geteachInteractionChannel.Dynamic_Field__c !=null){
            System.debug(String.escapeSingleQuotes(geteachInteractionChannel.Query__c) +' Where '+String.escapeSingleQuotes(geteachInteractionChannel.Static_Field__c)+' = '+'\''+ caseId +'\' ' +' and ' +String.escapeSingleQuotes(geteachInteractionChannel.Dynamic_Field__c)+' ORDER BY '+String.escapeSingleQuotes(geteachInteractionChannel.OrderBy_Field__c)+' desc');
            intercationsPerCase=Database.query(String.escapeSingleQuotes(geteachInteractionChannel.Query__c) +' Where '+String.escapeSingleQuotes(geteachInteractionChannel.Static_Field__c)+' = '+'\''+ String.escapeSingleQuotes(caseId) +'\' ' +' and ' +String.escapeSingleQuotes(geteachInteractionChannel.Dynamic_Field__c)+'ORDER BY '+String.escapeSingleQuotes(geteachInteractionChannel.OrderBy_Field__c)+' desc');
            System.debug('intercationsPerCase dynamic'+intercationsPerCase);
        }
         else{
            System.debug(String.escapeSingleQuotes(geteachInteractionChannel.Query__c) +' Where '+String.escapeSingleQuotes(geteachInteractionChannel.Static_Field__c)+' = '+'\''+ caseId +'\' ' +'ORDER BY '+String.escapeSingleQuotes(geteachInteractionChannel.OrderBy_Field__c)+' desc');
            intercationsPerCase=Database.query(String.escapeSingleQuotes(geteachInteractionChannel.Query__c) +' Where '+String.escapeSingleQuotes(geteachInteractionChannel.Static_Field__c)+' = '+'\''+ String.escapeSingleQuotes(caseId) +'\''+'ORDER BY '+String.escapeSingleQuotes(geteachInteractionChannel.OrderBy_Field__c)+' desc');
            System.debug('intercationsPerCase'+intercationsPerCase);
         }
         List<InteractionWrapper> listofInteractions=RS_CustomerInteractionController.insertInteractionsDataInWrapper(intercationsPerCase,geteachInteractionChannel);
         System.debug('listofInteractions'+listofInteractions);
         lstInteraction.addALL(listofInteractions);
         System.debug('lstInteraction'+lstInteraction);
       }
        lstInteraction.sort();        
        return lstInteraction;
    }
    
    /**
* @description Wrapper Class
* @author Accenture | 03-14-2022 
**/
    public class InteractionWrapper implements comparable
    { 
        /**
* @description: Interaction channel recordId
* @author Accenture | 03-14-2022 
**/
        @AuraEnabled
        public String channelID{get;set;} // String ChannelID
        /**
* @description: Interaction channel Type
* @author Accenture | 03-14-2022 
**/
        @AuraEnabled
        public string channelType{get;set;} // string channelType
        /**
* @description:Interaction Received date
* @author Accenture | 03-14-2022 
**/
        @AuraEnabled
        public String recievedDate{get;set;} // String recievedDate
        /**
* @description: Duration of Interaction
* @author Accenture | 03-14-2022 
**/
        @AuraEnabled
        public String duration{get;set;} // String duration
        /**
* @description: Call Type Of VoiceCall
* @author Accenture | 03-14-2022 
**/
        @AuraEnabled
        public string callType{get;set;} // string callType
        /**
* @description: From Phone Number
* @author Accenture | 03-14-2022 
**/
        @AuraEnabled
        public string phone{get;set;} //string phone
        /**
* @description:Status of Call
* @author Accenture | 03-14-2022 
**/
        @AuraEnabled
        public string callDisposition{get;set;} // string callDisposition
        /**
* @description: Interaction Name
* @author Accenture | 03-14-2022 
**/
        @AuraEnabled
        public String name{get;set;} // String name
        /**
* @description: Counter for sorting the list
* @author Accenture | 03-14-2022 
**/
        @AuraEnabled
        public Integer counter{get;set;}// Integer counter
        
        /**
* @description: Assignment of Wrapper Class
* @author Accenture | 03-14-2022 
**/
        
        public InteractionWrapper(string channelID,string channel , String recieved , String dur , string ctype  , string phone, string disp,String name)
        {
            this.name=name;
            this.channelID=channelID;
            this.channelType = channel;
            this.recievedDate= recieved;
            this.duration = dur;
            this.callType = ctype;
            this.phone = phone;
            this.callDisposition =disp;
        }
        
        /**
* @description: Method to sort the list
* @author Accenture | 03-14-2022 
**/
        public Integer compareTo(Object objToCompare)
        {
            InteractionWrapper wrapper = (InteractionWrapper)objToCompare;
            if (recievedDate<wrapper.recievedDate)
            {
                return 1;
            } 
            else if (recievedDate>wrapper.recievedDate)
            {
                return -1;
            } 
            else {
                return 0;
            }
        }
    }
    
    /**
* @description: Returns the domain url
* @author Accenture | 03-14-2022 
**/
    
    @AuraEnabled   
    public static string getmydomain()
    {   
        String urlInstance=String.valueof(System.URL.getSalesforceBaseURL().gethost()); 
        return urlInstance;
    }    

    Public Static List<InteractionWrapper> insertInteractionsDataInWrapper(List<sobject> interactionsList,RS_Customer_Interaction_Per_Case__mdt interactionMetaRecord){
        List<InteractionWrapper> listofInteractions=new List<InteractionWrapper>();
        for(sobject interaction:interactionsList){
            InteractionWrapper wrapObj;
            /*Email Channel has no specific Duration*/
            if(interactionMetaRecord.Interaction_Duration__c!=null){
                 wrapObj = new InteractionWrapper(String.ValueOf(interaction.Id),interactionMetaRecord.Interaction_Type__c,String.ValueOf(interaction.get(interactionMetaRecord.Interaction_Time_Field__c)) ,String.ValueOf(interaction.get(interactionMetaRecord.Interaction_Duration__c)),String.ValueOf(interaction.get(interactionMetaRecord.Interaction_Call_Type__c)),String.ValueOf(interaction.get(interactionMetaRecord.Interaction_From__c)),String.ValueOf(interaction.get(interactionMetaRecord.Interaction_Status__c)),String.ValueOf(interaction.get(interactionMetaRecord.Interaction_Name__c)));
            }
            else{
                wrapObj = new InteractionWrapper(String.ValueOf(interaction.Id),interactionMetaRecord.Interaction_Type__c,String.ValueOf(interaction.get(interactionMetaRecord.Interaction_Time_Field__c)) ,'0',String.ValueOf(interaction.get(interactionMetaRecord.Interaction_Call_Type__c)),String.ValueOf(interaction.get(interactionMetaRecord.Interaction_From__c)),'Completed',String.ValueOf(interaction.get(interactionMetaRecord.Interaction_Name__c)));
            }
                listofInteractions.add(wrapObj);
        }
        return listofInteractions;

    }
}