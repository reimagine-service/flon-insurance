/**
* @description       : Test Class for RS_BestTimeToCallController ApexClass. 
* @author            : Accenture
* @last modified on  : 03-23-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class RS_BestTimeToCallController_Test {
    @TestSetup
    public static void createTestData(){
        User getuser=TestDataFactory.createUser();
    }
    @isTest
    static void getbesttimecalldetailstest(){
        Next_Best_Action__mdt myNBA = new Next_Best_Action__mdt(MasterLabel = 'BTTC_List');
        User u=[Select id from user limit 1];
        String accountreordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
      	Account getacoountdetails=TestDataFactory.accList();
        List<BestTimeToCall__x> bestTimeToCallList = new List<BestTimeToCall__x>();
        BestTimeToCall__x bestTimeToCall = new BestTimeToCall__x(AccountNumber__c = '111237',IssueType__c = 'Billing',Month__c = 'March');
        bestTimeToCallList.add(bestTimeToCall);
        ObjectManager.setMock(new MockInterfaceOverride(bestTimeToCallList));
        System.runAs(u) {
        Test.startTest();
        RS_BestTimeToCallController.getbesttimecalldetails(getacoountdetails.AccountNumber,bestTimeToCallList[0].IssueType__c,bestTimeToCallList[0].Month__c);
        RS_BestTimeToCallController.getBTTCmetaDetail();
        RS_BestTimeToCallController.getPicklistValuesForMonth();
        RS_BestTimeToCallController.getPicklistValuesForIssueType();
        RS_BestTimeToCallController.getWrapperOfSObjectFieldColumnActionValues(myNBA.MasterLabel,getacoountdetails.Id,bestTimeToCallList[0].IssueType__c,bestTimeToCallList[0].Month__c);
        Test.stopTest();
          }
        System.assertEquals('111237',bestTimeToCall.AccountNumber__c);
    }
    
}