/**
* @description       : Test class for RS_GuidedFlowConfScreenController
* @author            : joel.samuel.s.penke@accenture.com
* @group             : SF
* @last modified on  : 03-24-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class RS_GuidedFlowConfScreenControllerTest {
    
    /**
    * @description : Test Data Setup
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-24-2023 
    **/
    @TestSetup
    public static void createCase(){
        User userTest=TestDataFactory.createUser();
    }
    
    @isTest
    public static void testConfirmationScreen(){
        Case createcase = TestDataFactory.CaseMethod(true);
        String choice = TestDataFactory.createAgentChoices();
        String caseId = ([SELECT Id from Case LIMIT 1]).Id;
        RS_DynamicSearch__mdt getmetaData=[select Object_Name__c,Lookup_Field_to_Link__c,Update_Case_Id__c from RS_DynamicSearch__mdt where label LIKE:'MessagingSession'  LIMIT 1];
        system.debug('getmetaData'+getmetaData);
        System.assertEquals(false,String.isEmpty(caseId));
        Test.startTest();
        User us = [Select id from user where LastName='Test' LIMIT 1];
        System.runAs(us){
            String getRecordTypeName=[Select DeveloperName from RecordType where SobjectType='Case' Limit 1]?.DeveloperName;
            RS_GuidedFlowConfScreenController.fetchFields('MessagingSession',getRecordTypeName);
            RS_GuidedFlowConfScreenController.getChoiceDetails(choice,createcase,'4',getRecordTypeName);
            RS_GuidedFlowConfScreenController.updateChoiceRecord(choice,getmetaData.Lookup_Field_to_Link__c,getmetaData.Update_Case_Id__c,caseId,caseId);
            RS_GuidedFlowConfScreenController.getCommunityURL(us.Id);
        }
        Test.stopTest();
        
    }
}