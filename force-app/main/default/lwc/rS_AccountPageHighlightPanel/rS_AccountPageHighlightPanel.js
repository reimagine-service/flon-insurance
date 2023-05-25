import { LightningElement,track,api } from 'lwc';
import getAccountHighlightPanel from '@salesforce/apex/RS_CustomerDetailsController.getAccountHighlightPanel';
export default class RS_AccountPageHighlightPanel extends LightningElement {
      @api recordId;
      @api objectName;
      @api fields=[];
      @api accountName;
      @api pageTitle;
      @api code;
      @api badgeslabel;
      @api fieldSet;

      // connectedCallback() {

      //     var badge=this.template.querySelector(".slds-badge_inverse");
      //       console.log('badge ****');
      //       badge.style="background-color:"+this.code;

      //       console.log('badge',badge);



      // }
}