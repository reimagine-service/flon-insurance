/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-13-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public without sharing class RS_CustomerPortalController {
    
    /**
    * @description 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-13-2023 
    * @return List<Knowledge__kav> 
    **/
    @AuraEnabled(cacheable=true)
    public static List<Knowledge__kav> getKnowledgeArticles(){
        List<Knowledge__kav> knowledgeArticles=[Select title,Summary,Content__c  from Knowledge__kav where PublishStatus = 'Online' WITH SECURITY_ENFORCED];
        return knowledgeArticles;
        
    }
    
    /**
    * @description 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-13-2023 
    * @param selectChoice 
    * @return List<Knowledge__kav> 
    **/
    @AuraEnabled(cacheable=true)
    public static List<Knowledge__kav> getSuggestedKnowledgeArticles(List<String> selectChoice){
        if(selectChoice!=null){
        List<Knowledge__kav> allknowledgeArticles = new  List<Knowledge__kav>();
        List<Knowledge__kav> knowledgeArticles= new  List<Knowledge__kav>();
        Set<Knowledge__kav> myset = new Set<Knowledge__kav>();
        
        For(String s:selectChoice){
            knowledgeArticles=[Select title,Summary,Content__c from Knowledge__kav where title like:'%'+s+'%' and PublishStatus = 'Online' WITH SECURITY_ENFORCED];
             myset.addAll(knowledgeArticles);
        }
        allknowledgeArticles.addAll(myset);
        
        return allknowledgeArticles;
        }
        return null;
    }
    

}