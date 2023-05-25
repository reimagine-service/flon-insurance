import { LightningElement,track,api} from 'lwc';
import getAccountHighlightPanel from '@salesforce/apex/RS_CustomerDetailsController.getAccountHighlightPanel';
export default class RS_CustomerDetails extends LightningElement {

      @api recordId;
      @api objectName;
      @api fields=[];
      @api pageTitle;
      @track fieldSet;
      @api keyVariable;
      @track isLoaded = false;
      @track isKeyVaraible=false;
      @api horizontalAlign = 'space';
      @track hightlighpanelList;
      connectedCallback() {
            this.fieldSet=this.fields.split(',');
            console.log('this.fieldSet',this.fieldSet);
            if(this.keyVariable==1){
            this.isKeyVaraible=true;
            }
            this.isLoaded=true;
            getAccountHighlightPanel({recordId:this.recordId})
        .then(result =>{
            console.log('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@',result);
            var res=result;
            this.hightlighpanelList=res;
            console.log('HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH',JSON.stringify(this.hightlighpanelList));
            console.log('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&',this.hightlighpanelList.length);
        });
      }
}