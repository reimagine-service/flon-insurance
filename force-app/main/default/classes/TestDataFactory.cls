public without sharing class TestDataFactory {
    Public static User createUser(){
        User usr = new User();
        usr.ProfileId = [SELECT Id FROM Profile WHERE Name= 'System Administrator' limit 1].Id;                           
        usr.LastName = 'Test';
        usr.Email = 'test@test.com';
        usr.Username = 'test@test.com' + System.currentTimeMillis();
        usr.CompanyName = 'Salesforce';
        usr.Title = 'Title';
        usr.Alias = 'Roger';
        usr.TimeZoneSidKey = 'America/Los_Angeles';
        usr.EmailEncodingKey = 'UTF-8';
        usr.LanguageLocaleKey = 'en_US';
        usr.LocaleSidKey = 'en_US';
        usr.RS_Guided_Workflow_Rooting_Criteria__c='ProfileId';
        
        insert usr;
        Permissionset p =[select id from permissionset where name='RS_Admin'];
        Permissionset p1 =[select id from permissionset where name='Salesforce_Scheduler_Resource'];
        //Permissionset p2 =[select id from permissionset where name='ContactCenterAdminExternalTelephony'];
        insert new Permissionsetassignment(AssigneeId=usr.id,permissionsetid=p.id);
        insert new Permissionsetassignment(AssigneeId=usr.id,permissionsetid=p1.id);
       // insert new Permissionsetassignment(AssigneeId=usr.id,permissionsetid=p2.id);
        return usr;
    }
    public static Document doclist(){
        Document document;
        document = new Document();
        document.Body = Blob.valueOf('Some Text');
        document.ContentType = 'application/pem';
        document.DeveloperName = 'my_document';
        document.IsPublic = true;
        document.Name = 'predictiveservices';
        document.FolderId = [SELECT Id, Name FROM Folder where Name = 'Shared Documents']?.Id;
        if(Schema.getGlobalDescribe().get('Document').getDescribe().isCreateable()){
            insert document;
        }
        return document;
    }
    @TestVisible public static Account accList(){ 
        Recordtype recType=[select id from recordtype where DeveloperName='PersonAccount'];
        List<Account> accList = new List<Account>();
        Account acc = new Account();
        acc.AccountNumber='123456';
        acc.FirstName='fName';
        acc.LastName='lName';
        acc.Service_Recovery__c=false;
        acc.Phone='+18334133093';
        acc.RecordTypeId=recType.ID;
        User u =[Select name,Id from user where UserRoleId!=null LIMIT 1];
        acc.OwnerId=u.Id;
        if(Schema.getGlobalDescribe().get('Account').getDescribe().isCreateable()){
            Database.insert(acc);
        }        
        accList.add(acc);
        return acc;
    }
    public static Case csList(){
        Case cs = new Case();
        cs.Status ='New';
        cs.Origin ='Phone';
        cs.Type='Billing';
        cs.RS_Interactions__c=11;
        if(Schema.getGlobalDescribe().get('Case').getDescribe().isCreateable()){
            Database.insert(cs);
        }
        return cs;
    }
    public static EmailMessage emList(){
        Case cs= new case();
        insert cs;
        EmailMessage em = new EmailMessage();
        em.Status='0';
        em.TextBody='abcdef abcdef blah bla..';
        em.RelatedToId=cs.id;
        em.Incoming = true;
        if(Schema.getGlobalDescribe().get('EmailMessage').getDescribe().isCreateable()){
            insert em;
        }
        return em;
    }
    public static VoiceCall VCList(Boolean isInsert){
        VoiceCall vc=new VoiceCall();
        String callcenterID=[Select id from CallCenter where InternalName ='ACLightningAdapter']?.Id;
        Case cs= new case();
        insert cs;
       //vc.RS_Preferred_Callback_Time__c=DateTime.Now().addDays(1);
        vc.CallCenterId =callcenterID;
        vc.RS_Callback_Status__c='Requested';
        vc.IVRType__c='New Case';
        vc.VendorType ='ContactCenter';
        vc.CallType='Inbound';
        vc.ToPhoneNumber ='+18334133093';
        vc.IVRIntent__c='Billing';
        vc.FromPhoneNumber= '+16617480240';
        vc.CallStartDateTime =date.newInstance(2022, 20, 18);
        vc.CallEndDateTime = date.newInstance(2022, 20, 18);
        vc.VendorCallKey='ab1fafae-8202-4d39-a067-1082feb57c6d';
        vc.RS_Appointment_Scheduled__c=true;
        vc.RelatedRecordId = cs.Id;
        if(Schema.getGlobalDescribe().get('VoiceCall').getDescribe().isCreateable()){
            if(isInsert){
                insert vc;
            }
        }
        return vc;
    } 
    public static LiveChatTranscript LCList(Boolean isInsert){
        Case cs= new case();
        insert cs;
        LiveChatVisitor   lcv=new LiveChatVisitor();
        insert lcv;
        LiveChatTranscript lc = new LiveChatTranscript();
        lc.Body='Hi';
        lc.CaseId=cs.id;
        lc.LiveChatVisitorId=lcv.id;
        lc.Customer_Sentiment_Score__c=0.3;
        if(Schema.getGlobalDescribe().get('LiveChatTranscript').getDescribe().isCreateable()){
            if(isInsert){
                insert lc;
            }
        }
        return lc;
    }      
    public static Case CaseMethod(Boolean isInsert){
        RecordType recordtype=[Select Id from RecordType where SobjectType='Case' LIMIT 1];
        Account acc = accList();
        Case csobj = new Case();
        csobj.AccountId=acc.Id;
        csobj.Description='Test Description';
        csobj.RecordTypeId=recordtype.Id;
        csobj.Status='New';
        
        if(Schema.getGlobalDescribe().get('Case').getDescribe().isCreateable()){
            if(isInsert){
                insert csobj;
            }
        }
        return csobj;
    }
    public static Contact conMethod(Boolean isInsert){
        Contact con = new Contact();
        con.FirstName ='alish';
        con.LastName ='garg';
        User u =[Select name,Id from user where UserRoleId!=null LIMIT 1];
        con.OwnerId=u.Id;
        if(Schema.getGlobalDescribe().get('Contact').getDescribe().isCreateable()){
            if(isInsert){
                insert con;
            }
        }
        return con;
    }
    
    public static MessagingSession MsgMethod(){
        MessagingEndUser newMessagingEndUser= new MessagingEndUser();
        Account acc = accList();
        Case cs= new case();
        insert cs;
        String msgid=[Select Id from MessagingChannel where MessageType='Text' Limit 1]?.id;
        
        newMessagingEndUser.Name = '+4748152384';
        newMessagingEndUser.MessagingPlatformKey = '+4748152384';
        newMessagingEndUser.MessagingChannelId =msgid;
        newMessagingEndUser.MessageType ='Text';
        newMessagingEndUser.HasInitialResponseSent = false;
        newMessagingEndUser.MessagingConsentStatus = 'ImplicitlyOptedIn';
        insert newMessagingEndUser;
        
        MessagingSession messagingSessionToInsert = new MessagingSession();
        messagingSessionToInsert.MessagingChannelId =msgid;
        messagingSessionToInsert.MessagingEndUserId = newMessagingEndUser.Id;
        messagingSessionToInsert.TargetUserId = System.UserInfo.getUserId();
        messagingSessionToInsert.StartTime = System.now();
        messagingSessionToInsert.EndTime = System.now();
        messagingSessionToInsert.Origin = 'AgentInitiated';
        messagingSessionToInsert.Status = 'Ended';
        messagingSessionToInsert.CaseId = cs.id;
        messagingSessionToInsert.Related_Account__c = acc.id;
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        messagingSessionToInsert.SessionKey = guid;
        insert messagingSessionToInsert;
        
        return messagingSessionToInsert;
    }
    /*public static ConversationEntry ConversationEntryInsertMethod(){
ConversationEntry ce = new ConversationEntry();
//ce.ConversationId=msg.id;
ce.ActorType='EndUser';
ce.EntryType='Text';
ce.EntryTime=Datetime.newInstance(2022, 04, 12, 12, 30, 2);
ce.Seq=5;
insert ce;
return ce;
}*/
    public static MessagingEndUser MessagingMethod(){
        MessagingEndUser newMessagingEndUser= new MessagingEndUser();
        String msgid=[Select Id from MessagingChannel where MessageType='Text' Limit 1]?.id;
        
        newMessagingEndUser.Name = '+14748152384';
        newMessagingEndUser.MessagingPlatformKey = '+14748152384';
        newMessagingEndUser.MessagingChannelId =msgid;
        newMessagingEndUser.MessageType ='Text';
        newMessagingEndUser.HasInitialResponseSent = false;
        newMessagingEndUser.MessagingConsentStatus = 'ImplicitlyOptedIn';
        insert newMessagingEndUser;
        return newMessagingEndUser;
    }
    @TestVisible public static RS_Agent_Workflow__c createAgentWorkflowParent(){
        RS_Agent_Workflow__c agentWorkflow = new RS_Agent_Workflow__c();
        agentWorkflow.Name='Global Intro';
        agentWorkflow.RS_Step_Name__c='Global screen for customer conversation';
        agentWorkflow.RS_Action_Name__c='1';
        agentworkflow.RS_AutomatedNotes__c = 'test 1 ';
        agentWorkflow.RS_Case_Fields_to_Update__c='Type=Billing;RS_SubType__c=Unable to pay;OwnerId=Reimagine_Service_General_Query_Queue;';
        agentWorkflow.RS_Agent_Instructions__c='<p>Check Call reason on voice call record details. </p><p>Choose Script 1, if Call reason is not available </p><p>Choose Script 2, if call reason is available</p><p><a href="https://amazonaccelerator--rsdev1p0.lightning.force.com/lightning/r/Knowledge__kav/ka03C000000JJfrQAG/view" target="_blank">Click</a></p>';
        agentWorkflow.RS_Scripting_Data__c='<p>Script1: Call reason not available.</p><p>Hello (Caller Name), thank you for calling</p><p>Are you calling for an existing issue or new issue?</p><p><br></p><p>Script2: Call reason available.</p><p>Hello (Caller Name), thank you for calling Looks like you call for (call reason).</p>';
        agentWorkflow.Text_Field_To_Update__c='Type';
        
        insert agentWorkflow;
        return agentWorkflow;
    }
    @TestVisible public static RS_Agent_Workflow__c createAgentWorkflowChild(){
        RS_Agent_Workflow__c agentWorkflowChild1 = new RS_Agent_Workflow__c();
        agentWorkflowChild1.name='Call Reason- New Case';
        agentWorkflowChild1.RS_Step_Name__c='Identify issue for raising a new case';
        agentWorkflowChild1.RS_Action_Name__c='3';
        agentWorkflowChild1.RS_Agent_Selection__c='New Case';
        agentWorkflowChild1.RS_Action_Type__c= 'Button';
        agentWorkflowChild1.RS_AutomatedNotes__c = ' test 2';
        agentWorkflowChild1.RS_Case_Fields_to_Update__c='Type=Billing;RS_SubType__c=Unable to pay;';
        agentWorkflowChild1.RS_Agent_Instructions__c='Check Issue type on voice call record details.<br>Choose script 1, if issue type is not available<br>Choose script 2, if issue type is available';
        agentWorkflowChild1.RS_Scripting_Data__c='<p>Script 1: Issue type is not available </p><p><span style="color: rgb(0, 0, 0);">Can you please explain the issue you are facing </span></p><p><span style="color: rgb(0, 0, 0);">Script 2: Issue type is available </span></p><p><span style="color: rgb(0, 0, 0);">Looks like you are facing (issue type) issue. Can you please confirm.</span></p>';
        insert agentWorkflowChild1;
        return agentWorkflowChild1;
    }
    public static  Map<String,String> createAgentWorkflowChoices(){
        Map<String,String> choiceId = new  Map<String,String>();
        VoiceCall vc =TestDataFactory.VCList(true);
        RS_Agent_Workflow__c agentWorkflow=TestDataFactory.createAgentWorkflowChild();
        
        agentWorkflow.RS_Case_Fields_to_Update__c='Type=Billing;RS_SubType__c=Unable to pay;';
        update agentWorkflow;
        RS_Agent_Workflow_Choices__c agentWorkflowChoice = new RS_Agent_Workflow_Choices__c();
        agentWorkflowChoice.RS_Choices__c=agentWorkflow.RS_Action_Name__c;
        insert agentWorkflowChoice;
        String name = [Select name from RS_Agent_Workflow_Choices__c where id=:agentWorkflowChoice.id]?.name;
        choiceId.put(name,vc.id);
        return choiceId;
    }
    
    
    public static String createAgentChoices(){
        RS_Agent_Workflow_Choices__c choice = new RS_Agent_Workflow_Choices__c();
        
        List<RS_Agent_Workflow__c> wfList = new List<RS_Agent_Workflow__c>();
        wfList.add(TestDataFactory.createAgentWorkflowParent());
        wfList.add(TestDataFactory.createAgentWorkflowChild());
        String choices='';
        choice.RS_Voice_Call__c = (TestDataFactory.VCList(true)).Id;
        database.insert(choice);
        
        for(RS_Agent_Workflow__c wf: wfList){
            if(String.isBlank(choices)){
                choices = wf.RS_Action_Name__c;
            }
            else{
                choices= choices + ','+wf.RS_Action_Name__c;
            }
        }
        
        choice.RS_Account__c = TestDataFactory.accList().Id;
        choice.RS_Choices__c = choices;
        
        database.update(choice);
        String name = [Select name from RS_Agent_Workflow_Choices__c where id=:choice.id]?.name;
        return name;
    }
    
    /* Public Static RSI_Billing__c createBillingRecord(){
RSI_Billing__c testrecord= new RSI_Billing__c();
insert testrecord;
return testrecord;
}*/
    
}