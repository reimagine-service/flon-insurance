@IsTest
public class RS_ServiceAppointmentScheduler_Test {
     public static testMethod void testschedule() {
		Test.StartTest();
		RS_ServiceAppointmentScheduler testsche = new RS_ServiceAppointmentScheduler();
		String sch = '0 0 23 * * ?';
        System.assertEquals('0 0 23 * * ?',sch);
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
	}
}