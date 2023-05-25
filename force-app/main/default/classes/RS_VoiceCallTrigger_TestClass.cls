@isTest
public class RS_VoiceCallTrigger_TestClass {
@isTest static void RS_VoiceCallTriggerMethod () {
VoiceCall voicec = new VoiceCall();
    voicec.FromPhoneNumber ='+1203-411-567';
    voicec.callType= 'Inbound';
    voicec.VendorType ='ContactCenter';
    voicec.CallStartDateTime = Date.newInstance(2022, 02, 18);
    voicec.CallEndDateTime = Date.newInstance(2022,02,18);
    voicec.ToPhoneNumber ='+1203-411-567';
    Database.insert(voicec);
    System.assertEquals('Inbound',voicec.callType);
}
}