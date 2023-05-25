/**
 * @description       : Test Class for RS_sf_aws_sync
 * @author            : Accenture
 * @group             : 
 * @last modified on  : 03-24-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class RS_sf_aws_sync_test {
    @isTest
    public static void testMethod1(){
        VoiceCall vc = TestDataFactory.VCList(True);
        DateTime prefDatetime = DateTime.now()+5;
        RS_sf_aws_sync.reScheduleCallback(vc.id, prefDatetime);
        System.assertEquals(false,String.isempty(vc.id));
    }
    @isTest
    public static void testMethod2(){
        VoiceCall vc = TestDataFactory.VCList(True);
        System.assertEquals(false,String.isempty(vc.id));
        RS_sf_aws_sync.cancelCallback(vc.id);
    }
    @isTest
    public static void testMethod3(){
        VoiceCall vc = TestDataFactory.VCList(True);
        System.assertEquals(false,String.isempty(vc.id));
        //DateTime prefDatetime = DateTime.now()+5;
        //RS_sf_aws_sync.reScheduleCallback(vc.id, prefDatetime);
        Test.setMock(HttpCalloutMock.class, new RS_ScheduleCallbackMock());
        RS_sf_aws_sync.SchduleCallback(vc.id,'ClBckTime', 'PhoneNumber','ClBckDate','QName', 'QARN');
        
    }
    
    

}