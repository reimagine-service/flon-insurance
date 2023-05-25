/**
* @description : this class is to generate access token
* @author : Accenture
* @group :
* @last modified on : 04-20-2022
* @last modified by : Accenture
**/
public class JWTBearerFlow {
    /**
    * @description : This is getAccessToken method to get access token
    * @Return : String
    * @Method Name : getAccessToken
    **/
    public static String getAccessToken(String tokenEndpoint, JWT jwt) {
    
        String accessToken = null;
        String body;
        if(!Test.isRunningTest()){
        body = 'grant_type=urn%3Aietf%3Aparams%3Aoauth%3Agrant-type%3Ajwt-bearer&assertion=' + jwt.issue();
        }
            HttpRequest req = new HttpRequest();                            
        req.setMethod('POST');
        req.setEndpoint(tokenEndpoint);
        req.setHeader('Content-type', 'application/x-www-form-urlencoded');
        if(!Test.isRunningTest()){
        req.setBody(body);
        }
        Http http = new Http();               
        HTTPResponse res = http.send(req);
        system.debug(res.getbody());
        if ( res.getStatusCode() == 200 ) {
            System.JSONParser parser = System.JSON.createParser(res.getBody());
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'access_token')) {
                    parser.nextToken();
                    accessToken = parser.getText();
                    break;
                }
            }
        }
        return accessToken;
        
    }

}