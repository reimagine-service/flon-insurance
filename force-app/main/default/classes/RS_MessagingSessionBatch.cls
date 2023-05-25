/**
* @description :This batch class is used for updating Chat transcript on Messaging Records
* @author : Accenture
* @group :
* @last modified on : 04-12-2022
* @last modified by : Accenture
**/
global class RS_MessagingSessionBatch implements Database.Batchable<sObject>,Database.AllowsCallouts {
	
	global Database.QueryLocator start(Database.BatchableContext bc) { 
        
        String query = 'SELECT id, Status,CaseId, Customer_Sentiment_Score__c, Batch_Processed__c, Conversation_Transcript_Body__c, Customer_Sentiments__c from MessagingSession where CaseId!=null AND Status = \'Ended\' AND Customer_Sentiment_Score__c =null AND Batch_Processed__c = false' ;
        // retruning all MessagingSession data where Status = 'Ended' and sentiment score is not calculated
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<MessagingSession> scope) {
        
		try{
		    List<ConversationEntry> conEntry = new List<ConversationEntry>();
            Map<id,List<ConversationEntry>> mapConIdListConEntry = new Map<id,List<ConversationEntry>>();
            List<MessagingSession> msgList = new List<MessagingSession>();
            String ChannelName=[Select DeveloperName from RS_Einstein_Sentiment_Configuration__mdt where label='SMS' WITH SECURITY_ENFORCED].DeveloperName;
			RS_Einstein_Sentiment_Settings__mdt Sentisettings = RS_Einstein_Sentiment_Settings__mdt.getInstance('X1');
            List<Vision.Prediction> predictInstance;
			RS_PredictionController PredCont = new RS_PredictionController();
			String access_token = PredCont.getAccessToken();
            conEntry = [Select id, conversationId, ActorType, Message from ConversationEntry where ActorType='EndUser' and ConversationId IN:scope];
            if(conEntry.size()>0 && conEntry!=null){
            for(ConversationEntry ce: conEntry){
				if(mapConIdListConEntry.containskey(ce.conversationId)){
                	List<ConversationEntry> listConEntry = mapConIdListConEntry.get(ce.conversationId);
                    listConEntry.add(ce);
                    mapConIdListConEntry.put(ce.conversationId,listConEntry);
                }
                else{
                    mapConIdListConEntry.put(ce.conversationId,new list<ConversationEntry>{ce});
                }
			}
            for(MessagingSession msg :scope){
                if(mapConIdListConEntry.containskey(msg.id)){
                    conEntry = mapConIdListConEntry.get(msg.id);
                    msg.Conversation_Transcript_Body__c=' ';
                    if(conEntry.size()>0 && conEntry!=null){
                        for(integer i=0; i<conEntry.size(); i++){
                            msg.Conversation_Transcript_Body__c += conEntry[i].Message +' ';
                        }
                    }
                    msg.Batch_Processed__c = true;
                    //Sentiment section
                    predictInstance = new List<Vision.Prediction>();
                    predictInstance = Vision.predictSentiment(msg.Conversation_Transcript_Body__c,access_token,Sentisettings.Model__c);
                    if((!predictInstance.isempty()) && predictInstance[0].probability != null){
                            msg.Customer_Sentiment_Score__c = predictInstance[0].probability;
                        	msg.Customer_Sentiments__c = predictInstance[0].Label;
                    }
                }else{
					msg.Customer_Sentiment_Score__c =0.5;
				}
				msgList.add(msg);
       		}
            Database.update(msgList, false);
                list<Sentiment_Score__c> listSenticoreSMS = new list<Sentiment_Score__c>();
                for(messagingsession ms: msgList){
                    Sentiment_Score__c sentiObj = new Sentiment_Score__c();
                    sentiObj.Case__c = ms.CaseId;
                    sentiObj.Customer_Sentiment_Score__c = ms.Customer_Sentiment_Score__c;
                    sentiObj.Customer_Sentiments__c = ms.Customer_Sentiments__c;
                    sentiObj.Conversation_Channel__c ='SMS';
                    sentiObj.Messaging_Session__c = ms.id;
                    listSenticoreSMS.add(sentiObj);  
                }
                if(!listSenticoreSMS.isempty()){
                    database.insert(listSenticoreSMS,false);
                }
            }
		}catch(Exception e){
            system.debug('Exception Message>>>>>' + e.getMessage());
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        AsyncApexJob job = [SELECT Id, Status FROM AsyncApexJob WHERE Id = :bc.getJobId()]; 
    	System.debug('>>>> finish ' + job.Status);
    }
    
}