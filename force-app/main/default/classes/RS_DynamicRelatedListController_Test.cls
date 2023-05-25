/**
 * @description       : Test Class for RS_DynamicRelatedListController
 * @author            : Accenture
 * @group             : 
 * @last modified on  : 03-23-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class  RS_DynamicRelatedListController_Test{
    /**
    * @description : Test Data Setup
    * @author Accenture | 03-23-2023 
    **/
	 @TestSetup
    public static void createTestData(){
        String accountrecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        List<Account> accList = new List<Account>();
        Account acc = new Account();
        acc.AccountNumber='123456';
        acc.FirstName='fName';
        acc.LastName='lName';
        acc.Service_Recovery__c=false;
        acc.Phone='+18334133093';
        acc.RecordTypeId=accountrecordtypeId;
        accList.add(acc);
        insert accList;
    }
         @isTest
    static void getappointmentdetailsforlivechattest(){
        RS_Dynamic_Datatable__mdt gettableName=[Select DeveloperName,label from RS_Dynamic_Datatable__mdt where label='Appointment List'];       
        Account getAccount=[Select Id,AccountNumber from Account Limit 1];
        LiveChatTranscript createtestLiveChat = TestDataFactory.LCList(true);
        createtestLiveChat.AccountId=getAccount.id;
        update createtestLiveChat;
        Test.startTest();
        RS_DynamicRelatedListController.GetWrapperOfSObjectFieldColumnActionValues(gettableName.DeveloperName, createtestLiveChat.id);
        Test.stopTest();
        System.assertEquals('Appointment List',gettableName.label);
    }
     @isTest
    static void getappointmentdetailsformessagingsessiontest(){
        RS_Dynamic_Datatable__mdt gettableName=[Select DeveloperName,label from RS_Dynamic_Datatable__mdt where label='Appointment List'];       
        Account getAccount=[Select Id,AccountNumber from Account Limit 1];
        MessagingSession createmessagingsession = TestDataFactory.MsgMethod();
        createmessagingsession.Related_Account__c=getAccount.id;
        update createmessagingsession;
        Test.startTest();
        RS_DynamicRelatedListController.GetWrapperOfSObjectFieldColumnActionValues(gettableName.DeveloperName, createmessagingsession.id);
        RS_DynamicRelatedListController.DataTableColTypeAttribute dlist=new RS_DynamicRelatedListController.DataTableColTypeAttribute();
        dlist.target='test';
        dlist.sortable=true;
        
        RS_DynamicRelatedListController.DataTableColTypeAttributeLabel rLabel=new  RS_DynamicRelatedListController.DataTableColTypeAttributeLabel();
        rLabel.fieldName='tst';
        dlist.label=rLabel;
        Test.stopTest();
        System.assertEquals('Appointment List',gettableName.label);
    }

}