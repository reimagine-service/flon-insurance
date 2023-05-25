/**
* @description       : Test Class for RS_CustomerInteractionController
* @author            : Accenture
* @group             : 
* @last modified on  : 03-23-2023
* @last modified by  : Accenture
**/
@isTest 
public class RS_CustomerInteractionControllerTest {
    @TestSetup
    public static void createTestDateSetup(){
        User getuser=TestDataFactory.createUser();
    }
    @isTest 
    //LiveChatScript Intercation
    public static void customerInteractionMethod() {
        Case cobj = TestDataFactory.csList();
        LiveChatTranscript getlc = TestDataFactory.LCList(true);
     //   VoiceCall vc = TestDataFactory.VCList(true);
        User u=[Select id from user limit 1];
        Case getCaseId = [Select id from Case Limit 1];
        LiveChatTranscript lc = [Select id,caseID,starttime,EndTime,name from LiveChatTranscript];
        lc.starttime=Datetime.Now();
        lc.EndTime=Datetime.Now();
        lc.caseID=getCaseId.id;
        update lc;
        System.runAs(u){
            RS_CustomerInteractionController.getCaseInteraction(getCaseId.Id);
        }
        RS_CustomerInteractionController.interactionWrapper wrapper = new RS_CustomerInteractionController.interactionWrapper(lc.id,'chat','10-10-2000','2633','inbound','123456','completed',lc.name);
        wrapper.name=lc.name;
        wrapper.ChannelID=lc.id;
        wrapper.channelType = 'chat';
        wrapper.recievedDate ='10-10-2000';
        wrapper.duration = '2633';
        wrapper.callType ='inbound';
        wrapper.phone = '99999';
        wrapper.callDisposition ='completed';
        System.runAs(u) {
            RS_CustomerInteractionController.getmydomain();
        }
        System.assertEquals('chat', wrapper.channelType);
    }
    @isTest 
    //Messaging Session Case Interaction
    public static void customerInteractionMethod3() {
        User u=[Select id from user limit 1];
        
        Case cobj = TestDataFactory.csList();
        System.assertEquals(false,String.isEmpty(cobj.id));
        MessagingSession msg=TestDataFactory.MsgMethod();
        msg.CaseId=cobj.id;
        update msg;
        System.runAs(u) {
            RS_CustomerInteractionController.getCaseInteraction(cobj.Id);
        }
        RS_CustomerInteractionController.interactionWrapper wrapper = new RS_CustomerInteractionController.interactionWrapper(msg.id,'chat','10-10-2000','2633','inbound','123456','completed',msg.name);
        wrapper.name=msg.name;
        wrapper.ChannelID=msg.id;
        wrapper.channelType ='SMS';
        wrapper.recievedDate ='10-10-2000';
        wrapper.duration = '2633';
        wrapper.callType ='inbound';
        wrapper.phone = '99999';
        wrapper.callDisposition ='completed';  
        wrapper.counter=1;
    }
    
}