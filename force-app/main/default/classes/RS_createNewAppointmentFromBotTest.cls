/**
 * @description       : Test Class for RS_createNewAppointmentFromBot
 * @author            : Accenture
 * @group             : 
 * @last modified on  : 03-24-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class RS_createNewAppointmentFromBotTest {
    /**
    * @description : Test data Setup
    * @author Accenture | 03-24-2023 
    **/
    @TestSetup
    public static void createData(){
        User userTest=TestDataFactory.createUser();
        
    }
    
    @isTest
    static void testCreateNewAppointment() {
        Account createTestAccount=TestDataFactory.accList();
        // Create a test Case record
        User u=[Select id from user limit 1];
        System.runAs(u) {
            Case c = new Case(
                Subject = 'Test Subject',
                Description = 'Test Description',
                Status = 'New',
                Origin = 'Web',
                RS_Case_Resolution__c='Resolved By Bot',
                AccountId=createTestAccount.Id
            );
            insert c;
            System.assertEquals('Test Subject',c.Subject);
            User userid=[Select id from user limit 1];
            // Create a test Service Resource record
            ServiceResource sr = new ServiceResource();
            sr.Name = 'Test Service Resource';
            sr.ResourceType = 'T';
            sr.RelatedRecordId=userid.Id;
            sr.IsActive=true;
            insert sr;
            
            // Create a test WorkType record
            WorkType wt = new WorkType(
                Name = 'Test WorkType',
                EstimatedDuration=60,
                DurationType='Minutes'
            );
            insert wt;
            
            // Create a test InputParam record
            RS_createNewAppointmentFromBot.InputParam ip = new RS_createNewAppointmentFromBot.InputParam();
            List<String> serviceresourcelist=new List<String>();
            ip.candidateJSON = '{"candidates":[]}';
            ip.selectedDate = '2023-03-03';
            ip.timeSlotSelected = '09:00 PM-10:00 PM';
            ip.CaseId = c.Id;
            ip.workflowName = wt.Name;
            List<RS_createNewAppointmentFromBot.InputParam> inputList = new List<RS_createNewAppointmentFromBot.InputParam>();
            inputList.add(ip);
            ServiceAppointment testAppointment = new ServiceAppointment(
                Subject = 'Test Appointment',
                Status = 'Closed',
                SchedStartTime = DateTime.newInstance(Date.today(), Time.newInstance(10, 0, 0,0)),
                SchedEndTime = DateTime.newInstance(Date.today(), Time.newInstance(11, 0, 0,0)),
                ParentRecordId=c.id
                
            );
            insert testAppointment;
            Date newDate = Date.today().addDays(1);
            Time newStartTime = Time.newInstance(12, 0, 0,0);
            Time newEndTime = Time.newInstance(13, 0, 0,0);
            String newResourceId = sr.Id;
            Test.startTest();
            RS_createNewAppointmentFromBot.createNewAppointment(inputList);
            RS_createNewAppointmentFromBot.updateAppointment(testAppointment.Id, newDate, newStartTime, newEndTime, newResourceId);
            // Call the createNewAppointment method
            Test.stopTest();
           
            
        }      
    }
}