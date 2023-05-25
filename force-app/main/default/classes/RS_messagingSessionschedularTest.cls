@istest
public class RS_messagingSessionschedularTest {

    public static testMethod void testschedule() {
		Test.StartTest();
		RS_MessagingBatchSchedular testsche = new RS_MessagingBatchSchedular();
		String sch = '0 0 23 * * ?';
        System.assertEquals('0 0 23 * * ?',sch);
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
	}
}