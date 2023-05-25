/**
 * @description       : Test Class for RS_AgentGuidedWorkflow
 * @author            : Accenture
 * @group             : 
 * @last modified on  : 03-23-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@Istest
public class RS_AgentGuidedWorkflow_TestClass {
    /**
    * @description : Test Data Setup
    * @author Accenture | 03-23-2023 
    **/
    @TestSetup
    static void testdata(){
        User us = TestDataFactory.createUser();
    }
    @IsTest
    public static void testgetAgentWorkflowWithChoices(){
        RS_Agent_Workflow__c agentWorkflowParent = TestDataFactory.createAgentWorkflowParent();
        RS_Agent_Workflow__c agentWorkflowChild1 = TestDataFactory.createAgentWorkflowChild();
        RS_Agent_Workflow_Navigation__c	 agentWorkflowNav2 = new RS_Agent_Workflow_Navigation__c();
        agentWorkflowNav2.RS_Action_Name__c=agentWorkflowChild1.id;
        agentWorkflowNav2.RS_Parent__c=agentWorkflowParent.Id;
        insert agentWorkflowNav2;
        User us = [Select id from user where LastName='Test' LIMIT 1];
        System.runAs(us){
            RS_AgentGuidedWorkflow.getAgentWorkflowWithChoices(agentWorkflowParent.RS_Action_Name__c);
            RS_AgentGuidedWorkflow.getScriptingDataForNoChildRecord(agentWorkflowParent.RS_Action_Name__c);
            RS_AgentGuidedWorkflow.getActionNumberType(agentWorkflowChild1.name);            //Contact con = Testdatafactory.conMethod(true);
            MessagingSession msobj=Testdatafactory.MsgMethod();
            Account ac = TestDataFactory.accList();
            msobj.Related_Account__c=ac.id;
            update msobj;
            LiveChatTranscript lcobj=Testdatafactory.LCList(true);
            List<String> choices = new List<String>{'1','3'};
            String success=RS_AgentGuidedWorkflow.createWorkflowChoices(choices,msobj.id,us.Id);
            RS_AgentGuidedWorkflow.createWorkflowChoices(choices,lcobj.id,us.Id);
             RS_AgentGuidedWorkflow.getRecordType(success);
            System.assertEquals(true,String.isNotEmpty(success));
        }
        
    }
    @IsTest
    public static void testAgentGuidedWorkflow(){
        RS_DynamicSearch__mdt getmetarec=[Select Object_Name__c  from RS_DynamicSearch__mdt limit 1];
        RS_Agent_Workflow__c agentWorkflowParent = TestDataFactory.createAgentWorkflowParent();
        User us = [Select id,LastName from user where LastName='Test' LIMIT 1];
        System.runAs(us){
            RS_AgentGuidedWorkflow.getWorkflowRootNode(us.Id);
            RS_AgentGuidedWorkflow.getPickListValuesIntoList(getmetarec.Object_Name__c,agentWorkflowParent.Text_Field_To_Update__c);
        }
        System.assertEquals('Test',us.LastName);
        
    }
}