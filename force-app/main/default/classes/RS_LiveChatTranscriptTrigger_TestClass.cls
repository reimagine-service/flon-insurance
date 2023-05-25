@Istest
public class RS_LiveChatTranscriptTrigger_TestClass {
    @Istest
    public static void testmethod1(){
       LiveChatTranscript l = TestDataFactory.LCList(True);
        System.assertEquals(0.3,l.Customer_Sentiment_Score__c);
        l.status='Completed';
        l.EndTime=system.now();
        update l;
      /*  List<LiveChatTranscript> livechat = new List<LiveChatTranscript>();
        LiveChatVisitor   lcv=new LiveChatVisitor();
        insert lcv;
        LiveChatTranscript lc = new LiveChatTranscript();
        lc.Body='Hi';
        lc.LiveChatVisitorId=lcv.id;
        lc.Customer_Sentiment_Score__c=0.3;
        insert lc; */
     /*   lc.status='Completed';
        lc.EndTime=system.now();
        update lc; */
       
    }
}