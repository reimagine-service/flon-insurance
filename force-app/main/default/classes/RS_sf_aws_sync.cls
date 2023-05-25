/**
* @description       : This class is used to sync salesforce and aws data like  reschedule callback etc. 
* @author            : Accenture
* @last modified on  : 03-24-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class RS_sf_aws_sync {
    
/**
* @description : This method is used to reschedule the callback call.
* @author  Accenture| 07-13-2022 
* @param recId : Correspondigs VoiceCall id
* @param prefDatetime : PreferredDateTime Value of corresponding Voicecall
**/
    @future(callout=true)
    public static void reScheduleCallback(String recId, DateTime prefDatetime){
        String voiceCallId=String.valueOf(recId).substring(0, 15);
        String datevalue = prefDatetime.format('yyyy-MM-dd');
        String timeValue = prefDatetime.format('hh:mm a');
        String tName = [Select DynamoDB_Name__c from RS_VoiceCall_OwnerId__mdt where DeveloperName='Integration_User']?.DynamoDB_Name__c;
        String requestBody = '{"TableName":"'+tName+'","Key":{"InboundvoiceCallId":{"S":"'+voiceCallId+'"}}'+',"UpdateExpression":"set timeStampCallback =:t,dateStampCallback= :d","ExpressionAttributeValues":{":t":{"S":"'+timeValue+'"},":d":{"S":"'+datevalue+'"}},"ReturnValues": "ALL_NEW"}';
        try{
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:RS_AWS_Reschedule');
            request.setMethod('POST');
            request.setbody(requestbody);
            request.setHeader('X-Amz-Target', 'DynamoDB_20120810.UpdateItem');
            request.setHeader('content-type', 'application/json');            
            HttpResponse response = http.send(request);
            
        }
        catch(Exception e){
            system.debug('ERROR >>>>>' + e.getMessage());
        } 
        
        
    }
    /**
* @description : This method is used to Cancel the Scheduled call.
* @author  Accenture| 07-13-2022 
* @param recId : Correspondigs VoiceCall id
**/
    
    @future(callout=true)
    public static void cancelCallback(String recId){
        String voiceCallId=String.valueOf(recId).substring(0, 15);
        
        try{
            String tName = [Select DynamoDB_Name__c from RS_VoiceCall_OwnerId__mdt where DeveloperName='Integration_User']?.DynamoDB_Name__c;
            String requestbody ='{"TableName": "'+tName+'","Key": {"InboundvoiceCallId": {"S": "'+voiceCallId+'"}}}';
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:RS_AWS_Reschedule');
            request.setMethod('POST');
            request.setbody(requestbody);
            request.setHeader('X-Amz-Target', 'DynamoDB_20120810.DeleteItem');
            request.setHeader('content-type', 'application/json');        
            HttpResponse response = http.send(request);
            
        }
        catch(Exception e){
            system.debug('ERROR >>>>>' + e.getMessage());
        } 
        
        
    }
    
    @future(callout=true)
    public static void schduleCallback(String recId, String clBckTime, String phoneNumber, String clBckDate, String qName, String qARN){
        try{
            String tName = [Select DynamoDB_Name__c from RS_VoiceCall_OwnerId__mdt where DeveloperName='Integration_User']?.DynamoDB_Name__c;
            String requestbody = '{"TableName": "'+tName+'", "Item": { "InboundvoiceCallId": { "S": "'+recId+'" }, "dateStampCallback": {"S": "'+clBckDate+'"}, "PhoneNumber": {"S": "'+phoneNumber+'"}, "QueueARN": {"S": "'+qARN+'"}, "QueueName": {"S": "'+qName+'"},"ScheduleCallBack": {"S": "Yes"}, "timeStampCallback": {"S": "'+clBckTime+'"}}}';
            
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:RS_AWS_Reschedule');
            request.setMethod('POST');
            request.setbody(requestbody);
            request.setHeader('X-Amz-Target', 'DynamoDB_20120810.PutItem');
            request.setHeader('content-type', 'application/json');        
            HttpResponse response = http.send(request);
            String message;
            MessagingTemplate messagebody;
            if(response.getStatusCode()==200){
                //	return true;
                messagebody=[Select Message from MessagingTemplate where DeveloperName ='Callback_Scheduled_Confirmation' WITH SECURITY_ENFORCED];
                String accountname=[Select RS_Related_Account__r.Firstname from VoiceCall where Id=:recId]?.RS_Related_Account__r.Firstname;
                message=messagebody.Message;
                if(accountname!=null){
                    message=message.replace('{!Contact.FirstName} ',accountname);}
                else{
                    message=message.replace('{!Contact.FirstName} ','');}
                message=message.replace('{ScheduledTime}',ClBckDate+'&'+ClBckTime);
                
            }
            else{
                messagebody=[Select Message from MessagingTemplate where DeveloperName ='Callback_NOT_Scheduled_Confirmation'  WITH SECURITY_ENFORCED];
                String accountname=[Select RS_Related_Account__r.Firstname from VoiceCall where Id=:recId]?.RS_Related_Account__r.Firstname;
                message=messagebody.Message;
                if(accountname!=null){
                    message=message.replace('{!Contact.FirstName} ',accountname);}
                else{
                    message=message.replace('{!Contact.FirstName} ','');}
            }
            String requestBody1 ='{"MessageConfiguration":{"SMSMessage":{"Body":"'+message+' ", "Substitutions":{},"SenderId":"Reimagine Service","MessageType":"PROMOTIONAL"} },"Addresses":{"'+PhoneNumber+'": {"ChannelType": "SMS"}}}'; 
            try{
                Http http1 = new Http();
                HttpRequest request1 = new HttpRequest();
                request1.setEndpoint('callout:RS_AWS_SNS');
                request1.setMethod('POST');
                request1.setbody(requestBody1);
                request1.setHeader('content-type', 'application/json');            
                HttpResponse response1 = http1.send(request1);
                
            }
            catch(Exception e){
                system.debug('ERROR >>>>>' + e.getMessage());
            } 
        }
        catch(Exception e){
            system.debug('ERROR >>>>>' + e.getMessage());
            //return false;
        }
        
    }
}