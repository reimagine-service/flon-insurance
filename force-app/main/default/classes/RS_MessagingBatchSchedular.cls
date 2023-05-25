/**
* @description :This class is for scheduling the batch jobs
* @author : Accenture
* @group :
* @last modified on : 04-12-2022
* @last modified by : Accenture
**/
global class RS_MessagingBatchSchedular implements Schedulable {
    
  /**
   * @MethodName : Execute
   * @Description: This method is used to schedule Messaging session batch class
   */
    global void execute(SchedulableContext ctx){
   	  RS_MessagingSessionBatch batchobj = new RS_MessagingSessionBatch();
      database.executebatch(batchobj,10);
    }

}