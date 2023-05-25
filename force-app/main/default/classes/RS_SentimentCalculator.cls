/**
* @description       : This class is used to calculate sentiments on all the interactions with the customer from all the channels 
* @author            : Accenture
* @last modified on  : 04-04-2022
* @last modified by  : Accenture
**/
public class RS_SentimentCalculator {
    
    @future(callout=true)
    public static void getSentiment(String ChannelName, String InteractionId){
        Sobject sobj;
        String interactionSql;
        Vision.Prediction retSentiment = new Vision.Prediction();
        RS_PredictionController PredCont = new RS_PredictionController();
        try{
            if(ChannelName!=null && InteractionId!=null){
                RS_Einstein_Sentiment_Configuration__mdt mcs = RS_Einstein_Sentiment_Configuration__mdt.getInstance(ChannelName);
                RS_Einstein_Sentiment_Settings__mdt Sentisettings = RS_Einstein_Sentiment_Settings__mdt.getInstance('X1');
                
                if(mcs.Sentiment_Field_to_analyse__c!=null && mcs.Sentiment_score_field_to_Update__c!=null){
                    interactionSql  = 'Select id, '+ String.escapeSingleQuotes(mcs.Case_Field_Name__c)  + ',' + String.escapeSingleQuotes(mcs.Sentiment_Field_to_analyse__c) + ','+ String.escapeSingleQuotes(mcs.Sentiment_score_field_to_Update__c) + ','+ String.escapeSingleQuotes(mcs.Customer_sentiments__c);
                    interactionSql+= ' from '+ String.escapeSingleQuotes(mcs.Interaction_Object_API__c) + ' where id =:InteractionId';
                    sobj = Database.query(interactionSql); 
                }
                if(sobj!=null){
					String access_token = PredCont.getAccessToken();
					
					if((String)sobj.get(mcs.Sentiment_Field_to_analyse__c)!=null && access_token!=null){
						List<Vision.Prediction> predictInstance = new List<Vision.Prediction>();
						predictInstance = Vision.predictSentiment((String)sobj.get(mcs.Sentiment_Field_to_analyse__c) ,access_token,Sentisettings.Model__c);
						if(predictInstance !=null && predictInstance.size()>0){
							retSentiment= predictInstance[0];
						}
					}
					
					IF(retSentiment!=null){
						sobj.put(mcs.Sentiment_score_field_to_Update__c, retSentiment.probability);
						sobj.put(mcs.Customer_sentiments__c, retSentiment.label);
					}
					if(Schema.getGlobalDescribe().get(mcs.Interaction_Object_API__c).getDescribe().isUpdateable()) {
						update sobj; 
					}
					Sentiment_Score__c sentiObj = new Sentiment_Score__c();
						sentiObj.Case__c = (String)sobj.get(mcs.Case_Field_Name__c);
						sentiObj.Customer_Sentiment_Score__c = (Decimal)sobj.get(mcs.Sentiment_score_field_to_Update__c);
						sentiObj.Customer_Sentiments__c = (String)sobj.get(mcs.Customer_sentiments__c);
						sentiObj.Conversation_Channel__c = mcs.Label;
						if(mcs.Interaction_Lookup_Field__c!=null){
							sentiObj.put(mcs.Interaction_Lookup_Field__c,InteractionId);
						}
						if(Schema.getGlobalDescribe().get('Sentiment_Score__c').getDescribe().isCreateable()) {
							insert sentiObj;
						}
				}
            }
        }
        catch(Exception e){
            system.debug('ERROR >>>>>' + e.getMessage());
        } 
        
        
    }
}