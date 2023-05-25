/**
 * @description       : Api used to updated the account information on voicecall interactions
 * @author            : Accenture
 * @group             : 
 * @last modified on  : 03-24-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@RestResource(urlMapping='/UpdateAccountInformation/*')
global with sharing class RS_UpdateAccountInformation {
    @HttpPut
    global static Account updateAccInformation(String FName, String LName, String email, String PhoneNumber,
                                               String Birthdate, String MaritalStatus, String City, String State, 
                                               String Street, String PostalCode, String Country, Boolean Military) {
        try{
                                                       
                                                   
        // Initializing the request parameter with the incoming request
        RestRequest accRequest = RestContext.request;
		// Getting the request URI
        String accountRequestURI = accRequest.requestURI;
        // Getting the account id from the request URI
        String accId = accountRequestURI.substring(accountRequestURI.lastIndexOf('/') + 1);
        // Initializing account to upsert
        Account acc = new account();
        // Assigning id to the account if the account id obtained from the URL is not empty
        if(String.isNotEmpty(accId)) {
            acc.Id = accId;
        }
        if(String.isNotEmpty(FName)) {
            acc.FirstName = FName;
        }
        if(String.isNotEmpty(LName)) {
            acc.LastName = LName;
        }
		if(String.isNotEmpty(email)) {
            acc.PersonEmail = email;
        }
		if(String.isNotEmpty(PhoneNumber)) {
            acc.Phone = PhoneNumber;
        }
		if(String.isNotEmpty(Birthdate)) {
            acc.PersonBirthdate = Date.valueOf(Birthdate);
        }
		if(String.isNotEmpty(MaritalStatus)) {
			acc.Marital_Status__c = MaritalStatus;
        }
		if(String.isNotEmpty(City)) {
            acc.PersonMailingCity = City;
        }
		if(String.isNotEmpty(State)) {
            acc.PersonMailingState = State;
        }
		if(String.isNotEmpty(Street)) {
            acc.PersonMailingStreet = Street;
        }
		if(String.isNotEmpty(PostalCode)) {
            acc.PersonMailingPostalCode = PostalCode;
        }
		if(String.isNotEmpty(Country)) {
            acc.PersonMailingCountry = Country;
        }
		acc.RSI_Military__c = Military;
        // Upserting Account
        if(Schema.getGlobalDescribe().get('Account').getDescribe().isUpdateable()){
        upsert acc;
        }
        // Returning the contact in the response
        return acc;
        }catch(exception e){
            system.debug('ERROR >>>>>' + e.getMessage());
            Account acc = new account();
            return acc;
        }
    }

}