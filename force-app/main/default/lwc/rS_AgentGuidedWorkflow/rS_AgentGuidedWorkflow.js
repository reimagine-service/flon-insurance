import { LightningElement,track,wire,api } from 'lwc';
import getAgentWorkflowWithChoices from '@salesforce/apex/RS_AgentGuidedWorkflow.getAgentWorkflowWithChoices';
import createWorkflowChoices from '@salesforce/apex/RS_AgentGuidedWorkflow.createWorkflowChoices';
import getActionNumberType from '@salesforce/apex/RS_AgentGuidedWorkflow.getActionNumberType';
import getRecordType from '@salesforce/apex/RS_AgentGuidedWorkflow.getRecordType';
import getScriptingDataForNoChildRecord from '@salesforce/apex/RS_AgentGuidedWorkflow.getScriptingDataForNoChildRecord';
import Id from '@salesforce/user/Id';
import getWorkflowRootNode from '@salesforce/apex/RS_AgentGuidedWorkflow.getWorkflowRootNode';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class RS_AgentGuidedWorkflow extends LightningElement {

    @track workflowSets =[];
    @track selectedIntent='';
    @api workflowChoiceId;
    @track selectedChoices = '';
    @api workActionNumber =[];
    @api actionNumberList=[];
    @api recordId;
    @api script=[];
    @api buttonLabel =[];
    @api objectApiName;
    @track currenObjectName;
    @track casefieldstoupdate=[];
    @track caseRecordTypeName;
    userId=Id;
    @track workflowRootNode;//Variable to save the workflow root node for different users.
    @track customCtor;
    @track guidedworkflowHeadingLabel;
    workflowSFNumberGlobal;
    refreshbuttonclicked=false;
    firstButtonClicked = false;
    unhideConfirmationScreen = false;
    unhideConfirmationDummyScreen = false; // To be removed
    
    

   

    connectedCallback() {
         console.log('connectedCallback');
        console.log('Lense User Id',this.userId);
        //Method to get the root node from the GWRC field on current logged in user
          getWorkflowRootNode({ userId: this.userId})
        .then(result =>{
                    console.log('Worfklow Root Node',result);
                    this.workflowRootNode=result.workflowRootNode;
                    this.guidedworkflowHeadingLabel=result.guidedworkflowHeadingLabel;
                    this.loadInitialFlow();
        })
        this.currenObjectName = this.objectApiName;     

  } 
        refreshWorkflowData(){
            this.workflowSets=[];
            this.actionNumberList=[];
            this.casefieldstoupdate=[];
            this.caseRecordTypeName=null;
            this.loadInitialFlow();
        }

    renderWorkflows(event){
    console.log('inside render workflow method');
	this.disableSubmit=false;
	this.isEscalate = false;
	this.popupConfirmationScreen=false;
    var showErrorToast = true;
	this.confirmationScreenHeaderName='';
	var selectedChoiceWorkflowId = event.detail.WorkflowId;
     console.log('selectedChoiceWorkflowId',selectedChoiceWorkflowId);
     var inputdata=event.detail.InputMap;//Text to Case Input Object 
      if(typeof inputdata!== 'undefined'){
       console.log('Inside');
        for (let key in inputdata) {
           this.casefieldstoupdate.push(inputdata[key]);
           console.log(this.casefieldstoupdate);
        }
         // this.casefieldstoupdate.push(inputdata);
    }
    console.log('CASE FIELDS TO UPDATE',JSON.stringify(this.casefieldstoupdate));//Map passed to Confirmation Screen to save text to case values on case
    console.log('Case Field Length',this.casefieldstoupdate.length)
    console.log('selectedChoiceWorkflowId ' , JSON.stringify(selectedChoiceWorkflowId));
    console.log('selectedChoiceWorkflowId ' , selectedChoiceWorkflowId);
	var workflowSFNumber = selectedChoiceWorkflowId;
    workflowSFNumber = selectedChoiceWorkflowId.split(':SEQ:')[0];
    var workflowOrder = selectedChoiceWorkflowId.split(':SEQ:')[1];
   var workflowOrderString =workflowOrder.match(/\d+/g);
   workflowOrder=workflowOrderString.join();
    console.log('workflowOrder After Join',workflowOrder);
    this.reOrderWorkflowData(parseInt(workflowOrder));
    getActionNumberType({ actionName: workflowSFNumber})
        .then(result =>{

             var actionnumber;
             var actiontype;
             var componentName;
              if(result.length<=3){
                actionnumber =result[0];
                actiontype=result[1];
                componentName= result[2];
              }

		this.actionNumberList.push(actionnumber);
        console.log('actionNumberList',JSON.stringify(this.actionNumberList));
        this.workActionNumber = actionnumber; 
  
        if(actiontype=='LWC'){
			this.createWorkflowChoices(this.actionNumberList,this.recordId);
		}
        if(this.workActionNumber != null && this.workActionNumber != '' && this.workActionNumber != undefined){
        var workflowNumber = this.workActionNumber;
            this.workflowSFNumberGlobal = workflowSFNumber;
            this.loadNextWorkFlow(workflowSFNumber,workflowNumber,parseInt(workflowOrder), showErrorToast); 
        }
        })
   
	}


    reOrderWorkflowData(workflowOrder){
        var i = this.workflowSets.length;
        console.log('workflowOrder Inside reOrderWorkflowData',workflowOrder);
        console.log('existingWorkflowRec',((this.workflowSets[i-1].parentWorkflowUniqueId).split(':SEQ:')[1]));
        var temp=((this.workflowSets[i-1].parentWorkflowUniqueId).split(':SEQ:')[1]);
        var existingworkflowRecString=temp.match(/\d+/g);
        console.log('existingworkflowRecString',JSON.stringify(existingworkflowRecString));
        console.log('existingworkflowRecStringminus',existingworkflowRecString.join());
        var existingWorkflowRec = parseInt(existingworkflowRecString.join()); 
        console.log('existingWorkflowRecInteger',existingWorkflowRec);
            if(existingWorkflowRec >= workflowOrder){
                for(var j=0; j < (existingWorkflowRec - workflowOrder); j++){
                   this.workflowSets.pop();
                   this.actionNumberList.pop();
                }
            }  
    }

    // Code TO be Removed
    callConfirmationDummy(){
        this.unhideConfirmationScreen = false;
        this.unhideConfirmationDummyScreen = true;
    }

 loadNextWorkFlow(workflowSFNumber,workflowNumber,workflowOrder,showErrorToast){
     console.log('Inside loadNextWorkFlow workflowNumber ', workflowNumber);
    getAgentWorkflowWithChoices({ workflowNumber:workflowNumber})
        .then(result =>{
            console.log('result workflowchoices ', result);
            var choices = [];
            if(result.length!==0){
                result.forEach(workflowData =>{
                    var agentselection = workflowData.RS_Action_Name__r.RS_Agent_Selection__c ? workflowData.RS_Action_Name__r.RS_Agent_Selection__c : '';
                    //console.log('agentselection',agentselection);
                    var choice ={
                        variant: 'neutral',
                        workflowId:workflowData.RS_Action_Name__r.Name+':SEQ:'+((workflowOrder+1).toString()),
                        label: agentselection,
                        wfId: workflowData.RS_Action_Name__r.Name,
                        isIntent: workflowData.RS_Action_Name__r.RS_IsIntent__c,
                        actionType: workflowData.RS_Action_Name__r.RS_Action_Type__c,
                        textfieldtoupdate:workflowData.RS_Action_Name__r.Text_Field_To_Update__c,
                        parentRecordId:result[0].RS_Parent__c,
                        textfielddatatype:workflowData.RS_Action_Name__r.RS_Text_Field_Type__c,
                        mandateinput:workflowData.RS_Action_Name__r.RS_Mandatory_Input__c
                        };
                        console.log('choice');
                    choices.push(choice);
                    });
                    var workflowSet = {
                        parentWorkflowUniqueId: result[0].RS_Parent__r.RS_Action_Name__c+':SEQ:'+(workflowOrder+1).toString(),
                        parentAgentInstraction: result[0].RS_Parent__r.RS_Agent_Instructions__c,
                        parentScripting: result[0].RS_Parent__r.RS_Scripting_Data__c,
                        parentAdditionalAgentInstructions: result[0].RS_Parent__r.RS_Additional_Agent_Instructions__c,
                        choices: choices,
                        focus:'YES'
                    }
                    this.workflowSets.push(workflowSet);
                }
                else if(result.length==0){
                    console.log('inside else condition');
                    getScriptingDataForNoChildRecord({ workflowNumber:workflowNumber})
                        .then(resultData =>{
                            console.log("inside result getScriptingDataForNoChildRecord",resultData);
                            var additionalAgentInstruction1 = resultData[0].RS_Additional_Agent_Instructions__c ? result[0].RS_Additional_Agent_Instructions__c : null;
                            var parentInstruction1 = resultData[0].RS_Agent_Instructions__c? resultData[0].RS_Agent_Instructions__c : '';
                            var actionName1 = resultData[0].RS_Action_Name__c ? resultData[0].RS_Action_Name__c +':SEQ:'+(workflowOrder+1).toString() :''; 
                            console.log('actionName ' , actionName1);
                            var workflowSet1 = {
                                parentWorkflowUniqueId: actionName1 ,
                                parentAgentInstraction: parentInstruction1,
                                parentScripting: resultData[0].RS_Scripting_Data__c,
                                parentAdditionalAgentInstructions:additionalAgentInstruction1,
                                choices: '',
                                focus:''
                              }
                              console.log('workflowSet' , JSON.stringify(workflowSet1));
                            this.workflowSets.push(workflowSet1);
                            });
                       
                }
                else if(showErrorToast){
                    const showToast = new ShowToastEvent({
                        title:'Sorry! No further choices found',
                        message: 'Please Choose another optio',
                        variant :'error',
                        mode: 'sticky'
                    });
                    this.dispatchEvent(showToast);
               } 
            })
           
}      
loadInitialFlow(){
    console.log('loadInitialFlow');
     let workflowNumber;
    if(this.workflowRootNode!=null){
     workflowNumber = this.workflowRootNode;
    }
    console.log('this.workflowRootNode',this.workflowRootNode);
    getAgentWorkflowWithChoices({ workflowNumber:this.workflowRootNode})
        .then(result =>{
             console.log('result',result.length);
             console.log('Result',JSON.stringify(result));
            let choices = [];
            if(result.length!==0){
               console.log('Inside');
                result.forEach(workflowData =>{
                        console.log('Inside');
                     var agentselection = workflowData.RS_Action_Name__r.RS_Agent_Selection__c ? workflowData.RS_Action_Name__r.RS_Agent_Selection__c : '';
                      console.log('agentselection336',agentselection);       
                       console.log('agentselection',(workflowData.RS_Action_Name__r.Name+':SEQ:'+((workflowNumber).toString())));             
                    var choice ={
                        variant:'neutral',
                        workflowId:workflowData.RS_Action_Name__r.Name+':SEQ:'+((workflowNumber).toString()),
                        label:agentselection,
                        wfId:workflowData.RS_Action_Name__r.Name,
                        isIntent:workflowData.RS_Action_Name__r.RS_IsIntent__c,
                        actionType:workflowData.RS_Action_Name__r.RS_Action_Type__c,
                        textfieldtoupdate:workflowData.RS_Action_Name__r.Text_Field_To_Update__c,
                        parentRecordId:result[0].RS_Parent__c,
                        textfielddatatype:workflowData.RS_Action_Name__r.RS_Text_Field_Type__c,
                        mandateinput:workflowData.RS_Action_Name__r.RS_Mandatory_Input__c
                        };
                     console.log('choice',JSON.stringify(choice));
                    choices.push(choice);
                     console.log('choices',JSON.stringify(choices));
                    });
                    console.log('before additionalAgentInstruction');
                    var additionalAgentInstruction = result[0].RS_Parent__r.RS_Additional_Agent_Instructions__c ? result[0].RS_Parent__r.RS_Additional_Agent_Instructions__c : null;
                    console.log('additionalAgentInstruction',additionalAgentInstruction);
                    var workflowSet = {
                        parentWorkflowUniqueId: result[0].RS_Parent__r.RS_Action_Name__c+':SEQ:'+(workflowNumber).toString(),
                        parentAgentInstraction: result[0].RS_Parent__r.RS_Agent_Instructions__c,
                        parentScripting: result[0].RS_Parent__r.RS_Scripting_Data__c,
                        parentAdditionalAgentInstructions: additionalAgentInstruction,
                        choices: choices,
                        focus:'YES'
                    }
                   console.log('workflowSet',workflowSet);
                    this.workflowChoiceId=null;
                    console.log('workflowChoiceId',this.workflowChoiceId);
                    this.workflowSets.push(workflowSet);
                 }
                
        })
    }
    createWorkflowChoices(actionNumberList,recordId){
    createWorkflowChoices({choices:this.actionNumberList,recordID:this.recordId,userId:this.userId})
        .then(result =>{
            console.log('result' , result);
              this.workflowChoiceId= result; 
              console.log('this.workflowChoiceId',this.workflowChoiceId);
              //this.unhideConfirmationScreen = true;
              this.getRecordType(this.workflowChoiceId);
              this.unhideConfirmationDummyScreen = false;
              //unhideConfirmationScreen=true;
              //this.createNewCase(this.workflowChoiceId,this.recordId);   
			  });
}

getRecordType(workflowChoiceId){
    getRecordType({name:this.workflowChoiceId})
        .then(result =>{
            console.log('recordTypeName',result);
            this.caseRecordTypeName=result;
            this.unhideConfirmationScreen = true;
        })
}
   
    hideModalBox() {  
        this.unhideConfirmationScreen = false;
    //     setTimeout(() => {
    //         eval("$A.get('e.force:refreshView').fire();");
    //    },1000);
      
        //window.location.reload();
    }
}