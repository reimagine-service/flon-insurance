@IsTest
public class RS_Send_Message_On_Case_Creation_Test {
    @TestSetup
    public static void testDataMethod(){
        Case cs=TestDataFactory.CaseMethod(true);
        Account testAccount=TestDataFactory.accList();
        cs.AccountId=testAccount.Id;
        update cs;
    }
    @IsTest
    public static void sendSNSMessageTest(){
        Case caseList =[Select Account.FirstName,Account.Phone,CaseNumber,Id from Case LIMIT 1];
        List<String> caseIdList=new List<String>();
        caseIdList.add(caseList.Id);
        Test.startTest();
        RS_Send_Message_On_Case_Creation.sendSNSMessage(caseIdList);
        Test.stopTest();
    }

}