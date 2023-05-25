/**
 * @description       : Test Class for RS_InsuranceDetailsPortalView
 * @author            : Accenture
 * @group             : 
 * @last modified on  : 03-24-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@IsTest
public class RS_InsuranceDetailsPortalViewTest {
    /**
    * @description : Test data setup
    * @author Accenture | 03-24-2023 
    **/
    @TestSetup
    public static void createTestData(){
        String accountrecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('BusinessAccount').getRecordTypeId();
        List<Account> accList = new List<Account>();
        Account acc = new Account();
        acc.AccountNumber='123456';
        acc.Name='fName';
        acc.Service_Recovery__c=false;
        acc.Phone='+18334133093';
        acc.OwnerId=[Select Id from user where UserRoleId!=null LIMIT 1].id;
        acc.RecordTypeId=accountrecordtypeid;
        accList.add(acc);
        insert accList;
        Contact con=TestDataFactory.conMethod(true);
        con.AccountId=accList[0].id;
        update con;
    }
    @isTest
    public static void testInsuranceDetails(){
        Contact con=[select id,AccountId from contact limit 1];
        User usr = new User();
        usr.ProfileId = [SELECT Id FROM Profile WHERE Name= 'Read Only Community User' limit 1].Id;                           
        usr.LastName = 'Test';
        usr.Email = 'test@test.com';
        usr.Username = 'test@test.com' + System.currentTimeMillis();
        usr.CompanyName = 'Salesforce';
        usr.Title = 'Title';
        usr.Alias = 'Roger';
        usr.TimeZoneSidKey = 'America/Los_Angeles';
        usr.EmailEncodingKey = 'UTF-8';
        usr.LanguageLocaleKey = 'en_US';
        usr.LocaleSidKey = 'en_US';
        usr.RS_Guided_Workflow_Rooting_Criteria__c='ProfileId';
        usr.ContactId=con.id;
        insert usr;
        System.assertEquals('Test',usr.LastName);
        Permissionset p =[select id from permissionset where name='RSI_Customer_Protal_User'];
        insert new Permissionsetassignment(AssigneeId=usr.id,permissionsetid=p.id);
        test.startTest();
        RS_InsuranceDetailsPortalView.getInsuranceAgentDetails(usr.Id);
        test.stopTest();
    }
}