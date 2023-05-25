/**
 * @description       : Test Class for RS_getAvailableTimeSlots
 * @author            : Accenture
 * @group             : 
 * @last modified on  : 03-24-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@IsTest
public class RS_getAvailableTimeSlotsTest {
@isTest
    Public static void testGetTimeSlots(){
        List<Scheduler_Bucket_Slots__mdt> getbucketData=[Select StartTime__c, EndTime__c,Slot_Time__c from Scheduler_Bucket_Slots__mdt Limit 1];
        RS_getAvailableTimeSlots.InputForm inputparam=new RS_getAvailableTimeSlots.InputForm();
        List< RS_getAvailableTimeSlots.InputForm > newListInputParam= new  List<RS_getAvailableTimeSlots.InputForm>();
        inputparam.bucketSlotSelected='09:00 AM-10:00 AM';
        inputparam.resourceIdList='{"candidates": [{"endTime": "2023-02-20T10:00:00.000+0000","resources": ["0Hn3C00000029MJSAY"],"startTime": "2023-02-20T09:00:00.000+0000","territoryId": "0Hh3C0000002EGjSAM"}]}';
        newListInputParam.add(inputparam);
        RS_getAvailableTimeSlots.getTimeSlots(newListInputParam);
        System.assertEquals('09:00 AM-10:00 AM',inputparam.bucketSlotSelected);
        }
}