@istest
public class RS_LCHandler_TestClass {
    @istest
    public static void testmethod1(){
        Map<id,LiveChatTranscript> oldmap = new Map<id,LiveChatTranscript>();
        Map<id,LiveChatTranscript>  newmap = new Map<id,LiveChatTranscript>();
        List<LiveChatTranscript> livechat = new List<LiveChatTranscript>();
        LiveChatVisitor   lcv=new LiveChatVisitor();
        insert lcv;
        LiveChatTranscript lc = TestDataFactory.LCList(true);
        System.assertEquals(0.3,lc.Customer_Sentiment_Score__c);
        oldmap.put(lc.id,lc);
        lc.status='Completed';
        lc.EndTime=system.now();
        update lc;
        newmap.put(lc.id,lc);
        livechat.add(lc);
        RS_LiveChatTranscriptTriggerHandler.afterUpdate(livechat,newmap,oldmap);
    }
}