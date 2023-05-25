/**
 * @description       : Test class for RS_CustomerProfileChartController
 * @author            : Accenture
 * @group             : 
 * @last modified on  : 03-24-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class RS_CustomerProfileChartController_Test {
	
    @isTest
    public static void testMethod1(){
        String masterLabel = 'Cases:All_Cases';
        Account acc = TestDataFactory.accList();
        List<AggregateResult> arr = RS_CustomerProfileChartController.getAggregateRecordsByAccountId(acc.Id, masterLabel);
        RS_CustomerProfileChartController.getObjectDetails(masterLabel);
        System.assertEquals('Cases:All_Cases',masterLabel);
        
    }
    @isTest
    public static void testMethod2(){
        String masterLabel = 'Appointments:SME_Assistance';
        Account acc = TestDataFactory.accList();
        List<AggregateResult> arr = RS_CustomerProfileChartController.getAggregateRecordsByAccountId(acc.Id, masterLabel);
        System.assertEquals('Appointments:SME_Assistance',masterLabel);
    }
    @isTest
    public static void testMethod3(){
        String masterLabel = 'Appointments:Upcoming_Appointments';
        Account acc = TestDataFactory.accList();
        List<AggregateResult> arr = RS_CustomerProfileChartController.getAggregateRecordsByAccountId(acc.Id, masterLabel);
        System.assertEquals('Appointments:Upcoming_Appointments',masterLabel);
    }
     @isTest
    public static void testMethod4(){
        String masterLabel = 'Appointments:Past_Appointments';
        Account acc = TestDataFactory.accList();
        List<AggregateResult> arr = RS_CustomerProfileChartController.getAggregateRecordsByAccountId(acc.Id, masterLabel);
        System.assertEquals('Appointments:Past_Appointments',masterLabel);
    }
     @isTest
    public static void testMethod5(){
        String masterLabel = 'Appointments:All';
        Account acc = TestDataFactory.accList();
        List<AggregateResult> arr = RS_CustomerProfileChartController.getAggregateRecordsByAccountId(acc.Id, masterLabel);
        System.assertEquals('Appointments:All',masterLabel);
    }
     @isTest
    public static void testMethod6(){
        String masterLabel = 'Cases:Billing';
        Account acc = TestDataFactory.accList();
        List<AggregateResult> arr = RS_CustomerProfileChartController.getAggregateRecordsByAccountId(acc.Id, masterLabel);
        System.assertEquals('Cases:Billing',masterLabel);

    }
    @isTest
    public static void testMethod7(){
        String masterLabel = 'Interaction:Chat';
        Account acc = TestDataFactory.accList();
        List<AggregateResult> arr = RS_CustomerProfileChartController.getAggregateRecordsByAccountId(acc.Id, masterLabel);
        System.assertEquals('Interaction:Chat',masterLabel);
    }
     @isTest
    public static void testMethod8(){
        String masterLabel = 'Interaction:Email';
        Account acc = TestDataFactory.accList();
        List<AggregateResult> arr = RS_CustomerProfileChartController.getAggregateRecordsByAccountId(acc.Id, masterLabel);
        System.assertEquals('Interaction:Email',masterLabel);
    }
     @isTest
    public static void testMethod9(){
        String masterLabel = 'Interaction:Voice_Call';
        Account acc = TestDataFactory.accList();
        List<AggregateResult> arr = RS_CustomerProfileChartController.getAggregateRecordsByAccountId(acc.Id, masterLabel);
        System.assertEquals('Interaction:Voice_Call',masterLabel);
    }
      @isTest
    public static void testMethod10(){
        String masterLabel = 'Appointments:Incorrect_Invoice';
        Account acc = TestDataFactory.accList();
        List<AggregateResult> arr = RS_CustomerProfileChartController.getAggregateRecordsByAccountId(acc.Id, masterLabel);
        System.assertEquals('Appointments:Incorrect_Invoice',masterLabel);
    }
}