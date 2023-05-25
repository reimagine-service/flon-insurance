/**
* @description       : This class is basically used to get three recent open cases for a customer
* @author            : Accenture
* @group             : 
* @last modified on  : 05-20-2022
* @last modified by  : Accenture
**/
global with Sharing class RS_openCasesForexistingcase {
    /**
* @description 
* @author Accenture | 03-14-2022 
* @param List<InputForm> requestData 
* @return List<List<String>> 
**/
    @InvocableMethod(label='Get Open Cases')
    global static List<List<String>> getOpenCases(List<InputForm> requestData) {
        List<List<String>> conCases = new List<List<String>>();
        List<string> result = new List<String>();
        String endUser = requestData[0].endUser; 
        String accountNumber = requestData[0].accountNumber;
        if(Schema.getGlobalDescribe().get('MessagingEndUser').getDescribe().isAccessible()) {
            String msname = [select Name from MessagingEndUser where id =:endUser and id !=null  WITH SECURITY_ENFORCED limit 1]?.Name; 
            String accID;
            if(Schema.getGlobalDescribe().get('Account').getDescribe().isAccessible()) {
                accID =  [select Id from account where phone=:msname or AccountNumber=:accountNumber WITH SECURITY_ENFORCED limit 1]?.id; 
                List<Case> cases = [SELECT Subject,CaseNumber from Case Where AccountId =:accID and status!='Closed' and status!='Cancelled' and Account.AccountNumber!=null WITH SECURITY_ENFORCED ORDER BY createddate DESC LIMIT 3];
                if(cases != null && cases.size()>0){
                    for(case c:cases){
                        if(c.subject !=null){
                            result.add(system.Label.RS_forCaseNumber+' '+c.CaseNumber+' ' + system.Label.RS_forRegarding+' '+c.subject);
                        }
                        else{
                            result.add(system.Label.RS_forCaseNumber+' ' + c.CaseNumber);
                        }            
                    }
                    result.add(system.Label.RS_forAnyOtherCase);
                	conCases.add(result);
                }
            }
        }
        
        return conCases;  
    }
    
    /**
* @description       : This inner class is used to get the value from bot
* @author            : Accenture
* @group             : 
* @last modified on  : 05-20-2022
* @last modified by  : Accenture
**/
    global class InputForm {
        @InvocableVariable(label='endUser' required=true)
        global String endUser;
        @InvocableVariable(label='accountNumber' required=true)
        global String accountNumber;
    }
    
    
    
}