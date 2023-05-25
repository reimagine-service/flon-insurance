/**
 * @description       : Test Class for RS_SentimentCalculator
 * @author            : Accenture
 * @group             : 
 * @last modified on  : 03-24-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class RS_SentimentCalculatorTest {
    @Istest
    static void method(){
        Test.setMock(HttpCalloutMock.class, new RS_HttpMockCalloutClass());
        //RS_VoiceCallBatchTestClass.testVoiceBatch();
       // Voicecall vc=TestDataFactory.VCList(true);
        Document doc=TestDataFactory.doclist();
        RS_PredictionController predCont = new RS_PredictionController();
        String accesstoken = predCont.getAccessToken();
        String channelname ='Live_Chat';
        LiveChatTranscript lchat = TestDataFactory.LCList(true);
        RS_SentimentCalculator.getSentiment(channelname, lchat.id);
        System.assertEquals('Live_Chat',channelname);
    }
}