@IsTest
public class RS_VoiceCallBatchTestClass {
      	 @TestSetup
    public static void createTestData(){
           case cs=TestDataFactory.csList();
        VoiceCall vc=new VoiceCall();
        vc.RS_Preferred_Callback_Time__c=DateTime.Now().addDays(1);
        vc.RS_Callback_Status__c='Requested';
        vc.IVRType__c='New Case';
        vc.VendorType ='ContactCenter';
        vc.CallType='Inbound';
        vc.ToPhoneNumber ='+18334133093';
        vc.IVRIntent__c='Billing';
        vc.FromPhoneNumber= '+16617480240';
        vc.CallStartDateTime =date.newInstance(2022, 20, 18);
        vc.CallEndDateTime = date.newInstance(2022, 20, 18);
        vc.VendorCallKey='ab1fafae-8202-4d39-a067-1082feb57c6d';
        vc.CallDisposition='completed';
        vc.RS_ContactId__c='1824b102-cf96-483a-8898-da5c5695fa37';
        vc.RelatedRecordId = cs.Id;
        vc.Customer_Sentiment_Score__c=null;
        vc.Batch_Processed__c = false;
        vc.Conversation_Transcript_Body__c='ab1fafae-8202-4d39-a067-1082feb57c6d';
        vc.Customer_Sentiments__c='Neutral';
        insert vc;
    }
    @isTest
    public static void testVoiceBatch(){
        Voicecall vc= [SELECT id,VendorCallKey, RelatedRecordId, Customer_Sentiment_Score__c,
 Batch_Processed__c, Conversation_Transcript_Body__c,
 Customer_Sentiments__c, 
 CallDisposition from VoiceCall limit 1];
        String vendorCallKey=[SELECT VendorCallKey from VoiceCall limit 1]?.VendorCallKey;
        Test.setMock(HttpCalloutMock.class, new RS_VoiceCallOutClass()); 
        
           Test.startTest();
      	RS_VoiceCallBatch.getData(vendorCallKey);
        RS_VoiceCallBatch x = new RS_VoiceCallBatch();
    	database.executeBatch(x);
    	Test.stopTest();
    }
     @isTest
    public static void testBatch(){
        RS_VoiceCallBatch obj = new RS_VoiceCallBatch();
        //Access token
        Test.setMock(HttpCalloutMock.class, new RS_HttpMockCalloutClass());
        VoiceCall msg = TestDataFactory.VCList(true);
        TestDataFactory.doclist();
        
        RS_PredictionController PredCont = new RS_PredictionController();
        String access_token = PredCont.getAccessToken();
   
        
        DataBase.executebatch(obj);         
    } 
}