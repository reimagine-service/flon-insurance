@isTest
public class RS_BusinessHoursTest {
    @isTest
    public static void businessHourslist(){
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/BHours/*'; 
        req.params.put('reqDateTime', '10/14/2023, 11:46 AM');
        req.httpMethod = 'GET';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res;
        
        Boolean bool=RS_BusinessHours.isBusinessHours();
        RS_BusinessHourBot.isBusinessHours(); 
        //system.assertEquals(true,bool);
        Test.stopTest();
        
    }
}