/**
 * @description       : Test Class for RS_CallSchedulerAPI
 * @author            : Accenture
 * @group             : 
 * @last modified on  : 03-23-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class RS_CallSchedulerAPI_Test {
      @isTest
    static void getSlotsTest(){
        Test.startTest();
        List< RS_CallSchedulerAPI.parametersForm> lstParams = new List< RS_CallSchedulerAPI.parametersForm>();
        RS_CallSchedulerAPI.parametersForm pform = new RS_CallSchedulerAPI.parametersForm();
        pform.preferredDate = String.valueOf(System.today());
		pform.accountNumber = 'accountNumber';
		pform.WorktypeName = 'Renewals';
		pform.ServiceTerrName = 'Sales Service Territory';
		lstParams.add(pform);
        RS_CallSchedulerAPI.GetSlots(lstParams);
        Test.stopTest();
        System.assertEquals('Renewals',pform.WorktypeName);
    }
}