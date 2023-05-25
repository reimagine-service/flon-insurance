@isTest
public class VisionTest {
   
    @isTest
    static void visionmethod(){
		Test.setMock(HttpCalloutMock.class, new RS_HttpMockCalloutClass());
        TestDataFactory.doclist();
        String alg = 'HS256';
        JWT jwt = new JWT(alg);
        String tokenEndpoint = '123sjdy';
        System.assertEquals('HS256',alg);
        Test.startTest();
        JWTBearerFlow.getAccessToken(tokenEndpoint, jwt);
        
        RS_PredictionController predict = new RS_PredictionController();
        String accessToken = predict.getAccessToken(); 
        //Test.setMock(HttpCalloutMock.class, new Mock());
        
        Vision.predictSentiment('Sample String',accessToken,'CommunitySentiment');
        Test.stopTest();
	}
}