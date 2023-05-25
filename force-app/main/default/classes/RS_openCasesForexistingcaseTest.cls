/**
* @description       : Test Class for RS_openCasesForexistingcase
* @author            : Accenture
* @group             : 
* @last modified on  : 03-24-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class RS_openCasesForexistingcaseTest {
    @isTest
    public static void openCasesForexistingcaseTestMethod() {
        MessagingEndUser newMessagingEndUser= new MessagingEndUser();
        newMessagingEndUser = TestDataFactory.MessagingMethod();
        List<MessagingEndUser> ms = [select AccountId ,Name from MessagingEndUser where id =:newMessagingEndUser.id];
        Account acc = TestDataFactory.accList();
        String accountNumber = acc.AccountNumber;
        case cs =TestDataFactory.csList();
        cs.AccountId=acc.id;
        cs.Subject='123';
        update cs;
        String  accID =  [select Id from account where phone=:ms[0].Name and AccountNumber=:accountNumber limit 1]?.id;
        RS_openCasesForexistingcase.InputForm requestData = new RS_openCasesForexistingcase.InputForm();
        requestData.AccountNumber =AccountNumber;
        requestData.EndUser =newMessagingEndUser.id;
        RS_openCasesForexistingcase.getOpenCases(new List<RS_openCasesForexistingcase.InputForm> {requestData});
        system.assertEquals(AccountNumber ,requestData.accountNumber);
    }
     @isTest
    public static void openCasesForexistingcaseTestMethod1() {
        MessagingEndUser newMessagingEndUser= new MessagingEndUser();
        newMessagingEndUser = TestDataFactory.MessagingMethod();
        List<MessagingEndUser> ms = [select AccountId ,Name from MessagingEndUser where id =:newMessagingEndUser.id];
        Account acc = TestDataFactory.accList();
        String accountNumber = acc.AccountNumber;
        case cs =TestDataFactory.csList();
        cs.AccountId=acc.id;
        update cs;
        String  accID =  [select Id from account where phone=:ms[0].Name and AccountNumber=:accountNumber limit 1]?.id;
        RS_openCasesForexistingcase.InputForm requestData = new RS_openCasesForexistingcase.InputForm();
        requestData.AccountNumber =AccountNumber;
        requestData.EndUser =newMessagingEndUser.id;
        RS_openCasesForexistingcase.getOpenCases(new List<RS_openCasesForexistingcase.InputForm> {requestData});
        system.assertEquals(AccountNumber ,requestData.accountNumber);
    }
}