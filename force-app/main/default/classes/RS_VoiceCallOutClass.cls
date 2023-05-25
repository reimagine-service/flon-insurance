/**
 * @description       : Api class to get the conversation entries for the voicecall to calculate sentiment
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-24-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global class RS_VoiceCallOutClass implements HttpCalloutMock{
    global static final String JSON_STRING='[{"clientDuration":585,"clientTimestamp":1649310964000,"identifier":"16b3011b-635f-4b42-a7a4-16d568038b00","messageText":"Yeah, you can.","relatedRecords":["0LQ3C0000008Pwa"],"sender":{"appType":"telephony_integration","role":"Agent","subject":"VIRTUAL_AGENT"},"serverReceivedTimestamp":1649310968301}]';
    
    /**
    * @description : reponse method
    * @authorAccenture| 03-24-2023 
    * @param req 
    * @return HTTPResponse 
    **/
    global HTTPResponse respond(HTTPRequest req) {
        HTTPResponse res = new HTTPResponse();
        //System.assertEquals('POST', req.getMethod());
        res.setStatusCode(200);
        res.setStatus('OK');
        //res.setBody('{"conversationEntries":"'+ JSON_STRING +'"}');
        res.setBody('{"conversationEntries":[{"clientDuration":585,"clientTimestamp":1649310964000,"identifier":"16b3011b-635f-4b42-a7a4-16d568038b00","messageText":"Yeah, you can.","relatedRecords":["0LQ3C0000008Pwa"],"sender":{"appType":"telephony_integration","role":"Agent","subject":"VIRTUAL_AGENT"},"serverReceivedTimestamp":1649310968301}]}');
        //res.setStatusCode(200);
        return res;
    }  
}