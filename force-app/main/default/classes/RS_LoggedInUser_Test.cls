/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-24-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@IsTest
public class RS_LoggedInUser_Test {
    @IsTest
    public static void userInfoTest() {
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/LoggedInUser/0053C000004o8AKQAY'; 
        req.httpMethod = 'GET';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res;     
        RS_LoggedInUser.UserDetails();
        Test.stopTest();
        
        /*Test.startTest();
        RS_LoggedInUser.UserDetails();
        Test.stopTest();
        */
        
    }
}