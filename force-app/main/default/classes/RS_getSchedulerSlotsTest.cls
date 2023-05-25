/**
* @description       : Test Class for RS_getSchedulerSlots
* @author            : Accenture
* @group             : 
* @last modified on  : 03-23-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@IsTest
public class RS_getSchedulerSlotsTest {
    @TestSetup
    public static void createTestData(){
        User getuser=TestDataFactory.createUser();
    }
    
    @IsTest
    Public Static void testSchedulerSlots(){
        User u=[Select id from user limit 1];
        List<Scheduler_Bucket_Slots__mdt> getbucketData=[Select StartTime__c, EndTime__c,Slot_Time__c,Label,DeveloperName from Scheduler_Bucket_Slots__mdt  Limit 1];
        RS_getSchedulerSlots.getSchedulerSlotsResult getTestParam= new RS_getSchedulerSlots.getSchedulerSlotsResult();
        String slotBucket='{"candidates": [{"endTime": "2023-02-20T10:00:00.000+0000","resources": ["0Hn3C00000029MJSAY"],"startTime": "2023-02-20T09:00:00.000+0000","territoryId": "0Hh3C0000002EGjSAM"}]}';
        List<String> testparamStringList=new  List<String>();
        testparamStringList.add(slotBucket);
        getTestParam.slotBucket=testparamStringList;
        System.runAs(u){
            RS_getSchedulerSlots.parseCandidatesJson(testparamStringList);
        }
        System.assertEquals('Evening_Bucket',getbucketData[0].DeveloperName);
    }
}