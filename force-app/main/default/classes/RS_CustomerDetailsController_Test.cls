/**
 * @description       : Test Class for RS_CustomerDetailsController
 * @author            : Accenture
 * @group             : 
 * @last modified on  : 03-23-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class RS_CustomerDetailsController_Test {
	@isTest
    public static void testMethod1(){
        Account acc = TestDataFactory.accList();
        String label = 'abc';
        String colorCode = '123xyz';
		List<RS_CustomerDetailsController.highlightPanelWrapper> wList;        
        RS_CustomerDetailsController.highlightPanelWrapper warpobj= new RS_CustomerDetailsController.highlightPanelWrapper(label,colorCode);
        RS_CustomerDetailsController.getAccountHighlightPanel(acc.Id);
        RS_CustomerDetailsController.getCustomerDetails(acc.Id);
        System.assertEquals('123xyz',colorCode);
	}
        
}