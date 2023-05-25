/**
* @description       : This is RS_PredictionController class to get Access Token
* @author            : Accenture
* @group             : 
* @last modified on  : 04-20-2022
* @last modified by  : Accenture
**/
public class RS_PredictionController {
    public String getAccessToken() {
        Document base64Content;
        RS_Einstein_Sentiment_Settings__mdt Sentisettings = RS_Einstein_Sentiment_Settings__mdt.getInstance('X1');
        base64Content=[select body,Name from Document where Name=:Sentisettings.Document_Name__c LIMIT 1];
        String keyContents = base64Content.body.tostring();
        keyContents = keyContents.replace('-----BEGIN RSA PRIVATE KEY-----', '');
        keyContents = keyContents.replace('-----END RSA PRIVATE KEY-----', '');
        keyContents = keyContents.replace('\n', '');
        // Get a new token
        JWT jwt = new JWT('RS256');
        // jwt.cert = 'JWTCert'; // Uncomment this if you used a Salesforce certificate to sign up for an Einstein Platform account
        jwt.pkcs8 = keyContents; // Comment this if you are using jwt.cert
        jwt.iss = 'developer.force.com';
        jwt.sub = Sentisettings.JWT_Email__c;
        jwt.aud = Sentisettings.Endpoint__c;
        jwt.exp = '3600';
         
        String access_token;
        if(!Test.isRunningTest()){
        access_token = JWTBearerFlow.getAccessToken(Sentisettings.Endpoint__c,jwt);
        
        }
       
        return access_token;    
        
    }
    
}