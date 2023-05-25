/**
 * @description       : Parser Class for getting Conversation over voice channel.
 * @author            : Accenture
 * @group             : 
 * @last modified on  : 04-12-2022
 * @last modified by  : Accenture
**/
public class Rs_voiceCallParser{
    public cls_conversationEntries[] conversationEntries;
    public class cls_conversationEntries {
        public Integer clientDuration;  //585
        public String clientTimestamp; //1649310964000
        public String identifier;   //16b3011b-635f-4b42-a7a4-16d568038b00 
        public String messageText;  //Yeah, you can.
        public List<String> relatedRecords;
        public cls_sender sender;
        public String serverReceivedTimestamp; //1649310968301
    }
    /*class cls_relatedRecords {
        public String recordIds;    //0
    }*/
    public class cls_sender {
        public String appType;  //telephony_integration
        public String role; //Agent
        public String subject;  //VIRTUAL_AGENT
    }
    public static Rs_voiceCallParser parse(String json){
        return (Rs_voiceCallParser) System.JSON.deserialize(json, Rs_voiceCallParser.class);
    }
}