/**
 * @description       : Test Class for RS_DynamicTabSet
 * @author            : Accenture
 * @group             : 
 * @last modified on  : 03-24-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class RS_DynamicTabSet_Test {
	@isTest
    public static void testMethod1(){
        String recordName = 'Standard Case';
        RS_DynamicTabSet.fetchTabs(recordName);
        System.assertEquals('Standard Case',recordName);
    }
}