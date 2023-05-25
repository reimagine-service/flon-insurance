@isTest()
public class JWTtestclass {
    
    @isTest()
    public static void testJWTclass(){
        
        String alg = 'NONE';
        String iss = 'iss';
    	String sub = 'sub';
    	String aud = 'aud';
    	String exp = 'exp';
    	String iat = 'iat';
        Map<String,String> claims;
        String cert = 'rsa-sha256';
        String pkcs8 = '1234test';
        String privateKey = '1234hjk';
        
        JWT j = new JWT(alg);
            iss = j.iss;
            sub = j.sub;
            aud = j.aud;
            exp = j.exp;
            iat = j.iat;
            claims = j.claims;
            cert = j.cert;
            pkcs8 = j.pkcs8;
            privateKey = j.privateKey;
        
        String jwt = '';
        string s = j.issue();
        
    }

}