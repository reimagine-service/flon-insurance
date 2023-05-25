/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-24-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class RS_VCHandler_TestClass {
    @istest
    public static void transferCallTest(){
        List<VoiceCall> transcalllist = new List<VoiceCall>();
        VoiceCall vc= new VoiceCall();
        vc.VendorType ='ContactCenter';
        vc.CallType='Transfer';
        vc.ToPhoneNumber = '+18334133093';
        vc.FromPhoneNumber= '+16617480240';
        vc.CallStartDateTime =date.newInstance(2022, 20, 18);
        vc.CallEndDateTime = date.newInstance(2022, 20, 18);
        insert vc;
        transcalllist.add(vc);
        RS_VCHandler transcallhandler = new RS_VCHandler();
        Test.startTest();
        transcallhandler.handleAfterInsert(transcalllist);
        System.assertEquals('Transfer', vc.CallType);
    }
     @istest
    public static void callbackCallTest(){
        List<VoiceCall> transcalllist = new List<VoiceCall>();
        VoiceCall vc= new VoiceCall();
        vc.VendorType ='ContactCenter';
        vc.CallType='Callback';
        vc.ToPhoneNumber = '+18334133093';
        vc.FromPhoneNumber= '+16617480240';
        vc.CallStartDateTime =date.newInstance(2022, 20, 18);
        vc.CallEndDateTime = date.newInstance(2022, 20, 18);
        insert vc;
        transcalllist.add(vc);
        RS_VCHandler transcallhandler = new RS_VCHandler();
        Test.startTest();
        transcallhandler.handleAfterInsert(transcalllist);
        System.assertEquals('Callback', vc.CallType);
    }

}