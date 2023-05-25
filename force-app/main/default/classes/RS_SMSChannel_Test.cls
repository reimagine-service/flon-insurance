@isTest
public class RS_SMSChannel_Test {
    @isTest
    static void agentAvailableOverSMSTest() {
        Test.startTest();
        User us=TestDataFactory.createUser();
      /* Group g = new Group(Type='Queue', Name='testqueue'); 
insert g; 
QueueSObject q = new QueueSObject(SobjectType='MessagingSession', QueueId=g.Id); 
insert q;*/
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/smsChannel/*'; 
        req.params.put('qName', 'testqueue');
        req.httpMethod = 'GET';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res;
        RS_SMSChannel.agentAvailableOverSMS();
        Test.stopTest();
    }
}