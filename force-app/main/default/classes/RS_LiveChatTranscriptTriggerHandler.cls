/**
* @description :This is RS_LiveChatTranscriptTriggerHandler class
* @author : Accenture
* @group :
* @last modified on : 03-24-2023
* @last modified by : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public  with sharing class RS_LiveChatTranscriptTriggerHandler {
/**
* @description : This is afterUpdate method.
* @Return : void
* @Method Name : afterUpdate
* @param trgrNew 
* @param trgrNewMap 
* @param trgrOldMap 
**/
    public static void afterUpdate(List<LiveChatTranscript> trgrNew, Map<id, LiveChatTranscript> trgrNewMap, Map<id, LiveChatTranscript> trgrOldMap){
        List<LiveChatTranscript> lstMess=new list<LiveChatTranscript>();
		String channelname =[Select DeveloperName from RS_Einstein_Sentiment_Configuration__mdt where label='Live Chat' WITH SECURITY_ENFORCED]?.DeveloperName;
    	for(LiveChatTranscript livechat:trgrNew){
           	if((trgrOldMap.get(livechat.id).Status!=trgrNewMap.get(livechat.id).Status && trgrNewMap.get(livechat.id).Status=='Completed')||(trgrOldMap.get(livechat.id).endtime!=trgrNewMap.get(livechat.id).endtime)){
               	RS_SentimentCalculator.getSentiment(channelname,livechat.Id);
           	}
        }
    }
}