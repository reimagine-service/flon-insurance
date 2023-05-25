@istest
public class RS_markRetentionCustomerBatch_Testclass {
    @istest
    static void excecuteBatchTest(){
        RS_markRetentionCustomerBatch rsobj = new RS_markRetentionCustomerBatch();
        List<Account> acList = new List<Account>();
        Account acc=TestDataFactory.accList();
        system.assertEquals(false,String.isEmpty(acc.id));
        acc.High_End_Customer__c=true;
        acList.add(acc);
        update acList;
        
        Case cobj;
        List<Case> cslist = new List<Case>();
        for(Integer i =0;i<=10;i++){
            cobj= TestDataFactory.csList();
            cobj.AccountId=acc.id;
            cslist.add(cobj);
            
        }
        update cslist;
        List<Sentiment_Score__c> sclist= new List<Sentiment_Score__c>();
        for(integer i = 0; i<=10; i++){
            for(Case cs:cslist){
                Sentiment_Score__c  sc = new Sentiment_Score__c();
                sc.Customer_Sentiments__c ='Negative';
                sc.Case__c=cs.id;
                sc.Customer_Sentiment_Score__c = 0.75;
                sclist.add(sc);
            }
        }
        insert sclist;
        Decimal countcase =[Select No_of_Negative_Sentiments__c from case where id=:cobj.id]?.No_of_Negative_Sentiments__c;
        
        //Integer NegativeSentimentDays =1;
        //Integer RepeatedDays =0;
        //Integer NoofRepeatedCase=0;
        DataBase.executebatch(rsobj);
    }
    
    @istest
    static void excecutetest2(){
        RS_markRetentionCustomerBatch rsobj = new RS_markRetentionCustomerBatch();
        Account a=TestDataFactory.accList();
        system.assertEquals(false,String.isEmpty(a.id));
        a.Retention_Risk__c=true;
        update a;
        Case c;
        List<Case> cs1 = new List<Case>();
        for(Integer i =0;i<=8;i++){
            c= TestDataFactory.csList();
            c.AccountId=a.id;
            cs1.add(c);
        }
        update cs1;
        
        Decimal countcase =[Select No_of_Negative_Sentiments__c from case where id=:c.id]?.No_of_Negative_Sentiments__c;
        Sentiment_Score__c  sc = new Sentiment_Score__c ();
        //sc.Customer_Sentiment__c ='Negative';
        sc.Case__c=c.id;
        insert sc;
        //Integer NegativeSentimentDays =-1;
        //Integer RepeatedDays =0;
        //Integer NoofRepeatedCase=0;
        DataBase.executebatch(rsobj);
    }
    
}