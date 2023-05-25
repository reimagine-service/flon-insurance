/**
* @description       : This batch class is used for updating Chat transcript on Voice Call Records
* @author            : Accenture
* @group             : 
* @last modified on  : 02-25-2022
* @last modified by  : Accenture
**/
global class RS_VoiceCallBatch implements Database.Batchable<sObject>,Database.AllowsCallouts {
  
  global Database.QueryLocator start(Database.BatchableContext bc) { 
        
        String query = 'SELECT id,VendorCallKey, RelatedRecordId, Customer_Sentiment_Score__c, Batch_Processed__c, Conversation_Transcript_Body__c, Customer_Sentiments__c, CallDisposition from VoiceCall where RelatedRecordId != null and CallEndDateTime!= null AND CallDisposition=\'completed\' AND Customer_Sentiment_Score__c =null AND Batch_Processed__c = false and CreatedDate >= YESTERDAY' ;
        // retruning all VoiceCall data where CallEndDateTime!= null and sentiment score is not calculated
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<VoiceCall> scope) {
        
    try{
      List<VoiceCall> vcList = new List<VoiceCall>(); 
      RS_Einstein_Sentiment_Settings__mdt Sentisettings = RS_Einstein_Sentiment_Settings__mdt.getInstance('X1');
      List<Vision.Prediction> predictInstance;
      //Access token
      RS_PredictionController PredCont = new RS_PredictionController();
      String access_token = PredCont.getAccessToken();
      
          
        for(VoiceCall vc :scope){
            
            if(vc.VendorCallKey!=null){
               
                String conv = getData(vc.VendorCallKey);
                if(conv!=''){
                    vc.Batch_Processed__c = true;
                    vc.Conversation_Transcript_Body__c = conv;
                    //Sentiment section
                    predictInstance = new List<Vision.Prediction>();
                    predictInstance = Vision.predictSentiment(conv,access_token,Sentisettings.Model__c);
                    if((!predictInstance.isempty()) && predictInstance[0].probability != null){
                        vc.Customer_Sentiment_Score__c = predictInstance[0].probability;
                        vc.Customer_Sentiments__c = predictInstance[0].Label;
                    }
                    vcList.add(vc);
                }
            }
            
        }
        if(!vcList.isempty()){
            Database.update(vcList, false);
            list<Sentiment_Score__c> listSenticoreVC = new list<Sentiment_Score__c>();
            for(VoiceCall vc: vcList){
                Sentiment_Score__c sentiObj = new Sentiment_Score__c();
                sentiObj.Case__c = vc.RelatedRecordId;
                sentiObj.Customer_Sentiment_Score__c = vc.Customer_Sentiment_Score__c;
                sentiObj.Customer_Sentiments__c = vc.Customer_Sentiments__c;
                sentiObj.Conversation_Channel__c ='Voice Call';
                sentiObj.Voice_Call__c = vc.id;
                listSenticoreVC.add(sentiObj);  
            }
            if(!listSenticoreVC.isempty()){
                database.insert(listSenticoreVC,false);
            }
       }
  
    }catch(Exception e){
            system.debug('Exception Message>>>>>' + e.getMessage());
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        AsyncApexJob job = [SELECT Id, Status FROM AsyncApexJob WHERE Id = :bc.getJobId()]; 
    }
    //Method to get data for voice call/de726b34-4f1f-45e3-848a-23ba351c32f7
    public static String getData(String vendorCallKey){
        String conv='';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:SalesforceOrg/services/data/v53.0/connect/Conversation/'+vendorCallKey+'/entries');
        request.setMethod('GET');
        try{
            //request.setHeader('Authorization', 'Bearer '+UserInfo.getSessionId());
            HttpResponse response = http.send(request);
            if(response.getStatus()=='OK' && response.getBody()!=null){
                Rs_voiceCallParser vc = Rs_voiceCallParser.parse(response.getBody());
                for(Rs_voiceCallParser.cls_conversationEntries ce: vc.conversationEntries){
                    if(ce.messageText!=null){
                        conv = conv+ ce.messageText + '  ';
                    }
                }
            }
            return conv;
        }catch(exception a){
            return null;
        }
    }
}