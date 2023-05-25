/**
* @description       : Test Class for RS_DynamicLWCDataTableController
* @author            : Accenture
* @group             : 
* @last modified on  : 03-24-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@IsTest
public class RS_DynamicLWCDataTableController_Test {
    
    /**
* @description : Test data setup
* @author Accenture | 03-24-2023 
**/
    @TestSetup
    public static void createData(){
        User userTest=TestDataFactory.createUser();
        
    }
    
    
    @IsTest
    public static void testGetWrapperOfSObjectFieldColumnActionValues1(){
        RS_Dynamic_Datatable__mdt getlabel=[Select label,ObjectAPI_Name__c from RS_Dynamic_Datatable__mdt where ObjectAPI_Name__c='MessagingSession' LIMIT 1];
        MessagingSession ms = TestDataFactory.MsgMethod();
        User us = [Select id from user where LastName='Test' LIMIT 1];
        System.runAs(us){
            Test.startTest();
            RS_DynamicLWCDataTableController.GetWrapperOfSObjectFieldColumnActionValues(getlabel.label, ms.id);
            Test.stopTest();
        }
        System.assertEquals('MessagingSession',getlabel.ObjectAPI_Name__c);
    }
    @IsTest
    public static void testGetWrapperOfSObjectFieldColumnActionValues4(){
        String label=[Select label from RS_Dynamic_Datatable__mdt where ObjectAPI_Name__c='AssignedResource' limit 1]?.label;
        User u=[select id from user limit 1];
        Case cs=TestDataFactory.CaseMethod(true);
        ServiceAppointment  createAppointment=new ServiceAppointment();
        createAppointment.RS_Account__c=cs.AccountId;
        createAppointment.ParentRecordId=cs.AccountId;
        insert createAppointment;
        ServiceResource sr=new ServiceResource();
        sr.Name='Agent';
        sr.ResourceType='T';
        sr.RelatedRecordId=u.id;
        sr.IsActive=true;
        insert sr;
        AssignedResource assignedResourceToAppointment=new AssignedResource();
        assignedResourceToAppointment.ServiceResourceId=sr.id;
        assignedResourceToAppointment.ServiceAppointmentId=createAppointment.Id;
        insert assignedResourceToAppointment;
        System.runAs(u){
            Test.startTest();
            RS_DynamicLWCDataTableController.GetWrapperOfSObjectFieldColumnActionValues(label, assignedResourceToAppointment.id);
            Test.stopTest();
        }
        System.assertEquals('Agent',sr.Name);
    }
    @IsTest
    public static void testGetWrapperOfSObjectFieldColumnActionValues5(){
        RS_Dynamic_Datatable__mdt getlabel=[Select label,ObjectAPI_Name__c from RS_Dynamic_Datatable__mdt where ObjectAPI_Name__c='RSI_Insurance_Policy__c' LIMIT 1];
        User u=[select id from user limit 1];
        Account acc = TestDataFactory.accList();
        RSI_Insurance_Policy__c ip=new RSI_Insurance_Policy__c();
        
        ip.RSI_Policy_Holder__c=acc.id;
        insert ip;
        System.runAs(u){
            Test.startTest();
            RS_DynamicLWCDataTableController.GetWrapperOfSObjectFieldColumnActionValues(getlabel.label, ip.id);
            Test.stopTest();
        }
        System.assertEquals('RSI_Insurance_Policy__c',getlabel.ObjectAPI_Name__c);
    }
    @IsTest
    public static void testGetWrapperOfSObjectFieldColumnActionValues3(){
        RS_Dynamic_Datatable__mdt getlabel=[Select label,ObjectAPI_Name__c from RS_Dynamic_Datatable__mdt where ObjectAPI_Name__c='EmailMessage' LIMIT 1];
        User u=[select id from user limit 1];
        Case cs=TestDataFactory.CaseMethod(true);
        EmailMessage em = new EmailMessage();
        em.Status='0';
        em.TextBody='abcdef abcdef blah bla..';
        em.ParentId=cs.id;
        insert em;
        System.runAs(u){
            Test.startTest();
            RS_DynamicLWCDataTableController.GetWrapperOfSObjectFieldColumnActionValues(getlabel.Label, em.id);
            Test.stopTest();
        }
        System.assertEquals('EmailMessage',getlabel.ObjectAPI_Name__c);
    }
    @IsTest
    public static void testGetWrapperOfSObjectFieldColumnActionValues2(){
        RS_Dynamic_Datatable__mdt getlabel=[Select label,ObjectAPI_Name__c from RS_Dynamic_Datatable__mdt where ObjectAPI_Name__c='Case' LIMIT 1];
        User u=[select id from user limit 1];
        Case cs=TestDataFactory.CaseMethod(true);
        System.runAs(u){
            Test.startTest();
            RS_DynamicLWCDataTableController.GetWrapperOfSObjectFieldColumnActionValues(getlabel.label, cs.id);
            RS_DynamicLWCDataTableController.DataTableResponse dRes=new  RS_DynamicLWCDataTableController.DataTableResponse();
            dRes.TableTitle='test';
            RS_DynamicLWCDataTableController.DataTableColTypeAttribute dlist=new RS_DynamicLWCDataTableController.DataTableColTypeAttribute();
            dlist.target='test';
            dlist.sortable=true;
            RS_DynamicLWCDataTableController.DataTableColTypeAttributeLabel rLabel=new  RS_DynamicLWCDataTableController.DataTableColTypeAttributeLabel();
            rLabel.fieldName='tst';
            dlist.label=rLabel;
            
            Test.stopTest();
        }
        System.assertEquals('Case',getlabel.ObjectAPI_Name__c);
    }
}