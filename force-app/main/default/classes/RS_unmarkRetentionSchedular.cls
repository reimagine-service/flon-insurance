/**
* @description       : 
* @author            : Accenture
* @group             : 
* @last modified on  : 02-25-2022
* @last modified by  : Accenture
**/
global class RS_unmarkRetentionSchedular implements Schedulable {
    
    global void execute(SchedulableContext ctx){
   	  RS_unmarkRetentionCustomerBatch batchobj = new RS_unmarkRetentionCustomerBatch();
      database.executebatch(batchobj,10);
    }

}