/**
 * @description       : Invocable Method Used at Bot to fetch the service resources available for specified data and time
 * @author            : Accenture
 * @group             : 
 * @last modified on  : 03-23-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global class RS_CallSchedulerAPI {
    
    /**
    * @description 
    * @author Accenture | 03-23-2023 
    * @param apiparam 
    * @return List<String> 
    **/
    @invocableMethod()
    global static List<String> getSlots(List<ParametersForm> apiparam){
        String datevalue = apiparam[0].preferredDate;
        String starttimevalue = 'T00:00:00.000+0000';
        String endtimevalue = 'T23:59:00.000+0000';
        String startDate = datevalue + starttimevalue;
        String endDate = datevalue + endtimevalue;
        String accId = [Select id from Account where AccountNumber =: apiparam[0].accountNumber WITH SECURITY_ENFORCED limit 1]?.id;
        String wTId = [Select id from WorkTypeGroup where Name =: apiparam[0].worktypeName WITH SECURITY_ENFORCED limit 1]?.id;
        String sTId = [Select id from ServiceTerritory where Name =: apiparam[0].serviceTerrName WITH SECURITY_ENFORCED limit 1]?.id;
        String requestBody = '{"startTime":"'+startDate+'","endTime":"'+endDate+'","accountId":"'+accId+'","workTypeGroupId":"'+wTId+'","territoryIds":["'+sTId+'"]}';
        List<String> result = new List<String>();
        try{
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:SalesforceOrg/services/data/v56.0/scheduling/getAppointmentCandidates');
            request.setMethod('POST');
            request.setbody(requestbody);
            request.setHeader('content-type', 'application/json');            
            HttpResponse response = http.send(request);
            String responseBody = response.getBody();
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
            List<Object> candidates = (List<Object>) responseMap.get('candidates');
            if (candidates.isEmpty()) {
                // The candidates array is empty
                return null;
            }
            else{
                result.add(response.getBody());
                return result;
            }
        }
        catch(Exception e){
            system.debug('ERROR >>>>>' + e.getMessage());
            return result;
        } 
    }
    
    /**
    * @description : Inner class to fetch the parameters from bot
    * @author Accenture | 03-23-2023  
    **/
    global class ParametersForm {
        @InvocableVariable(label='preferredDate' required=true)
        global String preferredDate;
        @InvocableVariable(label='accountNumber' required=true)
        global String accountNumber;
        @InvocableVariable(label='WorktypeName' required=true)
        global String worktypeName;
        @InvocableVariable(label='ServiceTerrName' required=true)
        global String serviceTerrName;
    }
    
}