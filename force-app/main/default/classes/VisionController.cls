/*
Class Name  : VisionController
Description : This class is used to call JWT class for access token
*/

public without sharing class VisionController {
    /*// You can upload the `predictive_services.pem` into your Salesforce org as `File` sObject and read it as below
    public String getAccessToken() {
        // Ignore the File upload part and "jwt.pkcs" if you used a Salesforce certificate to sign up 
        // for an Einstein Platform account
        Document base64Content=[select body,Name from Document where Name=:Label.lbl_Einstein_API_Key_Name LIMIT 1];
        
        //String keyContents = base64Content.VersionData.tostring();
        String keyContents = base64Content.body.tostring();
        keyContents = keyContents.replace('-----BEGIN RSA PRIVATE KEY-----', '');
        keyContents = keyContents.replace('-----END RSA PRIVATE KEY-----', '');
        keyContents = keyContents.replace('\n', '');

        // Get a new token
        JWT jwt = new JWT('RS256');
        // jwt.cert = 'JWTCert'; // Uncomment this if you used a Salesforce certificate to sign up for an Einstein Platform account
        jwt.pkcs8 = keyContents; // Comment this if you are using jwt.cert
        jwt.iss = 'developer.force.com';
        jwt.sub = Label.lbl_EmailAssociatedWithKey;
        jwt.aud = Label.lbl_EinsteinAccessTokenEndPoint;
        jwt.exp = '3600';
        String access_token = JWTBearerFlow.getAccessToken(Label.lbl_EinsteinAccessTokenEndPoint, jwt);
       
        return access_token;    
    }*/
}