/**
 * @description       : Parser method to parse the response from getAppointmentCandidates
 * @author            : Accenture
 * @group             : 
 * @last modified on  : 03-24-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class RS_SchedulerJsonParser {
    public class Candidates{
        public string endTime;
        public List<String> resources;
        Public String startTime;
        Public String territoryId;
    }
    public List<Candidates> candidates;
    /**
    * @description : Parsed Json return method
    * @author Accenture | 03-24-2023 
    * @param json 
    * @return RS_SchedulerJsonParser 
    **/
    public static RS_SchedulerJsonParser parse(String json){
        return (RS_SchedulerJsonParser) System.JSON.deserialize(json,RS_SchedulerJsonParser.class);
    }
    }