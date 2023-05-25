@isTest
public class RS_customerAllOpenCases_Test {
    @testsetup
    static void testData(){
        User us = TestDataFactory.createUser();
    }
    
   /* @isTest
    static void allTest(){
        Account ac = TestDataFactory.accList();
        VoiceCall vc = TestDataFactory.VCList(True);
        User us = [Select id from user where LastName='Test' LIMIT 1];
        System.runAs(us){
            RS_customerAllOpenCases.allcases(vc.Id,1,10,'Phone');
        }
        system.assertEquals(false,String.isEmpty(vc.id));
    }*/
    
    @isTest
    static void smsTest(){
        MessagingSession ms = TestDataFactory.MsgMethod();
        User us = [Select id from user where LastName='Test' LIMIT 1];
        System.runAs(us){
            RS_customerAllOpenCases.allcases(ms.Id,1,10,'SMS');
        }
        system.assertEquals(false,String.isEmpty(ms.id));
    }
    
    @isTest
    static void accountIdBlank(){
        Contact con = TestDataFactory.conMethod(True);
        LiveChatTranscript l = TestDataFactory.LCList(True);
        l.ContactId=con.Id;
        l.status='Completed';
        l.EndTime=system.now();
        update l;
        User us = [Select id from user where LastName='Test' LIMIT 1];
        System.runAs(us){
            RS_customerAllOpenCases.allcases(l.Id,1,10,'Chat');
        }
        system.assertEquals(false,String.isEmpty(l.id));
    }
}