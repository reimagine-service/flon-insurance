import { LightningElement ,wire,api,track} from 'lwc';
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import Id from "@salesforce/user/Id";
/*import CONTACT_ID from "@salesforce/schema/User.ContactId";*/
import getInsuranceAgentDetailsJS from '@salesforce/apex/RS_InsuranceDetailsPortalView.getInsuranceAgentDetails';
export default class Rsi_insuranceAgentDetailsOnPortal extends LightningElement {
@api currentUserId;
userId = Id;
@api userdetails=[];
@track name;
// @wire(getRecord, { recordId: USER_ID })
//   user;

// get contactId() {
//     return getFieldValue(this.user.data, CONTACT_ID);
//   }
connectedCallback() {   
    console.log('user **** ' ,this.userId);
    
      // getInsuranceAgentDetailsJS({userId:this.userId})
       getInsuranceAgentDetailsJS({userId:this.userId})
        .then(result =>{
            console.log('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@',result);
           // this.records=result;
          this.userdetails=result;
          this.name=result.Name;
          console.log(' this.name', this.name);
           console.log('result',this.userdetails);
            var res=result;
        });
       
    }
}