@istest
public class RS_PredictionControllerTest {
    
    @isTest
    public static void docMethod(){ 
        Test.setMock(HttpCalloutMock.class, new RS_HttpMockCalloutClass());
        
        String alg = 'HS256';
        JWT jwt = new JWT(alg);
        String tokenEndpoint = '123sjdy';
        System.assertEquals('HS256',alg);
        Test.startTest();
        JWTBearerFlow.getAccessToken(tokenEndpoint, jwt);
        TestDataFactory.doclist();
        
        RS_PredictionController predict = new RS_PredictionController();
        predict.getAccessToken(); 
        Test.stopTest();
    }  
}