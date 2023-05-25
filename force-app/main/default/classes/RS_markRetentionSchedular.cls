/**
* @description       : 
* @author            : Accenture
* @group             : 
* @last modified on  : 02-25-2022
* @last modified by  : Accenture
**/
global class RS_markRetentionSchedular implements Schedulable {
    
    global void execute(SchedulableContext ctx){
   	  RS_markRetentionCustomerBatch batchobj = new RS_markRetentionCustomerBatch();
      database.executebatch(batchobj,10);
    }

}