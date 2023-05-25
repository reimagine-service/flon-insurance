/**
 * @description       : Class to check if current time is within Business Working Hours or not
 * @author            : Accenture
 * @group             : 
 * @last modified on  : 03-23-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@RestResource(urlMapping='/BHours/*')
global with sharing class RS_BusinessHours{
    /**
    * @description : Method to check if current time is within Business Working Hours or not
    * @author Accenture | 03-23-2023 
    * @return boolean 
    **/
    @HttpGet
    global static boolean isBusinessHours() {
        BusinessHours businessHoursId;
        if(Schema.getGlobalDescribe().get('BusinessHours').getDescribe().isAccessible()) { 
            businessHoursId=[SELECT Id FROM BusinessHours WHERE IsDefault=true WITH SECURITY_ENFORCED];
        }
        string reqDateTime = RestContext.request.params.get('reqDateTime');
        DateTime checkDateTime = DateTime.parse(reqDateTime);
        return  BusinessHours.isWithin(businessHoursId.id, checkDateTime);
    }
}