/**
* @description       : Class to schedule or rechedule appointment from bot
* @author            : Accenture
* @group             : 
* @last modified on  : 03-24-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global with Sharing class RS_createNewAppointmentFromBot {
    
    /**
* @description :method to schedule or rechedule appointment from bot
* @author Accenture | 03-13-2023 
* @param inputFormWrappers 
**/
    @InvocableMethod(label='Create New Appointment')
    global static void createNewAppointment(List<InputParam> inputFormWrappers){
        RS_SchedulerJsonParser schedulerCandidates = RS_SchedulerJsonParser.parse(inputFormWrappers[0].candidateJSON);
        Date dateValue = Date.valueOf(inputFormWrappers[0].selectedDate);
        String startTimeAMPM=inputFormWrappers[0].timeSlotSelected.substring(0,8);
        String endtimeAMPM=inputFormWrappers[0].timeSlotSelected.substring(9,17);
        String[] startTimeSplit = startTimeAMPM.split(':');
        String[] ampmStartSplit = startTimeSplit[1].split(' ');
        Integer hours = Integer.valueOf(startTimeSplit[0]);
        Integer minutes = Integer.valueOf(ampmStartSplit[0]);
        if (ampmStartSplit[1] == 'PM') {
            
            hours += 12;
        }
        String[] endTimeSplit = endtimeAMPM.split(':');
        String[] ampmendSplit = endTimeSplit[1].split(' ');
        Integer endtimehours = Integer.valueOf(endTimeSplit[0]);
        Integer endtimeminutes = Integer.valueOf(ampmendSplit[0]);
        if (ampmendSplit[1] == 'PM') {
            endtimehours += 12;
        }
        Case getCaseDetails=[SELECT AccountId,ContactId,Account.BillingAddress,Subject,Description from Case Where Id=:inputFormWrappers[0].caseId WITH SECURITY_ENFORCED];
        WorkType getworktypeDetails=[SELECT id from WorkType where Name =:inputFormWrappers[0].workflowName WITH SECURITY_ENFORCED];
        Account getAddressDetails=[SELECT BillingCity,BillingStreet, BillingState, BillingCountry, BillingPostalCode,Phone  from Account where Id=:getCaseDetails.AccountId WITH SECURITY_ENFORCED];
        Time startTime = (Time.newInstance(hours, minutes, 0, 0));
        Time endTime = (Time.newInstance(endtimehours, endtimeminutes, 0, 0));
        RS_SchedulerJsonParser.Candidates selectedSlot=new  RS_SchedulerJsonParser.Candidates();
        for(RS_SchedulerJsonParser.Candidates ce: schedulerCandidates.candidates){
            Datetime validStartDatetime=DateTime.Valueof(ce.starttime.replace('T',' '));
            Time getStarttimevalue=validStartDatetime.time();  
            Datetime validEndDatetime=DateTime.Valueof(ce.starttime.replace('T',' '));
            Time getEndtimevalue=validEndDatetime.time();
            if(getStarttimevalue==startTime&&getEndtimevalue==getEndtimevalue){
                selectedSlot=ce;
            }
        }
        ServiceResource getServiceResourceDetails;
        if(selectedSlot.resources!=null){
            getServiceResourceDetails=[SELECT RelatedRecord.Id from ServiceResource where Id=:selectedSlot.resources[0] WITH SECURITY_ENFORCED];
        }
        List<ServiceAppointment>  scList=new List<ServiceAppointment>();
        scList = [Select id, status, ParentRecordId from ServiceAppointment where ParentRecordId=:inputFormWrappers[0].caseId WITH SECURITY_ENFORCED limit 1];
        
        if(scList.size()>0 && scList[0].Status != 'Closed' && selectedSlot.resources!=null){
            
            RS_createNewAppointmentFromBot.updateAppointment(scList[0].Id, dateValue, startTime, endTime, selectedSlot.resources[0]);
            
        }else {
            ServiceAppointment createAppointment = new ServiceAppointment();
            scList.clear();
            createAppointment.SchedStartTime= DateTime.newInstance(dateValue,startTime);
            createAppointment.SchedEndTime= DateTime.newInstance(dateValue,endTime);
            createAppointment.ParentRecordId=inputFormWrappers[0].caseId;
            createAppointment.RS_Case__c=inputFormWrappers[0].caseId;
            createAppointment.RS_Account__c=getCaseDetails.AccountId;
            createAppointment.ContactId=getCaseDetails.ContactId;
            createAppointment.City=getAddressDetails.BillingCity;
            createAppointment.Street=getAddressDetails.BillingStreet;
            createAppointment.State=getAddressDetails.BillingState;
            createAppointment.Country=getAddressDetails.BillingCountry;
            createAppointment.PostalCode=getAddressDetails.BillingPostalCode;
            createAppointment.ServiceTerritoryId=selectedSlot.territoryId;
            createAppointment.Subject=getCaseDetails.Subject;
            createAppointment.Description=getCaseDetails.Description;
            createAppointment.Phone=getAddressDetails.Phone;
            createAppointment.WorkTypeId=getworktypeDetails.Id;
            if(getServiceResourceDetails!=null){
                createAppointment.OwnerId=getServiceResourceDetails.RelatedRecord.Id;
            }
            createAppointment.DurationType='Minutes';
            scList.add(createAppointment);
            
            if(Schema.getGlobalDescribe().get('ServiceAppointment').getDescribe().isCreateable()){
                insert scList;
            }
            if (!Test.isRunningTest()) {   
                AssignedResource assignedResourceToAppointment=new AssignedResource();
                assignedResourceToAppointment.ServiceResourceId=selectedSlot.resources[0];
                assignedResourceToAppointment.ServiceAppointmentId=scList[0].Id;
                if(Schema.SObjectType.AssignedResource.isCreateable() &&
                AssignedResource.SObjectType.getDescribe().isAccessible() && 
                Schema.SObjectType.AssignedResource.fields.ServiceResourceId.isAccessible() &&
                Schema.SObjectType.AssignedResource.fields.ServiceAppointmentId.isAccessible()
                ){
                    insert assignedResourceToAppointment;
                }
            }
        }
    }
    
    /**
* @description 
* @author Accenture | 03-13-2023 
* @param AppointmentId 
* @param dateValue 
* @param startTime 
* @param endTime 
* @param RecourceId 
**/
    public static void updateAppointment(Id AppointmentId, Date dateValue, Time startTime, Time endTime, String RecourceId){
        
        
        ServiceAppointment sr = new ServiceAppointment();
        sr = [Select id,SchedEndTime,SchedStartTime from ServiceAppointment where id=:AppointmentId WITH SECURITY_ENFORCED];
        ServiceAppointment updatesc = new ServiceAppointment(Id=sr.Id);
        sr.SchedStartTime= DateTime.newInstance(dateValue,startTime);
        sr.SchedEndTime= DateTime.newInstance(dateValue,endTime);
        if(Schema.getGlobalDescribe().get('ServiceAppointment').getDescribe().isUpdateable()){
            update sr;
        }
        if (!Test.isRunningTest()) {   
            AssignedResource getassignedResourceDetails=[SELECT ID,ServiceResourceId,ServiceAppointmentId from AssignedResource where ServiceAppointmentId=:sr.Id WITH SECURITY_ENFORCED];
            AssignedResource updateassignedResourceToAppointment=new AssignedResource(Id=getassignedResourceDetails.Id);
            updateassignedResourceToAppointment.ServiceResourceId=RecourceId;
            //updateassignedResourceToAppointment.ServiceAppointmentId=sr.Id;
            if(Schema.getGlobalDescribe().get('AssignedResource').getDescribe().isUpdateable()){
                update updateassignedResourceToAppointment;
            }
        }
    }
    
    global class InputParam{
        @InvocableVariable
        global String candidateJSON;
        @InvocableVariable
        global String timeSlotSelected;
        @InvocableVariable
        global String caseId;
        @InvocableVariable
        global String selectedDate;
        @InvocableVariable
        global String workflowName;
    }
}