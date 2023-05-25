/**
* @description       : Controller to fetch configuration and data for the Dynamic Tab Screen 
* @author            : joel.samuel.s.penke@accenture.com
* @group             : SF
* @last modified on  : 06-29-2022
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class RS_DynamicTabSet {
    
    /**
* @description 
* @author  Accenture| 07-13-2022 
* @param recordName : Corresponding AccountId
* @return   List<RS_TabConfiguration__mdt>
**/
    
    @AuraEnabled
    public static List<RS_TabConfiguration__mdt> fetchTabs(String recordName){
        List<RS_TabConfiguration__mdt> mdtList = new List<RS_TabConfiguration__mdt>();
        RS_TabConfiguration__mdt mdtRec  =new RS_TabConfiguration__mdt();
        try {
            if(String.isNotBlank(recordName)){
                if(Schema.getGlobalDescribe().get('RS_TabConfiguration__mdt').getDescribe().isAccessible()){
                    mdtRec = [SELECT MasterLabel,DeveloperName, Child_ComponentType__c, Order__c,Parent__c,Active__c, Sequence__c from   RS_TabConfiguration__mdt WHERE Parent__c =:recordName AND Active__c = true WITH SECURITY_ENFORCED ORDER BY Sequence__c ASC LIMIT 1 ];
                }
            }
            Decimal order = (mdtRec != null && mdtRec.Order__c != null && ! mdtRec.Parent__c.contains('Standard')) ? (mdtRec.Order__c) : 1; 
            if(Schema.getGlobalDescribe().get('RS_TabConfiguration__mdt').getDescribe().isAccessible()){
                mdtList = [SELECT MasterLabel,DeveloperName, Child_ComponentType__c, Order__c, Parent__c,Active__c,Sequence__c from  RS_TabConfiguration__mdt WHERE Order__c =:order AND Parent__c =:recordName AND Active__c = true WITH SECURITY_ENFORCED ORDER BY Sequence__c ASC];
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return mdtList;
    }
}