/**
* @description       :  Used to fetch the time buckets customer can schedule appointment in based on response from getappointmentcandidates api response
* @author            : Accenture
* @group             : 
* @last modified on  : 03-24-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global  with Sharing  class RS_getSchedulerSlots {
    
    /**
* @description : Used to fetch the time buckets customer can schedule appointment in.
* @author Accenture | 03-24-2023 
* @param candidates 
* @return List<GetSchedulerSlotsResult> 
**/
    @InvocableMethod(label='Get Bucket Slots')
    global static List<GetSchedulerSlotsResult> parseCandidatesJson(List<String> candidates){
        List<OutputForm> outputCandidateList = new List<OutputForm>();
        Set<String> mySet = new Set<String>();
        //Removed reference of External Object
        List<Scheduler_Bucket_Slots__mdt> getbucketData=[Select Label ,StartTime__c, EndTime__c,Slot_Time__c from Scheduler_Bucket_Slots__mdt];
        // List<Salesforce_Scheduler_Bucket_Slots__x> bucketData=ObjectManager.records([SELECT BucketName__c,StartTime__c,EndTime__c, SlotTime__c,StartTime_SF__c,EndTime_SF__c from Salesforce_Scheduler_Bucket_Slots__x  WITH SECURITY_ENFORCED]);
        List<GetSchedulerSlotsResult> outputList=new List<GetSchedulerSlotsResult>();
        RS_SchedulerJsonParser vc = RS_SchedulerJsonParser.parse(candidates[0]);
        for(RS_SchedulerJsonParser.Candidates ce: vc.candidates){
            for(Scheduler_Bucket_Slots__mdt bucketlist:getbucketData){
                list<String> startTimeSF=(bucketlist.StartTime__c).split(':');
                Time StartSFTime=Time.newInstance(Integer.valueof(startTimeSF[0]),Integer.valueof(startTimeSF[1]),Integer.valueof(startTimeSF[2]),Integer.valueof(startTimeSF[2]));
                System.debug('StartSFTime'+StartSFTime);
                list<String> endStringTime=(bucketlist.EndTime__c).split(':');
                Time EndSFTime=Time.newInstance(Integer.valueof(startTimeSF[0]),Integer.valueof(startTimeSF[1]),Integer.valueof(startTimeSF[2]),Integer.valueof(startTimeSF[2]));
                OutputForm outputCandidate = new OutputForm();
                outputCandidate.bucketName=bucketlist.Label ;
                outputCandidate.startTime=ce.startTime;
                outputCandidate.endTime=ce.endTime;
                outputCandidate.resourceId=ce.resources[0];
                outputCandidateList.add(outputCandidate);
                Datetime validDatetime=DateTime.Valueof(ce.starttime.replace('T', ' '));
                Time gettimevalue=validDatetime.time();
                //Boolean resBool= RS_getSchedulerSlots.checkBucketSlotsAvailability(gettimevalue,bucketlist);
                Boolean resBool= RS_getSchedulerSlots.checkBucketSlotsAvailability(gettimevalue,bucketlist,StartSFTime,EndSFTime);
                if(resBool==true){
                    DateTime myDateTime = DateTime.newInstance(Date.today(),StartSFTime);
                    String myTimeString = myDateTime.format('hh:mm a');
                    Datetime myEndDateTime=DateTime.newInstance(Date.today(), EndSFTime);
                    String myEndTimeString=myEndDateTime.format('hh:mm a');
                    mySet.add(myTimeString+'-'+myEndTimeString);
                }
            }
            
        }
        List<String> result = new List<String>(mySet);
        if(result!=null){
            result.add('to go back to select another date');
        }
        else{
            result.add('No Agents are available on the selected date. Please select another date');
        }
        GetSchedulerSlotsResult output = new GetSchedulerSlotsResult();
        output.slotBucket=result;
        outputList.add(output);   
        system.debug('outputList'+outputList);
        return outputList;
    }
    
    /**
* @description 
* @author Accenture | 03-24-2023 
* @param candidateAvailabileTime 
* @param bucketData 
* @return boolean 
**/
    public static boolean checkBucketSlotsAvailability(Time candidateAvailabileTime,Scheduler_Bucket_Slots__mdt bucketData,Time StartSFTime,Time EndSFTime){
        Time slotIncrementString=StartSFTime;
        Boolean resBool=false;
        while (EndSFTime!=slotIncrementString){
            if(candidateAvailabileTime==slotIncrementString){
                return true;
            }
            slotIncrementString=slotIncrementString.addMinutes(Integer.ValueOf(bucketData.Slot_Time__c ));
        }
        return false;
    }
    /**
* @description : Wrapper Response of list of string of time buckets to be displayed in bot
* @author Accenture | 03-24-2023 
**/
    global class GetSchedulerSlotsResult {
        @InvocableVariable
        global List<String> slotBucket;
        
    }
    /**
* @description : Wrapper Response of required param on bot 
* @author Accenture | 03-24-2023 
**/
    global class OutputForm{
        @InvocableVariable
        global String resourceId;
        @InvocableVariable
        global String startTime;
        @InvocableVariable
        global String endTime;
        @InvocableVariable
        global String bucketName;
    }
    
}