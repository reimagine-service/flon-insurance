/**
* @description       : 
* @author            : Accenture
* @group             : 
* @last modified on  : 03-24-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class RS_TogetCaseNumberTest {
    @isTest
    public static void togetCaseNumberTestMethod() {
        List<String> str= new List<String>();
        str.add('For Case Number 00001945, regarding Billing Issue');
        List<String> lst = RS_TogetCaseNumber.getCaseNumber(str);
        system.assertEquals(lst[0], '1945');
    }
}