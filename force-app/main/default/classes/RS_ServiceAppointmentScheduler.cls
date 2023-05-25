global class RS_ServiceAppointmentScheduler implements Schedulable {
   global void execute(SchedulableContext sc) {
      // Find all service appointments with a scheduled end time that has passed
      List<ServiceAppointment> appointmentsToUpdate = [SELECT Id, Status, SchedEndTime FROM ServiceAppointment WHERE SchedEndTime <= :DateTime.now() AND Status != 'Closed'];
      
      // Update the status of the service appointments to "Closed"
      for(ServiceAppointment appointment : appointmentsToUpdate) {
         appointment.Status = 'Closed';
      }
      update appointmentsToUpdate;
   }
}