import { api, LightningElement, track, wire } from 'lwc';
import { getRecord,getRecordNotifyChange } from 'lightning/uiRecordApi';
import getAccountList from '@salesforce/apex/RS_SearchAndAuthenticateController.getAccountList';
import verifyCustomer from '@salesforce/apex/RS_SearchAndAuthenticateController.verifyCustomer';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { FlowNavigationNextEvent , FlowNavigationBackEvent } from 'lightning/flowSupport';

export default class RS_AccountDetailsListForExistingUser extends LightningElement {
    @track DataTableResponseWrappper;
    @track finalSObjectDataList;
    @api firstname;
    @api lastname;
    @api accNumber;
    @api emailId;
    @api phoneNumber;
    @api condition;
    @api InteractionId;
    @api availableActions = [];

    @track accData;
    @track errorAccData;
    @track isLoading = false;  

      connectedCallback() {
      console.log('name : ', this.firstname, this.lastname);
      getAccountList({firstname:this.firstname, lastname:this.lastname, accNumber:this.accNumber, emailId:this.emailId, phoneNumber:this.phoneNumber, condition:this.condition })
      .then(data =>{
        
       let sObjectRelatedFieldListValues = [];
            console.log('datat dynamic table ' , data );
           for (let row of data.lstDataTableData) 
           {
               console.log('row ' + JSON.stringify(row));
                const finalSobjectRow = {}
                let rowIndexes = Object.keys(row); 
                rowIndexes.forEach((rowIndex) => 
                {
                    const relatedFieldValue = row[rowIndex];
                    if(relatedFieldValue.constructor === Object)
                    {
                        this._flattenTransformation(relatedFieldValue, finalSobjectRow, rowIndex)        
                    }
                    else
                    {
                        finalSobjectRow[rowIndex] = relatedFieldValue;
                    }
                    
                });
                sObjectRelatedFieldListValues.push(finalSobjectRow);
            }
            this.DataTableResponseWrappper = data;
            this.finalSObjectDataList = sObjectRelatedFieldListValues;
      })
      .catch(error =>{
        this.errorAccData = error;
      })
    }
 
_flattenTransformation = (fieldValue, finalSobjectRow, fieldName) => 
    {        
        let rowIndexes = Object.keys(fieldValue);
        rowIndexes.forEach((key) => 
        {
            let finalKey = fieldName + '.'+ key;
            finalSobjectRow[finalKey] = fieldValue[key];
        })
    }


    getSelectedRec() {
        var selectedRecords =  this.template.querySelector("lightning-datatable").getSelectedRows();
        if(selectedRecords.length > 0){
            console.log('selectedRecords are ', selectedRecords);
            let ids = '';
            selectedRecords.forEach(currentItem => {
                ids = ids + ',' + currentItem.Id;
            });
            this.selectedIds = ids.replace(/^,/, '');
            this.lstSelectedRecords = selectedRecords;
            //alert(this.selectedIds);
            console.log('selected record : ', this.selectedIds);
            console.log('Interaction RecordId : ', this.InteractionId);
            verifyCustomer({custId: this.selectedIds, interactionId: this.InteractionId})
            .then(()=>{
                this.showToast("Verified",'Customer Verified Successfully',"success");
                if (this.availableActions.find(action => action === 'NEXT')) {
                    const navigateNextEvent = new FlowNavigationNextEvent();
                    this.dispatchEvent(navigateNextEvent);
                }
                this.updateRecordView();

            }).catch(error=>{
            //error handling
            this.showToast("Error",error.body.message,"error")
            }).finally(()=>{
                this.handleIsLoading(false);
            });
        }
        if(selectedRecords.length == 0){
            this.showToast("Information",'Please select a choice',"info");
            
        }
    }

    navigatePrevious(){
        if (this.availableActions.find(action => action === 'BACK')) {
            const navigateBackEvent = new FlowNavigationBackEvent();
            this.dispatchEvent(navigateBackEvent);
        }
    }

    showToast(title, message, variant){
        this.dispatchEvent(new ShowToastEvent({
            title, message, variant
        }))
    }

    //show/hide spinner
    handleIsLoading(isLoading) {
        this.isLoading = isLoading;
    }
 
    updateRecordView() {
        //window.location.reload();
       setTimeout(() => {
            eval("$A.get('e.force:refreshView').fire();");
       },1000); 
      
    }
}