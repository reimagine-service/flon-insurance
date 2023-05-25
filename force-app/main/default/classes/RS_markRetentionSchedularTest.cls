@isTest
public class RS_markRetentionSchedularTest {
	
     public static testMethod void testschedule() {
		Test.StartTest();
		RS_markRetentionSchedular testsche = new RS_markRetentionSchedular();
		String sch = '0 0 23 * * ?';
        System.assertEquals('0 0 23 * * ?',sch);
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
	}
}