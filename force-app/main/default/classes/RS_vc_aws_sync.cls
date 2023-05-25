/**
* @description       : This class is used to sync voice call object data and aws data after validation of customer. 
* @author            : Accenture
* @last modified on  : 03-24-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public without sharing class RS_vc_aws_sync {
	
    /**
    * @description : sync voice call object data and aws data after validation of customer. 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-24-2023 
    * @param recContactId 
    * @param customerAccNum 
    * @param custVerified 
    * @param custIdentified 
    * @param recAccountId 
    * @param personDOB 
    * @param switchCheck 
    * @param switchStatus 
    **/
    @future(callout=true)
    public static void updateCustomerInfo(String recContactId, String customerAccNum, Boolean custVerified, Boolean custIdentified, String recAccountId, Date personDOB, Boolean switchCheck, String switchStatus){
        String instanceId = [Select Instance_Id__c from RS_VoiceCall_OwnerId__mdt where DeveloperName='Integration_User']?.Instance_Id__c;
        String requestBody = '{"Attributes": {"sfdc-RS_CustomerAccountNumber__c": "'+customerAccNum+'","sfdc-Related_Account__c": "'+recAccountId+'","sfdc-RS_Customer_Identified__c": "'+custIdentified+'","sfdc-RS_CustomerVerified__c": "'+custVerified+'","sfdc-RS_DateOfBirth__c": "'+personDOB+'","sfdc-RS_Switch_To_SMS__c": "'+switchCheck+'","sfdc-RS_Switching_Status__c": "'+switchStatus+'"},"InitialContactId": "'+recContactId+'","InstanceId": "'+instanceId+'"}';
    	try{
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:RS_content_aws/contact/attributes');
            request.setMethod('POST');
            request.setbody(requestbody);
            request.setHeader('content-type', 'application/json');            
            HttpResponse response = http.send(request);
            
        }
        catch(Exception e){
            system.debug('ERROR >>>>>' + e.getMessage());
        } 
    }
}