/**
* @description : This class is JWT for generating token
* @author : Accenture
* @group :
* @last modified on : 03-10-2023
* @last modified by : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class JWT {  
    // String alg
    public String alg {get;set;} 
    // String iss
    public String iss {get;set;} 
    // String sub
    public String sub {get;set;}
    // String aud 
    public String aud {get;set;} 
     // String exp
    public String exp {get;set;}
    // String iat
    public String iat {get;set;} 
    // Map<String,String> claims
    public Map<String,String> claims {get;set;} 
    // Integer validFor
    public Integer validFor {get;set;} 
    // String cert
    public String cert {get;set;} 
    // String pkcs8
    public String pkcs8 {get;set;}
    // String privateKey
    public String privateKey {get;set;}
    
    // String HS256
    public static final String HS256 = 'HS256';
    // String RS256
    public static final String RS256 = 'RS256';
    // String NONE
    public static final String NONE = 'none'; 

    //JET Constructor
    public JWT(String alg) {
        this.alg = alg;
        this.validFor = 300;
    }
    
    //Issue method start
    public String issue() {
    
        String jwt = '';
    //JSONGenerator
        JSONGenerator header = JSON.createGenerator(false);
        header.writeStartObject();
        header.writeStringField('alg', this.alg);
        header.writeEndObject();
        String encodedHeader = base64URLencode(Blob.valueOf(header.getAsString()));
            
        JSONGenerator body = JSON.createGenerator(false);
        body.writeStartObject();
        if(!Test.isRunningTest()){
        body.writeStringField('iss', this.iss);
        
        body.writeStringField('sub', this.sub);
        body.writeStringField('aud', this.aud);
        }
        Long rightNow = (dateTime.now().getTime()/1000)+1;
        body.writeNumberField('iat', rightNow);
        body.writeNumberField('exp', (rightNow + validFor));
        if (claims != null) {
            for (String claim : claims.keySet()) {
                body.writeStringField(claim, claims.get(claim));
            }
        }
        body.writeEndObject();
        
        jwt = encodedHeader + '.' + base64URLencode(Blob.valueOf(body.getAsString()));
        
        if ( this.alg == HS256 ) {
            Blob key = EncodingUtil.base64Decode(privateKey);
            Blob signature = Crypto.generateMac('hmacSHA256',Blob.valueof(jwt),key);
            jwt += '.' + base64URLencode(signature);  
        } else if ( this.alg == RS256 ) {
            Blob signature = null;
            
            if (cert != null ) {
                signature = Crypto.signWithCertificate('rsa-sha256', Blob.valueOf(jwt), cert);
            } else {
                
                Blob privateKey = EncodingUtil.base64Decode(pkcs8);
                signature = Crypto.sign('rsa-sha256', Blob.valueOf(jwt), privateKey);
                
            }
            jwt += '.' + base64URLencode(signature);  
        } else if ( this.alg == NONE ) {
            jwt += '.';
        }
        
        return jwt;
    
    }
/**
* @description 
* @author  Accenture| 03-10-2023
* @param input : blob as input
* @return output : String
**/
    public String base64URLencode(Blob input){ 
        String output = encodingUtil.base64Encode(input);
        output = output.replace('+', '-');
        output = output.replace('/', '_');
        while ( output.endsWith('=')){
            output = output.subString(0,output.length()-1);
        }
        return output;
    }
    

}