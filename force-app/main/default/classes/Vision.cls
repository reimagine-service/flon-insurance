/**
* @description       : Sentiment Analysis
* @author            : Accenture
* @group             : 
* @last modified on  : 02-25-2022
* @last modified by  : Accenture
**/
public class Vision{
    /**
    * @description : This is predictSentiment method for Sentiment Analysis .
    * @Return : List<Prediction>
    * @Method Name : predictSentiment
    * @param: sample,accessToken,model
    **/          
    public static List<Prediction> predictSentiment(String sample, String accessToken, String model) {
        RS_Einstein_Sentiment_Settings__mdt sentiSettings = RS_Einstein_Sentiment_Settings__mdt.getInstance('X1');
       	string form64 = '------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name="modelId"\r\n\r\n'+model+'\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name="document"\r\n\r\n'+sample+'\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW--';
        
		//  Compose the http request
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setBody(form64);
        //httpRequest.setHeader('Connection', 'keep-alive');
        httpRequest.setHeader('Content-Length', string.valueof(form64.length()));
        httpRequest.setHeader('Content-Type', 'multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW');
        httpRequest.setHeader('cache-control', 'no-cache');
        httpRequest.setMethod('POST');
        httpRequest.setTimeout(120000);
        httpRequest.setHeader('Authorization','Bearer ' + accessToken);
        httpRequest.setEndpoint(sentiSettings.Einstein_API__c);
        Http http = new Http();
        List<Prediction> predictions = new List<Prediction>();
        try {
              HTTPResponse res = http.send(httpRequest);
              if (res.getStatusCode() == 200) {
                  System.JSONParser parser = System.JSON.createParser(res.getBody());
                  System.debug('parser--> '+ parser);
                  //System.assertEquals(parser, parser);
                  while (parser.nextToken() != null) {
                      if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'probabilities')) {
                          parser.nextToken();
                            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                                while (parser.nextToken() != null) {
                                    // Advance to the start object marker to
                                    //  find next probability object.
                                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                                        // Read entire probability object
                                        Prediction probability = (Prediction)parser.readValueAs(Vision.Prediction.class);
                                        predictions.add(probability);
                                    }
                                }
                            }
                      break;
                      }
                  }
              }
              
         } catch(System.CalloutException e) {
                System.debug('ERROR:' + e);
         }
         return(predictions);
    }
/********************************************************/
    public class Prediction {
        public String label {get;set;} // String label
        public Double probability {get;set;} // Double probability
    }
}