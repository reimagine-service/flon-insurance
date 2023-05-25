global  with Sharing   class RS_getAvailableTimeSlots {
    @InvocableMethod(label='Get Time Slot')
    global static List<List<String>> getTimeSlots(List<InputForm> inputFormWrappers){
        
        String parsestring=inputFormWrappers[0].resourceIdList;
        RS_SchedulerJsonParser schedulerCandidates = RS_SchedulerJsonParser.parse(parsestring);
        Set<String> timeSlotSet=new Set<String>();
        String startTimeAMPM=inputFormWrappers[0].bucketSlotSelected.substring(0,8);
        String endtimeAMPM=inputFormWrappers[0].bucketSlotSelected.substring(9,15);
        
        String[] startTimeSplit = startTimeAMPM.split(':');
        String[] ampmStartSplit = startTimeSplit[1].split(' ');
        
        Integer hours = Integer.valueOf(startTimeSplit[0]);
        Integer minutes = Integer.valueOf(ampmStartSplit[0]);
        String[] endTimeSplit = endtimeAMPM.split(':');
        if (ampmStartSplit[1] == 'PM') {
            hours += 12;
        }
        String startTime = String.ValueOf(Time.newInstance(hours, minutes, 0, 0)).replace('.000Z','');
        //Removed reference of External Object
        List<Scheduler_Bucket_Slots__mdt> getbucketData=[Select StartTime__c, EndTime__c,Slot_Time__c from Scheduler_Bucket_Slots__mdt where StartTime__c=:startTime];
        //List<Salesforce_Scheduler_Bucket_Slots__x> bucketData=ObjectManager.records([SELECT BucketName__c,StartTime__c,EndTime__c, SlotTime__c,StartTime_SF__c,EndTime_SF__c from Salesforce_Scheduler_Bucket_Slots__x  where StartTime__c=:startTime ]);
        
        for(RS_SchedulerJsonParser.Candidates ce: schedulerCandidates.candidates){
            list<String> startTimeSF=(getbucketData[0].StartTime__c).split(':');
            Time StartSFTime=Time.newInstance(Integer.valueof(startTimeSF[0]),Integer.valueof(startTimeSF[1]),Integer.valueof(startTimeSF[2]),Integer.valueof(startTimeSF[2]));
            System.debug('StartSFTime'+StartSFTime);
            list<String> endStringTime=(getbucketData[0].EndTime__c).split(':');
            Time EndSFTime=Time.newInstance(Integer.valueof(startTimeSF[0]),Integer.valueof(startTimeSF[1]),Integer.valueof(startTimeSF[2]),Integer.valueof(startTimeSF[2]));
            
            Time slotIncrementString=StartSFTime;
            Datetime validDatetime=DateTime.Valueof(ce.starttime.replace('T',' '));
            Time gettimevalue=validDatetime.time();
            
            while (EndSFTime!=slotIncrementString){
                
                if(gettimevalue==slotIncrementString){
                    
                    DateTime myDateTime = DateTime.newInstance(Date.today(), slotIncrementString);
                    String myStartTimeString = myDateTime.format('hh:mm a');
                    Datetime myEndDateTime=DateTime.newInstance(Date.today(), (slotIncrementString).addMinutes(Integer.ValueOf(getbucketData[0].Slot_Time__c)));
                    String myEndTimeString=myEndDateTime.format('hh:mm a');
                    timeSlotSet.add(myStartTimeString+'-'+myEndTimeString);
                }
                slotIncrementString=slotIncrementString.addMinutes(Integer.ValueOf(getbucketData[0].Slot_Time__c));
            }
        }
        if(timeSlotSet!=null){
            timeSlotSet.add('go back to select another date');
        }
        else{
            timeSlotSet.add('No Agents are available on the selected date. Please select another date');
        }
        List<String> timeSlotList = new List<String>(timeSlotSet);
        List<List<String>> timeSlotOutputList=new  List<List<String>>();
        timeSlotOutputList.add(timeSlotList);
        System.debug('timeSlotOutputList'+timeSlotOutputList);
        return timeSlotOutputList;
    }
    global class InputForm {
        @InvocableVariable
        global String resourceIdList;
        @InvocableVariable
        global String bucketSlotSelected;
    }
    
}