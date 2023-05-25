import { LightningElement,api,track,wire} from 'lwc';
import getCustomerDetails from '@salesforce/apex/RS_CustomerDetailsController.getCustomerDetails';
import getAccountHighlightPanel from '@salesforce/apex/RS_CustomerDetailsController.getAccountHighlightPanel';
 //import {getObjectInfo} from 'lightning/uiObjectInfoApi';
 import Account from '@salesforce/schema/Account';

export default class RS_DynamicAccountPageParent extends LightningElement {
    @api recordId;
    @api objectApiName;
    @track recordtypeList=[];
    @track metarec=[];
    @api fields=[];
    @api Accountname;
    @track hightlighpanelList=[];
      @api pageTitle;
      @track RecordType;

     connectedCallback() {
         console.log('Inside child' , this.objectApiName);
          console.log('this.recordtypeList22222222222222222222222222222222',JSON.stringify(this.recordtypeList));
          getAccountHighlightPanel({recordId:this.recordId})
        .then(result =>{
            console.log('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@',result);
            var res=result;
            this.hightlighpanelList=res;
            console.log('HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHuuuuuuuuuuuuuuuuuuuuuuuuuuuuu',JSON.stringify(this.hightlighpanelList));
            console.log('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&',this.hightlighpanelList.length);
             getCustomerDetails({recordId:this.recordId})
          .then(result=>{
            console.log('MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM',result);
            var res=result;
            this.metarec=res;
          })
            //isLoaded=true;
        })
     }
}