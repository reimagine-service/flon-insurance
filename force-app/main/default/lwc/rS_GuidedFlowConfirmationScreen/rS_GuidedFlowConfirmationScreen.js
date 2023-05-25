import { api, LightningElement, track,wire } from 'lwc';
import { getRecord, getRecordNotifyChange } from 'lightning/uiRecordApi';
import userId from '@salesforce/user/Id';
import fetchFields from '@salesforce/apex/RS_GuidedFlowConfScreenController.fetchFields';
import getChoiceDetails from '@salesforce/apex/RS_GuidedFlowConfScreenController.getChoiceDetails';
import updateChoiceRecord from '@salesforce/apex/RS_GuidedFlowConfScreenController.updateChoiceRecord';
import getCommunityURL from '@salesforce/apex/RS_GuidedFlowConfScreenController.getCommunityURL';
//import communityBasePath from '@salesforce/community/basePath';
//import networkId from '@salesforce/community/Id';

export default class RS_GuidedFlowConfirmationScreen extends LightningElement {

    @api workflowChoice;    
    @api metadataRec;
    @api hideModalBox = false;
    @track isFieldsExist =false;
    @track mdtField;
    @track fieldsList=[];
    @track isSpinner = true;
    @track isLoaded = false;
    @track fieldVals = [];
    @track objName;
    @track ownerFlag = false;
    @track fieldToUpdate;
    @track caseToUpdate;
    @track createdRecId;
    @track showSave = true;
    @track successMessage='Record Successfully Created!!';
    @track choiceRecorId;
    @track casenumber;
    @api caseRecordType;
    @api textFieldsToUpdate=[];
    @track communityBasePath;

    fieldMap=[];
    disMap=[];
    
    @wire(getRecord, { recordId: '$recordId'})
    record;

     async handler() {
      // Update the record via Apex.
      await apexUpdateRecord(this.recordId);
      // Notify LDS that you've changed the record outside its mechanisms.
      getRecordNotifyChange([{recordId: this.recordId}]);
    }
    connectedCallback(){
        console.log('in cc');
        console.log('UserId',userId)
        console.log('mdtRec '+this.metadataRec);
        this.choiceRecorId = this.metadataRec;
        console.log('choicerecId : '+this.choiceRecorId);
         console.log('textFieldsToUpdate sfg',JSON.stringify(this.textFieldsToUpdate));
        if(this.choiceRecorId == ''){
            var delay = 1000;
            setTimeout(() => {
                console.log('in timeout');
                this.fetchDisplay();

            }, delay);
        }
        if(this.choiceRecorId != ''){
            console.log('not in timeout');
            this.fetchDisplay();
    }
    }

    fetchDisplay(){
        fetchFields({mdtRecName : this.choiceRecorId,caserecordtype:this.caseRecordType})
        .then(r =>{
                let result = r;
                  console.log('Inside fetchFields');
                console.log('result fetchFields',JSON.stringify(result));
                let mdtRec={};
                let mdtList = [];     
                mdtRec.Label = result[0].MasterLabel;
                mdtRec.ObjectName = result[0].Object_Name__c;
                mdtRec.LookUpField = result[0].Lookup_Field_to_Link__c;
                mdtRec.UpdateCaseId = result[0].Update_Case_Id__c;
            
                this.fieldToUpdate = result[0].Lookup_Field_to_Link__c;
                if(result[0].Update_Case_Id__c != null){
                    this.caseToUpdate = result[0].Update_Case_Id__c;
                }
                this.objName = result[0].Object_Name__c;
                mdtList.push(mdtRec);
                this.mdtField = mdtList;
                this.fieldMap = result[0].Field_Name__c.split(',');
                let disString = result[0].isDisabled__c;
                let arrDis = disString.split(',');
                this.disMap = arrDis;
                var inputlength=this.textFieldsToUpdate.length;
                 let options = [];
                 for (let key in this.textFieldsToUpdate) {
           options.push(this.textFieldsToUpdate[key]);
           console.log(options);
        }
                console.log('This.options ***************************',JSON.stringify(options));
                console.log('This.options ***************************',typeof options);
                getChoiceDetails({agentChoice :this.workflowChoice,inputTextField :this.textFieldsToUpdate,inputLength:inputlength,recordtypeid:this.caseRecordType})
                .then(res =>{
                    let resMap = res;
                    this.fieldVals = resMap;
                    console.log('Test Res Map',resMap);
                     console.log('this.fieldMap',this.fieldMap);

                    for(var i=0;i< this.fieldMap.length;i++){
                        let fieldSetWrapper ={};
                        let fld = this.fieldMap[i];
                        console.log('fld',fld);
                        if(fld.includes('SECTION:')){
                            fieldSetWrapper.Name = fld.split(':')[1];
                            fieldSetWrapper.Value = fld.split(':')[1];
                            fieldSetWrapper.isSection = true;
                            fieldSetWrapper.isOwner = false;
                        }
                        if(! (fld.includes('SECTION:'))){
                            let key = this.fieldMap[i];
                           
                            fieldSetWrapper.isSection = false;
                            if(fld.includes('OWNER:') && resMap.hasOwnProperty('OwnerId') ) { //&& Object.hasOwn(resMap, 'OwnerId')
                                key =  fld.split(':')[1];
                                fieldSetWrapper.Name = key;
                                fieldSetWrapper.isOwner = true;
                            }
                            else{
                            fieldSetWrapper.Name = key;
                            fieldSetWrapper.isOwner = false;}

                            
                        if(Object.hasOwn(resMap, key)){
                            console.log('fieldSetWrapper Value',fieldSetWrapper.Value);
                          fieldSetWrapper.Value = resMap[key];
                          console.log('fieldSetWrapper First',fieldSetWrapper);
                        }
                        else{
                            fieldSetWrapper.Value = '';
                             console.log('fieldSetWrapper First',fieldSetWrapper);
                        }

                        fieldSetWrapper.isDisabled = (this.disMap[i] === 'true') ? true:false;

                        console.log('Testing No Value',JSON.stringify(fieldSetWrapper));
                        }

                         if(this.choiceRecorId == 'VoiceCall'){
                              if((fld.includes('Origin'))){
                                    fieldSetWrapper.Value = 'Phone';
                                 }
                         }
                         if(this.choiceRecorId == 'MessagingSession'){
                              if((fld.includes('Origin'))){
                                    fieldSetWrapper.Value = 'SMS';
                                 }
                         }
                          if(this.choiceRecorId == 'LiveChatTranscript'){
                              if((fld.includes('Origin'))){
                                    fieldSetWrapper.Value = 'Chat';
                                 }
                         }
                         if(fld.includes('RSI_Transfer_to_new_state__c')){                            
                                     if(fieldSetWrapper.Value == 'false' || fieldSetWrapper.Value == ''){                                 
                                            fieldSetWrapper.Value = false;
                                                         }else{                                 
                                                             fieldSetWrapper.Value = true;
                                                         }
                                                       }
                                                       if(fld.includes('RSI_Insurance_Agent_Required__c')){                             
                                                         if(fieldSetWrapper.Value == 'false'){
                                                             fieldSetWrapper.Value = false;
                                                         }else{
                                                             fieldSetWrapper.Value = true;
                                                         }
                                                       }
                            if(fld.includes('RecordTypeId')){
                                fieldSetWrapper.isrecordtype=true;
                                console.log('fieldSetWrapper Record',JSON.stringify(fieldSetWrapper));
                            }

                        this.fieldsList.push(fieldSetWrapper);
                        this.isSpinner = false;
                    }

                })
                .catch(error =>{
                    console.log('error :'+JSON.stringify(error));
                })

                this.isFieldsExist = true;
                this.isLoaded = true;
            

        })
        .catch(error =>{
            console.log('error: '+JSON.stringify(error));
            var delay = 1000;
            setTimeout(() => {
                console.log('in timeout');
                this.fetchDisplay();
            }, delay);
        });
    }

    handleSubmit(event){
        console.log('in handleSubmit');
        event.preventDefault();
        let fields = event.detail.fields;
        console.log('this.fieldVals ' , JSON.stringify(this.fieldVals));
        let fvPairs = this.fieldVals;
        let ownerCheck = false;
        this.isSpinner = true;
        for(const x in fvPairs){
            if(!fields.hasOwnProperty(x)){
                console.log('handleSubmit : Prop : x', x);
                if(x === 'OwnerId'){
                    ownerCheck = true;
                }
                fields[x] = fvPairs[x];
            }   
        }
        for(const x in fields){
            let y = x;
            if(y.includes(' ')){
                delete fields[x];
            }
        }
        if(ownerCheck == false){
            fields['OwnerId'] = userId;
        }
        console.log('in handle submit end');
        console.log(JSON.stringify(fields));
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    handleSuccess(event){
        console.log('in success');
        let details = event.detail;
        console.log('detaisl handlesuccess ' , details);
        if(details.hasOwnProperty('id')){
            this.createdRecId = details.id;
        }
          console.log('detaisl handlesuccess ' , details.fields.CaseNumber.Value );
        this.showSuccessToast(details);

    }

    handleError(event){
        console.log(event.detail);
        showSuccessToast('error','',JSON.stringify(event.detail),'error');
    }

    showSuccessToast(details){
        getCommunityURL({UserId:userId})
                .then(res =>{
                    console.log('res COMMUNITY',res);
                    this.communityBasePath=res;
                    console.log('in showToast ' , details.fields.CaseNumber.Value );
                    let x = details.fields;
                    console.log('x' ,JSON.stringify(x));
                    this.casenumber = x.CaseNumber.value;
                    console.log('y ' , this.casenumber);
                    this.fieldsList =[];
                    let urlId = '/' + details.id;
                    if(this.communityBasePath!=null){
                        console.log('communityBasePath Inside If /ReimagineInsurance/s/case/Case/00B5f00000CWOfQEAX' )
                    this.sfdcBaseURL = window.location.origin+'/'+this.communityBasePath+'/s/case'+urlId;
                    console.log('this.communityBasePath',this.communityBasePath);
                    console.log(' window.location.origin'+ window.location.origin);
                    console.log('this.sfdcBaseURL',this.sfdcBaseURL);
                    }
                    else{
                        this.sfdcBaseURL = window.location.origin + urlId;
                    }
                    console.log('this.sfdcBaseURL = window.location.origin;' , this.sfdcBaseURL);
                    //let xu=Network.getLoginUrl(networkId);
              //console.log('this.sfdcBaseURL = window.location.origin; xu' , xu);
                    // sforce.console.openSubtab(primaryTabId ,this.sfdcBaseURL, false, 
                    //         'salesforce', null, openSuccess, 'salesforceSubtab');
                    this.showSave = false;
                    console.log('event toast');
                   // this.successMessage='Case '+ y +' has been Successfully Created!!';
                      this.isSpinner = false;
                    console.log('UIUIHIh',this.workflowChoice +' '+this.fieldToUpdate+' '+this.createdRecId);
                    if(res==null){
                        console.log('Inside updateChoiceRecord');
                    updateChoiceRecord({choiceName : this.workflowChoice, fieldApiName : this.fieldToUpdate, updateCasefield :this.caseToUpdate ,  recId: this.createdRecId, newRecordId: details.id });
                    }//window.location.reload();
                })
       
    //     setTimeout(() => {
    //         eval("$A.get('e.force:refreshView').fire();");
    //    },1000);       
    }  
}