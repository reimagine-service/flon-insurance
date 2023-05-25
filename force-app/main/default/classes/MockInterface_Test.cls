@isTest
public class MockInterface_Test {
    
     @isTest
    static void passThroughtest(){
         List<BestTimeToCall__x> bestTimeToCallList = new List<BestTimeToCall__x>();

    BestTimeToCall__x bestTimeToCall = new BestTimeToCall__x(AccountNumber__c = '111237',IssueType__c = 'Billing',Month__c = 'March');

    bestTimeToCallList.add(bestTimeToCall);

    ObjectManager.setMock(new MockInterfaceOverride(bestTimeToCallList));

    Test.startTest();
        MockInterface mock1 = new MockInterface();
            mock1.passThrough(bestTimeToCallList);
         Test.stopTest();
    }

}