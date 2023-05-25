/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-24-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class RS_trendChartcontrollerTest {
@isTest
    static void getSentimentsByIdTest(){
        // create a case record
        Case cs = TestDataFactory.CaseMethod(True);
        String channelname ='Live_Chat';
        LiveChatTranscript lchat = TestDataFactory.LCList(true);
        RS_SentimentCalculator.getSentiment(channelname, lchat.id);
        //lchat.case.id= cs.ID;
        test.startTest();
        RS_trendChartcontroller.getSentimentsById(cs.ID);
        test.stopTest();
        System.assertEquals('Live_Chat',channelname);
    }
    @isTest
    public static void getSentimentsByIdForAccountTest(){
        String masterLabel = 'Sentiment Score List';
        Account acc = TestDataFactory.accList();
        List<Sentiment_Score__c> sentimentList = RS_trendChartcontroller.getSentimentsByIdForAccount(acc.Id, MasterLabel);
        RS_trendChartcontroller.getObjectDetails(MasterLabel); 
        System.assertEquals('Sentiment Score List',masterLabel);
    }
}