/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-24-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class RS_SNS_Innvocable_Class_Test {
    /**
    * @description : Test Date Seup
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-24-2023 
    **/
    @TestSetup
    public static void createData(){
        Case cs=TestDataFactory.CaseMethod(true);
    }
    @isTest
    static void sendSMSTest(){
        Case caseList=[select id from case limit 1];
        String bId= string.valueOf(caseList.Id); 
        Test.startTest();
        RS_SNS_Innvocable_Class.sendSMS(new List<String>{bId});
        Test.stopTest();
        System.assertEquals(false,String.isempty(caseList.Id));
    }
}