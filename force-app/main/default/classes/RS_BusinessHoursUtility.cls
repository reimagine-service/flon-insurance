/**
* @description       : Class to validate the Business Hours
* @author            : Accenture
* @group             : 
* @last modified on  : 06-09-2022
* @last modified by  : Accenture
**/
global with sharing class RS_BusinessHoursUtility {
    /**
* @description : Method to check if current time is within business hours
* @author  Accenture| 07-13-2022 
**/
    global static boolean isBusinessHours() {
        BusinessHours businessHoursId;
        if(Schema.getGlobalDescribe().get('BusinessHours').getDescribe().isAccessible()) { 
            businessHoursId=[SELECT Id FROM BusinessHours WHERE IsDefault=true WITH SECURITY_ENFORCED];
        }
        return  BusinessHours.isWithin(businessHoursId.id, System.Now());
    }
}