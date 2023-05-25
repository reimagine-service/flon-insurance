/**
 * @description       : Class to fetch and return the Current Logged in User at Caip
 * @author            : Accenture
 * @group             : 
 * @last modified on  : 03-24-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@RestResource(urlMapping='/LoggedInUser/*')
global with sharing class RS_LoggedInUser {
    /**
    * @description : Method to fetch and return the Current Logged in User at Caip
    * @author Accenture | 03-24-2023 
    * @return User 
    **/
    @HttpGet
    global static User userDetails() {
       
        User userInfo = new User();
        
        RestRequest userRequest = RestContext.request;
		String userRequestURI = userRequest.requestURI;
        String userId = userRequestURI.substring(userRequestURI.lastIndexOf('/') + 1);
        
		userInfo = [Select id, FirstName, LastName, AccountId, ContactId from User where Id=:userId WITH SECURITY_ENFORCED];        
        
        if(String.isNotEmpty(userId)) {
            userInfo = [Select id, FirstName, LastName, AccountId, Account.AccountNumber, ContactId,Account.PersonBirthdate from User where Id=:UserId WITH SECURITY_ENFORCED];
            
        }
            return userInfo;
        }
    }