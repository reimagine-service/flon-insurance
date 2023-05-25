/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-13-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class RS_ChatTranscriptAPI {
        
    /**
    * @description 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-13-2023 
    * @param caseId 
    * @return List<Object> 
    **/
    @AuraEnabled
    public static List<Object> jsonToLWC(String caseId){
        ContentDocumentLink cl= [SELECT Id, LinkedEntityId, ContentDocumentId, Visibility, 
                         ContentDocument.Title, ContentDocument.createdDate, 
						             ContentDocument.FileType FROM ContentDocumentLink WHERE LinkedEntityId =:caseId WITH SECURITY_ENFORCED order by ContentDocument.createdDate DESC limit 1];
            ContentVersion cv     =	[SELECT Checksum,ContentBodyId,
                                    ContentDocumentId,ContentLocation,
                                    Title,VersionData,VersionNumber
                                    FROM ContentVersion WHERE ContentDocumentId =:cl.ContentDocumentId WITH SECURITY_ENFORCED];
            blob b = cv.VersionData;
            String s = EncodingUtil.base64Decode(EncodingUtil.base64Encode(b)).toString();        
            List<Object> fieldList = (List<Object>)JSON.deserializeUntyped(s);	        
            return fieldList;
          
    }
}