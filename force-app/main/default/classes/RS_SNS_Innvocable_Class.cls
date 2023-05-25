/**
 * @description       : Invocable Class to send sms notification to customer on case creation  
 * @author            : Accenture
 * @group             : 
 * @last modified on  : 03-24-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class RS_SNS_Innvocable_Class {
    
    /**
    * @description : InvocableMethod to send sms notification to customer on case creation 
    * @author Accenture | 03-24-2023 
    * @param CaseId 
    **/
    @InvocableMethod(label='Send SMS Confirmation')
    public static void sendSMS(List<String> caseId) {
        RS_Send_Message_On_Case_Creation.sendSNSMessage(caseId);
    }
}