/**
* @description       : This class is basically used to 4 digit case number from the string
* @author            : Accenture
* @group             : 
* @last modified on  : 05-20-2022
* @last modified by  : Accenture
**/
global with Sharing class RS_TogetCaseNumber {  
    /**
* @description 
* @author Accenture | 03-14-2022 
* @param List<String> str
* @return List<String> 
**/
    @InvocableMethod(label='Get Case Number')
    global static List<String> getCaseNumber(List<String> str) {
        String caseNumberString = str[0].substring(20, 24);
        List<String> ls= new List<String>();
        ls.add(caseNumberString);
        return ls;   
    }
    
}