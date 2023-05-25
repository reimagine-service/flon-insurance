/**
* @description       : Class to validate the Business Hours
* @author            : Accenture
* @group             : 
* @last modified on  : 06-09-2022
* @last modified by  : Accenture
**/
public class RS_BusinessHourBot {
    
    /**
* @description 
* @author  Accenture| 07-13-2022 
* @return   List<Boolean>: Set as true if current time is within business hours
**/
    
    //@InvocableVariable public Boolean result;
    
    @InvocableMethod
    public static List<Boolean> isBusinessHours() {
        Boolean result = RS_BusinessHoursUtility.isBusinessHours();
        List<Boolean> boolList = new List<Boolean>();
        boolList.add(result);
        return boolList;
    }
}