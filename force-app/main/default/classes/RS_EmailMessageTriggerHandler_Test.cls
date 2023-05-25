@IsTest
public class RS_EmailMessageTriggerHandler_Test {
    @Istest
    public static void testMethod1(){
        List<EmailMessage> emlist = new List<EmailMessage>();
        EmailMessage em =TestDataFactory.emList();
        System.assertEquals('0',em.Status);
        emlist.add(em);
        RS_EmailMessageTriggerHandler.afterInsert(emlist);
    }

}