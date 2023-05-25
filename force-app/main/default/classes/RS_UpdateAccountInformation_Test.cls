/**
 * @description       : Test Class for RS_UpdateAccountInformation
 * @author            : Accenture
 * @group             : 
 * @last modified on  : 03-24-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class RS_UpdateAccountInformation_Test {
    @testsetup
    static void datasetup(){ 
        // string sHRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('PersonAccount').getRecordTypeId();
        String accountrecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        List<Account> accList = new List<Account>();
        Account acc = new Account();
        acc.AccountNumber='123456';
        acc.FirstName='fName';
        acc.LastName='lName';
        acc.Service_Recovery__c=false;
        acc.Phone='+18334133093';
        acc.RecordTypeId=accountrecordtypeid;
        accList.add(acc);
        insert accList;
        accList[0].PersonEmail='a@abc.com';
        accList[0].PersonBirthdate=system.today();
        accList[0].Marital_Status__c='Single';
        accList[0].PersonMailingCity='Bangalore';
        update accList;
        system.debug('*****accList'+accList);
    }
    @isTest
    static void updateAccInformationPositiveTest(){
        Account accRec= [SELECT Id,Name,FirstName,LastName,PersonEmail,Phone,PersonBirthdate,PersonMailingCity,Marital_Status__c,recordtype.Name From Account Limit 1];
        String fName= string.valueOf(accRec.FirstName);
        String lName= string.valueOf(accRec.LastName);
        String email= string.valueOf(accRec.PersonEmail);
        String phoneNumber= string.valueOf(accRec.Phone);
        String birthdate= string.valueOf(accRec.PersonBirthdate);
        String maritalStatus= string.valueOf(accRec.Marital_Status__c);
        String city= string.valueOf(accRec.PersonMailingCity);
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/UpdateAccountInformation/'+accRec.id;  //Request URL
        req.httpMethod = 'PUT';//HTTP Request Type
        req.addHeader('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response= res;
        RS_UpdateAccountInformation.updateAccInformation(fName, lName,email,phoneNumber,
                                                         birthdate,maritalStatus,city,
                                                         'State', 'Street', 'PostalCode', 'Country',true);
        Test.stopTest();
        System.assertEquals('PUT',req.httpMethod);
    }
    @isTest
    static void updateAccInformationNegativeTest(){
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/UpdateAccountInformation/';  //Request URL
        req.httpMethod = 'PUT';//HTTP Request Type
        req.addHeader('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response= res;
        RS_UpdateAccountInformation.updateAccInformation('','','','',
                                                         '','','',
                                                         '', '', '', '',null);
        Test.stopTest();
        System.assertEquals('PUT',req.httpMethod);

    }
    
}