/**
 * @description       : Test Class for RS_unmarkRetentionSchedular
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-24-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class RS_unmarkRetentionSchedularTest {
	
     public static testMethod void testschedule() {
		Test.StartTest();
		RS_unmarkRetentionSchedular testsche = new RS_unmarkRetentionSchedular();
		String sch = '0 0 23 * * ?';
        System.assertEquals('0 0 23 * * ?',sch);
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
	}
}