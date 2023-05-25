/**
 * @description       : This class is used to Send SMS Notification to Customer On Case Creation.
 * @author            : Accenture
 * @group             : SF
 * @last modified on  : 03-24-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class RS_Send_Message_On_Case_Creation {
    /**
    * @description : Send SMS Notification to Customer
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-24-2023 
    * @param caseId 
    **/
    @future(callout=true)
    public static void sendSNSMessage(List<String> caseId){
        List<Case> caselist =[Select Account.FirstName,Account.Phone,CaseNumber,Id from Case where Id IN:caseId WITH SECURITY_ENFORCED];
        MessagingTemplate messagebody=[Select Message from MessagingTemplate where DeveloperName =:System.Label.SNSMessagingTemplate WITH SECURITY_ENFORCED];
        For(Case c:caselist){
            
            if(c.Account.Phone!=null){
                String message = messagebody.Message.replace('{!Contact.FirstName}',c.Account.FirstName);
                message=message.replace('{!Case.CaseNumber}',c.CaseNumber);
                
                String requestBody ='{"MessageConfiguration":{"SMSMessage":{"Body":"'+message+' ", "Substitutions":{},"SenderId":"Reimagine Service","MessageType":"PROMOTIONAL"} },"Addresses":{"'+c.Account.Phone+'": {"ChannelType": "SMS"}}}'; 
                try{
                    Http http = new Http();
                    HttpRequest request = new HttpRequest();
                    request.setEndpoint('callout:RS_AWS_SNS');
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
    }
}