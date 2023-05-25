/**
* @description       : Test Class for RS_SwitchToVoiceAction
* @author            : Accenture
* @group             : 
* @last modified on  : 03-23-2023
* @last modified by  : Accenture
**/
@IsTest
public class RS_SwitchToVoiceAction_TestClass {
    /**
* @description : Test Data Setup
* @author Accenture| 03-23-2023 
**/
    @TestSetup
    static void testdata(){
        User us=TestDataFactory.createUser();
    }
    @IsTest
    static void switchToVoiceTest(){
        User u=[Select id from user limit 1];
        MessagingSession msg = TestDataFactory.MsgMethod();
        System.runAs(u){
            RS_SwitchToVoiceAction.UpdateSwitchToVoice(msg.Id);
        }
        System.assertEquals(false,String.isempty(msg.Id));
    }
    
}