/**
* @description       : Handler Class for RS_VoiceCallTrigger
* @author            : Accenture
* @group             : 
* @last modified on  : 03-24-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class RS_VCHandler {
    public static Boolean isFirstRun = true;
    /**
* @description     : Update the details from previous voice call record to new voice call record in case of transfer call
* @author          : Accenture | 02-25-2022 
* @param           : listVC
**/
    public void handleAfterInsert(List<VoiceCall> listVC){ 
        try{
            List<VoiceCall> listVoiceCall = new List<VoiceCall>();
            //get the details of previous call record
            if(Schema.getGlobalDescribe().get('VoiceCall').getDescribe().isAccessible()) {
                for(VoiceCall objVC : [SELECT CallType,PreviousCall.RS_Previous_Call__c,PreviousCall.Sub_Issue_Type__c, FromPhoneNumber , RelatedRecordId, PreviousCallId , PreviousCall.IVRType__c,RS_Callback_Status__c,
                                       PreviousCall.RS_Customer_Identified__c, PreviousCall.RS_CustomerVerified__c, PreviousCall.RS_CustomerAccountNumber__c,
                                       PreviousCall.RS_DateOfBirth__c , PreviousCall.RelatedRecordId , PreviousCall.IVRIntent__c , PreviousCall.IVRInput__c,PreviousCall.Related_Account__c,
                                       PreviousCall.RS_Severity__c,PreviousCall.RS_Alternative_Connect_Requested__c,PreviousCall.RS_Alternative_Number__c,PreviousCall.RS_Preferred_Callback_Time__c FROM VoiceCall WHERE ID IN : listVC WITH SECURITY_ENFORCED])
                {
                    
                    //in case of agent transfer 
                    if(objVC.CallType=='Transfer'){
                        //Getting all the information from first voice call to second voice call when a voice call is transfered to other agent.
                        objVC.RS_Customer_Identified__c = objVC.PreviousCall.RS_Customer_Identified__c;
                        objVC.IVRType__c = objVC.PreviousCall.IVRType__c;
                        objVC.RS_CustomerVerified__c = objVC.PreviousCall.RS_CustomerVerified__c;
                        objVC.RS_CustomerAccountNumber__c = objVC.PreviousCall.RS_CustomerAccountNumber__c;
                        objVC.RS_DateOfBirth__c = objVC.PreviousCall.RS_DateOfBirth__c;
                        objVC.Related_Account__c=objVC.PreviousCall.Related_Account__c;
                        objVC.IVRIntent__c = objVC.PreviousCall.IVRIntent__c;
                        objVC.IVRInput__c = objVC.PreviousCall.IVRInput__c;
                        objVC.RelatedRecordId = objVC.PreviousCall.RelatedRecordId;
                        objVC.RS_Severity__c=objVC.PreviousCall.RS_Severity__c;
                        objVC.Related_Account__c=objVC.PreviousCall.Related_Account__c;
                        objVC.RS_Previous_Call__c=objVC.PreviousCallId;
                        objVC.Sub_Issue_Type__c=objVC.PreviousCall.Sub_Issue_Type__c;
                        listVoiceCall.add(objVC);                        
                    }
                    else if(objVC.CallType=='Callback'){
                        //Getting all the information from first voice call to second voice call when a voice call is transfered to other agent.
                        objVC.RS_Customer_Identified__c = objVC.PreviousCall.RS_Customer_Identified__c;
                        objVC.IVRType__c = objVC.PreviousCall.IVRType__c;
                        objVC.RS_CustomerVerified__c = objVC.PreviousCall.RS_CustomerVerified__c;
                        objVC.RS_CustomerAccountNumber__c = objVC.PreviousCall.RS_CustomerAccountNumber__c;
                        objVC.RS_DateOfBirth__c = objVC.PreviousCall.RS_DateOfBirth__c;
                        objVC.IVRIntent__c = objVC.PreviousCall.IVRIntent__c;
                        objVC.IVRInput__c = objVC.PreviousCall.IVRInput__c;
                        objVC.RelatedRecordId = objVC.PreviousCall.RelatedRecordId;
                        objVC.RS_Severity__c=objVC.PreviousCall.RS_Severity__c;
                        objVC.Related_Account__c=objVC.PreviousCall.Related_Account__c;
                        objVC.RS_Preferred_Callback_Time__c=objVC.PreviousCall.RS_Preferred_Callback_Time__c;
                        objVC.RS_Alternative_Connect_Requested__c=objVC.PreviousCall.RS_Alternative_Connect_Requested__c;
                        objVC.RS_Alternative_Number__c=objVC.PreviousCall.RS_Alternative_Number__c;
                        objVc.RS_Callback_Status__c='Completed';
                        objVC.RS_Previous_Call__c=objVC.PreviousCallId;
                        objVC.Sub_Issue_Type__c=objVC.PreviousCall.Sub_Issue_Type__c;
                        listVoiceCall.add(objVC);                        
                    }
                }
                if(Schema.getGlobalDescribe().get('VoiceCall').getDescribe().isUpdateable() && !listVoiceCall.isempty()){
                    //Update the voice call record
                    update listVoiceCall;
                }
            }
        } 
        catch(Exception e){
            system.debug('ERROR >>>>>' + e.getMessage());
        }     
    } 
    /**
    * @description : After Update Method
    * @author Accenture | 03-24-2023 
    * @param listVC 
    * @param oldVCmap 
    * @param newVCmap 
    **/
    public void handleAfterUpdate(List<VoiceCall> listVC,Map<Id,VoiceCall> oldVCmap,Map<Id,VoiceCall> newVCmap){
        List<VoiceCall> listVoiceCall = new List<VoiceCall>();
        try{
            Map<String,String> mapVoiceCallAgentId = new Map<String,String>();
            List<VoiceCall> vcList = New List<VoiceCall>();
           // List<Case> caseList = New List<Case>();
            List<String>  caseIdList = new List<String>();
            for(VoiceCall objVC :listVC){
                caseIdList.add(objVC.RelatedRecordId);
            }
            Map<id,Case> caseIdMap = new Map<id,Case>([Select type from case where id IN :caseIdList]);
            
            if(Schema.getGlobalDescribe().get('VoiceCall').getDescribe().isAccessible()){
                for(VoiceCall objVC : listVC)
                {
                    if(oldVCmap.get(objVC.id).RS_Preferred_Callback_Time__c !=null && (objVC.RS_Callback_Status__c=='Requested'|| objVC.RS_Callback_Status__c=='RequestedViaCaip') && objVC.RS_Preferred_Callback_Time__c !=oldVCmap.get(objVC.id).RS_Preferred_Callback_Time__c){
                        RS_sf_aws_sync.reScheduleCallback(objVC.Id,objVC.RS_Preferred_Callback_Time__c);
                    }
                    else if(objVC.RS_Callback_Status__c =='Cancelled' && objVC.RS_Callback_Status__c != oldVCmap.get(objVC.id).RS_Callback_Status__c){
                        RS_sf_aws_sync.cancelCallback(objVC.Id);
                    }
                    if(objVC.CallDisposition=='completed' && objVC.CallDisposition!=oldVCmap.get(objVC.id).CallDisposition){
                        RS_vc_aws_sync.updateCustomerInfo(objVC.RS_ContactId__c, objVC.RS_CustomerAccountNumber__c, objVC.RS_CustomerVerified__c, objVC.RS_Customer_Identified__c, objVC.Related_Account__c, objVC.RS_DateOfBirth__c, objVC.RS_Switch_To_SMS__c, objVC.RS_Switching_Status__c);
                    }
                    if(objVC.RS_Previous_Call__c!=NULL && oldVCmap.get(objVC.id).RelatedRecordId!=newVCmap.get(objVC.id).RelatedRecordId && newVCmap.get(objVC.id).RelatedRecordId!=NULL){
                        
                        //String issuetype=[Select type from case where id=:objVC.RelatedRecordId]?.type;
                        //
                        //objVC.IVRIntent__c=issuetype;
                       // if(objVC.RS_Previous_Call__c!=NULL){
                            VoiceCall vcObj2 = new VoiceCall(Id=objVC.RS_Previous_Call__c);
                            vcObj2.RelatedRecordId=objVC.RelatedRecordId;
                            vcObj2.IVRIntent__c=caseIdMap.get(objVC.RelatedRecordId).Type;
                            vcList.add(vcObj2);
                            //VCList.add(objVC);
                            
                       // }
                    }
                }
                if(Schema.getGlobalDescribe().get('VoiceCall').getDescribe().isUpdateable()){   
                    
                    update vcList;
                }
               /* if(Schema.getGlobalDescribe().get('Case').getDescribe().isUpdateable()){
                    update caseList;
                }*/
            }
        }
        catch(Exception e){
            system.debug('ERROR >>>>>' + e.getMessage());
        }   
    }
    /**
    * @description : Before Update Method
    * @author : Accenture| 03-24-2023 
    * @param listVC 
    * @param trgrNewMap 
    * @param trgrOldMap 
    **/
    public void handleBeforeUpdate(List<VoiceCall> listVC,Map<id, VoiceCall> trgrNewMap, Map<id, VoiceCall> trgrOldMap){
        Decimal timeZone=[SELECT Time_Zone__c from RS_VoiceCall_OwnerId__mdt  where DeveloperName ='Integration_User']?.Time_Zone__c;
        Integer myintval = Integer.valueOf(timeZone);
        //Validation for rescheduling
        BusinessHours businessHoursId=[SELECT Id FROM BusinessHours WHERE IsDefault=true WITH SECURITY_ENFORCED];
        List<String>  caseIdList = new List<String>();
        for(VoiceCall objVC :listVC){
            caseIdList.add(objVC.RelatedRecordId);
        }
        Map<id,Case> caseIdMap = new Map<id,Case>([Select type from case where id IN :caseIdList]);
        for(VoiceCall objVC :listVC)
        {
            if(objVC.CallType=='Inbound' && objVC.RS_Preferred_Callback_Time__c!=null && objVC.RS_Callback_Status__c=='Requested' && objVC.RS_Update_Identifier__c==true){
                objVC.RS_Preferred_Callback_Time__c=objVC.RS_Preferred_Callback_Time__c.addHours(myintval);
                objVC.RS_Update_Identifier__c=false;
            }
            if(trgrOldMap.get(objVC.id).RelatedRecordId!=trgrNewMap.get(objVC.id).RelatedRecordId && trgrNewMap.get(objVC.id).RelatedRecordId!=NULL){
                //String issuetype=[Select type from case where id=:objVC.RelatedRecordId]?.type;
                // 
                if(caseIdMap.get(objVC.RelatedRecordId).Type!=objVC.IVRIntent__c && objVC.IVRIntent__c!=null){
                    objVC.IVRIntent__c=caseIdMap.get(objVC.RelatedRecordId).Type;
                    objVC.Sub_Issue_Type__c='';
                    objVC.Update_Case_Id__c=objVC.RelatedRecordId;
                }    
            }
            //Validation before rescheduling
            if(objVC.RS_Preferred_Callback_Time__c!=null && !BusinessHours.isWithin(businessHoursId.id, objVC.RS_Preferred_Callback_Time__c)){
                objVC.addError('Please reschedule only during working hours between Monday to Friday');
            }
            if(trgrOldMap.get(objVC.id).RS_Preferred_Callback_Time__c!=trgrNewMap.get(objVC.id).RS_Preferred_Callback_Time__c ||(trgrOldMap.get(objVC.id).Callback_Cancelled__c!=trgrNewMap.get(objVC.id).Callback_Cancelled__c)){
                objVC.RS_Callback_Details_Updated_By__c=UserInfo.getUserId();
            }
        }
    }
}