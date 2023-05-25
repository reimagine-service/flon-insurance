/**
 * @description       : Test Class for RS_unmarkRetentionCustomerBatch
 * @author            : Accenture
 * @group             : 
 * @last modified on  : 03-24-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@IsTest
public class RS_unmarkRetentionCustomerBatch_Test {
    @IsTest
    static void exceuteBatchTest(){
        RS_unmarkRetentionCustomerBatch rsobj = new RS_unmarkRetentionCustomerBatch();
        List<Account> acList = new List<Account>();
        Account acc=TestDataFactory.accList();
        acc.High_End_Customer__c=true;
        acc.Service_Recovery__c=true;
        acList.add(acc);
        update acList;
        Case c;
        List<Case> cslist = new List<Case>();
            c = TestDataFactory.csList();
            c.AccountId=acc.id;
        	c.Type = 'Billing';
            cslist.add(c);
        update cslist;
        System.assertEquals('Billing',c.Type);
        List<Sentiment_Score__c> sclist= new List<Sentiment_Score__c>();
                Sentiment_Score__c  sc = new Sentiment_Score__c();
                sc.Customer_Sentiments__c ='Positive';
                sc.Case__c=c.id;
                sc.Customer_Sentiment_Score__c = 0.75;
                sclist.add(sc);
        insert sclist;
        DataBase.executebatch(rsobj);
        
    }
        
    @istest
    static void excecutetest2(){
        RS_unmarkRetentionCustomerBatch rsobj = new RS_unmarkRetentionCustomerBatch();
        Account a=TestDataFactory.accList();
        a.Retention_Risk__c=true;
        a.Service_Recovery__c=true;
        update a;
        Case c = new Case();
        Sentiment_Score__c  sc = new Sentiment_Score__c();
        List<Case> cslist = new List<Case>();
        List<Sentiment_Score__c> scList = new List<Sentiment_Score__c>();
            c= TestDataFactory.csList();
            c.AccountId=a.id;
            cslist.add(c);
            sc.Customer_Sentiments__c ='Negative';
        	sc.Case__c=c.id;
        	sc.Customer_Sentiment_Score__c = 0.75;
            scList.add(sc);
        update cslist;
        System.assertEquals('Negative',sc.Customer_Sentiments__c);
        insert sc;
        Integer negativeSentimentDays =-1;
        Integer repeatedDays =0;
        Integer noofRepeatedCase=0;
        DataBase.executebatch(rsobj);
    }
    
   
    
}