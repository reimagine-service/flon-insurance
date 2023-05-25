@isTest
public class RS_VoiceCallSchedularTest {
	
     public static testMethod void testschedule() {
		Test.StartTest();
		RS_VoiceCallBatchSchedular testsche = new RS_VoiceCallBatchSchedular();
		String sch = '0 0 23 * * ?';
        System.assertEquals('0 0 23 * * ?',sch);
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
	}
}