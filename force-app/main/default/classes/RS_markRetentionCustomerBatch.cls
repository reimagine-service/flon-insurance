/**
* @description :This batch class is used for checking the customer eligibility for service recovery and updating their records.
* @author : Accenture
* @group :
* @last modified on : 04-12-2022
* @last modified by : Accenture
**/
global class RS_markRetentionCustomerBatch implements Database.Batchable<sObject>,Database.Stateful {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT id, Service_Recovery__c, High_End_Customer__c, New_Customer__c, Retention_Risk__c from Account where Service_Recovery__c = false ';
        return Database.getQueryLocator(query);          
    }
    
    global void execute(Database.BatchableContext bc, List<Account> scope) {
        try{
            // declare local variable
            List<Account> accList = new List<Account>();
            
            Map<String, List<String>> metaAccMap = new Map<String, List<String>>();
            Map<id,List<Case>> mapCaseId = new Map<id,List<Case>>();
            Map<id,List<AggregateResult>> mapArrId = new Map<id,List<AggregateResult>>();
            Map<id,List<AggregateResult>> mapArrCaseCount = new Map<id,List<AggregateResult>>();
            
            // Call getMetaMapAcc method to divide the scope in 4 parts
            metaAccMap = getMetaMapAcc(scope);
            // Call getCaseList method to get the case list from accounts categorised for each Service recovery configuration
            mapCaseId = getCaseList(metaAccMap);
            
            // Call getCaseCountType method to get count of cases of similar type for each service recovery configuration
            mapArrId = getCaseCountType(metaAccMap);
            // Call getCaseCount method to get count of cases where # of negative sentiments are above threshold difine under service recovery configuration
            mapArrCaseCount = getCaseCount(metaAccMap);

            // Iterate over scope to update Service Recovery field
            for(Account acc : scope){
                if(mapCaseId.containsKey(acc.Id)){
                    acc.Service_Recovery__c = true;
                } else if(mapArrId.containsKey(acc.Id)){
                    acc.Service_Recovery__c = true;
                } else if(mapArrCaseCount.containsKey(acc.Id)){
                    acc.Service_Recovery__c = true;
                }
                accList.add(acc);
            }
            Database.update(accList, false);
        }catch(Exception e){
            system.debug('Exception Message>>>>>' + e.getMessage());
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        AsyncApexJob job = [SELECT Id, Status FROM AsyncApexJob WHERE Id = :bc.getJobId()]; 
    }
    
    public static Map<String, List<String>> getMetaMapAcc (List<Account> scope){
        Map<String, List<String>> metaAccMap = new Map<String, List<String>>();
        for(Account acc : Scope){
            List<String> tempAcc= new List<String>();
            if(acc.High_End_Customer__c){
                System.debug('acc Id-->'+ acc.Id);
                System.debug('acc HEC --> '+ acc.High_End_Customer__c);
                if(metaAccMap.containsKey(Label.RS_High_end_customer)){
                    tempAcc=metaAccMap.get(Label.RS_High_end_customer);                                                          
                    tempAcc.add(acc.id);
                    metaAccMap.put(Label.RS_High_end_customer,tempAcc);
                }else{
                    tempAcc.add(acc.id);
                    metaAccMap.put(Label.RS_High_end_customer,tempAcc);
                }
            }
            if(acc.New_Customer__c){
                System.debug('acc Id-->'+ acc.Id);
                System.debug('acc NewC --> '+ acc.New_Customer__c);
                if(metaAccMap.containsKey(Label.RS_New_customer)){
                    tempAcc=metaAccMap.get(Label.RS_New_customer);                                                          
                    tempAcc.add(acc.id);
                    metaAccMap.put(Label.RS_New_customer,tempAcc);
                }else{
                    tempAcc.add(acc.id);
                    metaAccMap.put(Label.RS_New_customer,tempAcc);
                }
            }
            if(acc.Retention_Risk__c){
                System.debug('acc Id-->'+ acc.Id);
                System.debug('acc RRC --> '+ acc.Retention_Risk__c);
                if(metaAccMap.containsKey(Label.RS_Retention_Risk_Customer)){
                    tempAcc=metaAccMap.get(Label.RS_Retention_Risk_Customer);                                                          
                    tempAcc.add(acc.id);
                    metaAccMap.put(Label.RS_Retention_Risk_Customer,tempAcc);
                }else{
                    tempAcc.add(acc.id);
                    metaAccMap.put(Label.RS_Retention_Risk_Customer,tempAcc);
                }
            }
            if(!acc.High_End_Customer__c){
                System.debug('acc Id-->'+ acc.Id);
                System.debug('acc NorC --> '+ acc.High_End_Customer__c);
                if(metaAccMap.containsKey(Label.RS_Normal_Customer_Configuration)){
                    tempAcc=metaAccMap.get(Label.RS_Normal_Customer_Configuration);                                                          
                    tempAcc.add(acc.id);
                    metaAccMap.put(Label.RS_Normal_Customer_Configuration,tempAcc);
                }else{
                    tempAcc.add(acc.id);
                    metaAccMap.put(Label.RS_Normal_Customer_Configuration,tempAcc);
                }
            }
        }
        return metaAccMap;
    }
    
    public static Map<id,List<Case>> getCaseList(Map<String, List<String>> metaMap){
        List<Case> csList = new List<Case>();
        List<Case> templistCase = new List<Case>();
        Map<id,List<Case>> mapCaseId = new Map<id,List<Case>>();
        RS_serviceRecoverymatrix__mdt config1;
        List<String> lstAccId = new List<String>();
        for(List<String> lstAcc : metaMap.values()){
            lstAccId.addAll(lstAcc);
        }
        
        csList = [Select id, Type, AccountId, Status, Case_Open_Days__c, RS_Interactions__c, RS_Last_N_Negative_Interactions__c  from case
                  where AccountId IN:lstAccId AND Status !='Closed'];
        
        for(String st:metaMap.keyset()){
            config1 = RS_serviceRecoverymatrix__mdt.getInstance(st);
            for (Case cs :csList){
                list<string> tempStr=metaMap.get(st);
                if((cs.Case_Open_Days__c >=config1.Case_Open_Days__c ||  cs.RS_Interactions__c >=config1.Excessive_no_of_Interaction__c || (cs.RS_Last_N_Negative_Interactions__c >= config1.No_of_Last_negative_Sentiments__c && cs.RS_Interactions__c >=config1.No_of_Interactions__c)) && tempStr.contains(cs.AccountId)){
                    if(mapCaseId.containsKey(cs.AccountId)){
                        List<Case> listCase = mapCaseId.get(cs.AccountId);
                        listCase.add(cs);
                        mapCaseId.put(cs.AccountId,listCase);
                    }
                    else{
                        templistCase.add(cs);
                        mapCaseId.put(cs.AccountId,templistCase);
                    }
                }
            }
        }
        return mapCaseId;
    }
    
    public static Map<id,List<AggregateResult>> getCaseCountType(Map<String, List<String>> metaMap){
        
        List<AggregateResult> caseCountType = new List<AggregateResult>();
        List<AggregateResult> templistArr = new List<AggregateResult>();
        
        Map<id,List<AggregateResult>> mapArrId = new Map<id,List<AggregateResult>>();
        RS_serviceRecoverymatrix__mdt config1;
        
        for(String st:metaMap.keyset()){
            config1 = RS_serviceRecoverymatrix__mdt.getInstance(st);
            Date today = Date.today();
            Integer repeatedDays = Integer.valueOf(config1.Short_Time_for_Repeated_Cases_Days__c);
            Integer noofRepeatedCase=Integer.valueOf(config1.No_of_Repeated_Cases__c);
            System.debug('Config --> '+config1);
            System.debug('account list ---> '+ metaMap.get(st));
            caseCountType = [SELECT COUNT(id)caseCount, AccountId from case where AccountId IN:metaMap.get(st) AND
                             CreatedDate >=: today.addDays(-repeatedDays) group by type,AccountId];           
            if(!caseCountType.isempty()){
                for(AggregateResult arrRes : caseCountType){
                    if(double.valueOf(arrRes.get('caseCount'))>noofRepeatedCase){
                        Id accId = String.valueOf(arrRes.get('AccountId'));
                        if(mapArrId.containsKey(accId)){
                            List<AggregateResult> listArr = mapArrId.get(accId);
                            listArr.add(arrRes);
                            mapArrId.put(accId,listArr);
                        }
                        else{
                            templistArr.add(arrRes);
                            mapArrId.put(accId,templistArr);
                        }
                    }
                }
            }
        }
        return mapArrId;
    }
    
    public static Map<id,List<AggregateResult>> getCaseCount(Map<String, List<String>> metaMap){
        
        List<AggregateResult> countCase = new List<AggregateResult>();
        List<AggregateResult> templistArr = new List<AggregateResult>();
        
        Map<id,List<AggregateResult>> mapArrCaseCount = new Map<id,List<AggregateResult>>();
        RS_serviceRecoverymatrix__mdt config1;
        
        for(String st:metaMap.keyset()){
            config1 = RS_serviceRecoverymatrix__mdt.getInstance(st);
            Date today = Date.today();
            Integer negativeSentimentDays = Integer.valueOf(config1.Time_Span_for_Negative_Sentiments__c);
            countCase = [SELECT COUNT(id)caseCount,AccountId from case where AccountId IN:metaMap.get(st) AND
                         No_of_Negative_Sentiments__c >=: config1.No_of_Cases_with_negative_sentiments__c AND 
                         CreatedDate >=: today.addDays(-negativeSentimentDays) group by AccountId];
            if(!countCase.isempty()){
                for(AggregateResult arrRes : countCase){
                    if(double.valueOf(arrRes.get('caseCount')) > config1.No_of_ve_Sentiments__c){
                        Id accId = String.valueOf(arrRes.get('AccountId'));
                        if(mapArrCaseCount.containsKey(accId)){
                            List<AggregateResult> listArr = mapArrCaseCount.get(accId);
                            listArr.add(arrRes);
                            mapArrCaseCount.put(accId,listArr);
                        }
                        else{
                            templistArr.add(arrRes);
                            mapArrCaseCount.put(accId,templistArr);
                        }
                    }
                }
            }
        }
        return mapArrCaseCount;
    }
    
}