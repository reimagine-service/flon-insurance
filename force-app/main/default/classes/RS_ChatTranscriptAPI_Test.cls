/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-23-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@IsTest
public class RS_ChatTranscriptAPI_Test {
     @TestSetup
    public static void testDataMethod(){
        Case cs=TestDataFactory.CaseMethod(true);
     
            ContentVersion contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.txt',
            VersionData =  Blob.valueOf('[null,{"botResponse":["Hi, I am your virtual assistant. I am here to help you!"]},{"botResponse":["Help me identify you!","Please select from the options below"]},{"botResponse":["Account Number, Registered Phone Number, Email"]},{"userMessage":"Account Number"},{"botResponse":["Please tell me your 6-digit account number"]},{"userMessage":"778899"},{"botResponse":["Thank You for your input","Please provide your date of birth to help us verify your account."]},{"botResponse":["Date picker"]},{"userMessage":"10/02/2000"},{"botResponse":["Sorry! Date of Birth provided by you does not match with our records"]},{"botResponse":["Please provide your date of birth to help us verify your account."]},{"botResponse":["Date picker"]},{"userMessage":"10/03/2000"},{"botResponse":["What would you like to do?","Please select from the quick options below or type in your query"]},{"botResponse":["Billing, My Policy, Check my Claim Status, Update my Account Information, Track my Case Progress"]},{"userMessage":"Billing"},{"botResponse":["Please let me know your issue"]},{"botResponse":["Check Bill, Pay Bill, Other Billing Questions"]},{"userMessage":"Check Bill"},{"botResponse":["Your bill for amount 1510 is due on 2023-02-15"]},{"botResponse":["Is there anything else I can help you with?"]},{"botResponse":["Yes, No"]}]'),
            IsMajorVersion = true
        );
        insert contentVersion; 
    }
     @IsTest
    public static void jsonToLWCTest(){
        Case cs=[Select id from case limit 1];
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
          //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = cs.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl; 
        test.startTest();
        RS_ChatTranscriptAPI.JsonToLWC(cs.id);
        test.stopTest();
        System.assertEquals('V',cdl.shareType);
    }

}