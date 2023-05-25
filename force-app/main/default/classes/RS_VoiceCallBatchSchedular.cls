/**
* @description       : 
* @author            : Accenture
* @group             : 
* @last modified on  : 02-25-2022
* @last modified by  : Accenture
**/
global class RS_VoiceCallBatchSchedular implements Schedulable {
    
    global void execute(SchedulableContext ctx){
   	  RS_VoiceCallBatch batchobj = new RS_VoiceCallBatch();
      database.executebatch(batchobj,10);
    }

}