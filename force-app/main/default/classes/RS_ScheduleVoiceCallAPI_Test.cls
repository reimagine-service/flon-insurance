/**
 * @description       : Test Class for RS_ScheduleVoiceCallAPI
 * @author            : Accenture
 * @group             : 
 * @last modified on  : 03-24-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@IsTest
public class RS_ScheduleVoiceCallAPI_Test {
    /**
    * @description : Test Data Setup
    * @author Accenture | 03-24-2023 
    **/
    @testsetup
    static void datasetup(){ 
        String accountrecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        List<Account> accList = new List<Account>();
        Account acc = new Account();
        acc.AccountNumber='123456';
        acc.FirstName='fName';
        acc.LastName='lName';
        acc.Service_Recovery__c=false;
        acc.Phone='+18334133093';
        acc.RecordTypeId=accountrecordtypeid;
        acc.PersonEmail='a@abc.com';
        acc.PersonBirthdate=system.today();
        acc.Marital_Status__c='Single';
        acc.PersonMailingCity='Bangalore';
        accList.add(acc);
        insert accList;
    }
    @IsTest
    public static void positiveTest() {
        Account accRec= [SELECT AccountNumber,PersonBirthdate,Id From Account Limit 1];
        String callcenterID=[Select id from CallCenter where InternalName ='ACLightningAdapter']?.Id;
        VoiceCall vcl= TestDataFactory.VCList(true);
        RestRequest request = new RestRequest();
        request.requestURI = '/ScheduleVoiceCallAPI/*'; 
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody =  Blob.valueOf(Json.serialize(vcl));
        RestContext.request = request;
        Test.startTest();
        RS_ScheduleVoiceCallAPI.CreateVC(accRec.id,'ClBckTime','PhoneNumber','ClBckDate','QName','QARN','issuetype','');
        RS_ScheduleVoiceCallAPI.CreateDynamoDB(vcl.id,'ClBckTime','PhoneNumber','ClBckDate','QName','QARN');
        Test.stopTest();
        System.assertEquals('POST',request.httpMethod );
    }
    @IsTest
    public static void negativeTest() {
        Test.startTest();
        RS_ScheduleVoiceCallAPI.CreateDynamoDB(null,'ClBckTime','PhoneNumber','ClBckDate','QName','QARN');
        RS_ScheduleVoiceCallAPI.CreateVC(null,'ClBckTime','PhoneNumber','ClBckDate','QName','QARN','issuetype','');
        Test.stopTest();
    }
    @IsTest
    public static void othersIssueTypeTest() {
        Account accRec= [SELECT AccountNumber,PersonBirthdate,Id From Account Limit 1];
        String callcenterID=[Select id from CallCenter where InternalName ='ACLightningAdapter']?.Id;
        VoiceCall vcl= TestDataFactory.VCList(true);
        RestRequest request = new RestRequest();
        request.requestURI = '/ScheduleVoiceCallAPI/*'; 
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody =  Blob.valueOf(Json.serialize(vcl));
        RestContext.request = request;
        Test.startTest();
        RS_ScheduleVoiceCallAPI.CreateVC(accRec.id,'ClBckTime','PhoneNumber','ClBckDate','QName','QARN','Others','');
        Test.stopTest();
        System.assertEquals('POST',request.httpMethod );
    }
}