@isTest
Public class Rs_voiceCallParserTest{
    
    static testMethod void testParse() {
        String json='{"conversationEntries":[{"clientDuration":585,"clientTimestamp":1649310964000,"identifier":"16b3011b-635f-4b42-a7a4-16d568038b00","messageText":"Yeah, you can.","relatedRecords":["0LQ3C0000008Pwa"],"sender":{"appType":"telephony_integration","role":"Agent","subject":"VIRTUAL_AGENT"},"serverReceivedTimestamp":1649310968301}]}';
        Rs_voiceCallParser obj = Rs_voiceCallParser.parse(json);
        System.assert(obj != null);
    }
}