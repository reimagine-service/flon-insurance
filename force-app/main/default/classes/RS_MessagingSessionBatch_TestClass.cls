/**
 * @description       : Test Class for RS_MessagingSessionBatch
 * @author            : Accenture
 * @group             : 
 * @last modified on  : 03-24-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class RS_MessagingSessionBatch_TestClass {
    
    @isTest
    public static void testBatch(){
        RS_MessagingSessionBatch obj = new RS_MessagingSessionBatch();
        //Access token
        Test.setMock(HttpCalloutMock.class, new RS_HttpMockCalloutClass());
        MessagingSession msg = TestDataFactory.MsgMethod();
        TestDataFactory.doclist();
        
        RS_PredictionController predCont = new RS_PredictionController();
        String accesstoken = predCont.getAccessToken();
        ConversationEntry ce = new ConversationEntry();
            ce.ConversationId=msg.id;
            ce.ActorType='EndUser';
            ce.EntryType='Text';
            ce.EntryTime=Datetime.newInstance(2022, 04, 12, 12, 30, 2);
            ce.Seq=5;
        insert ce;
        System.assertEquals('EndUser',ce.ActorType);
        DataBase.executebatch(obj);         
    } 
}