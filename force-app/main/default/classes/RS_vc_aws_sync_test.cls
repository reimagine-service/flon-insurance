/**
* @description       : Test Class for RS_vc_aws_sync ApexClass
* @author            : Accenture
* @group             : 
* @last modified on  : 03-24-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class RS_vc_aws_sync_test{
	
    @isTest
     public static void testMethod1(){
        VoiceCall vcobj = TestDataFactory.VCList(True);
        RS_vc_aws_sync.updateCustomerInfo(vcObj.RS_ContactId__c, vcObj.RS_CustomerAccountNumber__c, vcObj.RS_CustomerVerified__c, vcObj.RS_Customer_Identified__c, vcObj.Related_Account__c, vcObj.RS_DateOfBirth__c,vcObj.RS_Switch_To_SMS__c,vcObj.RS_Switching_Status__c);
        System.assertEquals(false,String.isempty(vcobj.id));
      }
}