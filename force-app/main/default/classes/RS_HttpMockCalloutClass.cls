/**
* @description : this is RS_HttpMockCalloutClass class.
* @author : Accenture
* @group :
* @last modified on : 04-12-2022
* @last modified by : Accenture
**/

global class RS_HttpMockCalloutClass implements HttpCalloutMock {
    global static final String PRE_CREATED_CERTIFICATE_NAME = 'JWT'; // String PRE_CREATED_CERTIFICATE_NAME
    global static final String FAKE_TOKEN = 'fakeToken'; // String FAKE_TOKEN
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response.
        
        HTTPResponse res = new HTTPResponse();
        //System.assertEquals('POST', req.getMethod());
        
        res.setBody('{"scope":"api","access_token":"' + FAKE_TOKEN + '","probabilities":"Positive","value":"7.8234"}');
        res.setStatus('OK');
        res.setStatusCode(200);
        return res;
    }

}