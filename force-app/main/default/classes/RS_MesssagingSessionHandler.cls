/**
* @description       : Handler Class for RS_MesssagingSessionTrigger
* @author            : Accenture
* @group             : 
* @last modified on  : 04-20-2022
* @last modified by  : Accenture
**/
public with sharing class RS_MesssagingSessionHandler {
    
    
    /**
* @description 
* @author Accenture | 04-19-2022 
* @param newMSMap, oldMSMap 
* 
*/
    public void UpdateCaseOwnerOnMessagingSession(List<MessagingSession> listMS, Map<Id,MessagingSession> newMSMap, Map<Id,MessagingSession> oldMSMap){
        /*String ownerId;
List<Case> CaseList = new List<Case>();
Map<String,String> MapMessaging= new Map<String,String>();
try{
for(MessagingSession messagingobj :newMSMap.values()){
if(!String.isEmpty(newMSMap.get(messagingobj.Id).OwnerId) && string.valueOf(newMSMap.get(messagingobj.Id).OwnerId).startsWith('005') && !String.isEmpty(newMSMap.get(messagingobj.Id).CaseId)){
MapMessaging.put(messagingobj.CaseId, newMSMap.get(messagingobj.Id).OwnerId);
}
}
if(Schema.getGlobalDescribe().get('Case').getDescribe().isAccessible()){
CaseList = [Select id,ownerId from Case where id IN :MapMessaging.keySet() WITH SECURITY_ENFORCED];
if(CaseList.size()>0){
for(Case caseObj : CaseList){
CaseObj.OwnerId = MapMessaging.get(CaseObj.Id);

}
if(Schema.getGlobalDescribe().get('Case').getDescribe().isUpdateable()){
update CaseList;
}
}
}*/
        for(MessagingSession objMS :listMS){
                 if(oldMSMap.get(objMS.id).CaseId!=newMSMap.get(objMS.id).CaseId && newMSMap.get(objMS.id).CaseId!=NULL){
                     String issuetype=[Select type from case where id=:objMS.CaseId]?.type;
                    String subissuetype=[Select RS_SubType__c from case where id=:objMS.CaseId]?.RS_SubType__c;
                     if(issuetype!=objMS.RS_MessagingIntent__c){
                     objMS.RS_MessagingIntent__c=issuetype;
                     objMS.RS_Sub_Issue_Type__c='';
                     }
                     else{
                         objMS.RS_MessagingIntent__c=issuetype;
                     	objMS.RS_Sub_Issue_Type__c=subissuetype;
                     }
            }
        }
        /*}
catch(Exception e){

}*/
        
    }
}