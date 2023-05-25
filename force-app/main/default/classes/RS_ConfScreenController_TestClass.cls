/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-23-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@IsTest
public class RS_ConfScreenController_TestClass {
	@IsTest
    public static void testGetCaseFields(){
        String tableName=[Select DeveloperName from RS_Dynamic_Datatable__mdt limit 1]?.DeveloperName;
        test.startTest();
        RS_ConfirmationScreenController.getCaseFields(tableName);
        test.stopTest();
        System.assertEquals(false,String.isEmpty(tableName));
    }
}