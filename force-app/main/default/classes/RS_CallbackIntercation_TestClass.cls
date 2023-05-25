/**
 * @description       : Test Class for RS_CallbackInteractionController
 * @author            : Accenture
 * @group             : 
 * @last modified on  : 03-23-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@Istest
public class RS_CallbackIntercation_TestClass {
    
    @Istest
    public static void testMethod1()
    {
        Account accobj = TestDataFactory.accList();
        VoiceCall vc=TestDataFactory.VCList(true);
        vc.Related_Account__c=accobj.id;
        vc.RS_Preferred_Callback_Time__c = date.newInstance(2022, 20, 12);
        update vc;
        DateTime preferredDateTime=vc.RS_Preferred_Callback_Time__c;
        String todayEST=preferredDateTime.format('yyyy-MM-dd HH:mm:ss','EST');
        Datetime dtToday = DateTime.valueOf(todayEST);
        String receivedDateTime = String.valueOf(vc.CallStartDateTime);
        RS_CallbackInteractionController.getCallbackInteraction(accobj.Id);
        RS_CallbackInteractionController.getmydomain();
        RS_CallbackInteractionController.callbackWrapper wrapper = new RS_CallbackInteractionController.callbackWrapper(vc.id,vc.IVRIntent__c,todayEST,'Phone','Completed','VoiceCall-001',0,vc.IVRType__c,receivedDateTime);
        wrapper.name='VoiceCall-001';
        wrapper.receivedDateTime=receivedDateTime;
        wrapper.CallReason=vc.IVRType__c;
        wrapper.channelID=vc.id;
        wrapper.IssueType =vc.IVRIntent__c;
        wrapper.preferredCallbackTime= todayEST;
        wrapper.phone ='Phone';
        wrapper.callDisposition ='Completed';
        wrapper.counter=0;
        System.assertEquals('Phone',wrapper.phone);
    }
}