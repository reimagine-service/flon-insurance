import { LightningElement ,api,track} from 'lwc';
import getKnowledgeArticles from '@salesforce/apex/RS_CustomerPortalController.getKnowledgeArticles';
//import Id from '@salesforce/user/Id';
import getSuggestedKnowledgeArticles from '@salesforce/apex/RS_CustomerPortalController.getSuggestedKnowledgeArticles';
export default class RSI_CustomerPortalLWC extends LightningElement {
  @api records=[]; 
  @api selectedRecords=[]; 
  @api selectedchoice=[];
   @api selectedchoiceSugg;
   @track selectedrecord;
   // userId = Id;

     connectedCallback() {   
         console.log('333');
       getKnowledgeArticles()
        .then(result =>{
            console.log('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@',result);
            this.records=result;
            var res=result;
        });
       
    }
     activeSectionMessage = '';

    handleToggleSection(event) {
        //this.selectedchoice = '';
        this.activeSectionMessage =
            'Open section name:  ' + event.detail.openSections;
        var actioname=JSON.parse(JSON.stringify( event.detail.openSections));
        this.selectedchoice=actioname;
        console.log('this.selectedchoice',typeof (this.selectedchoice));
    
    if(this.selectedchoice !=null && this.selectedchoice != '' && this.selectedchoice != undefined){
        console.log('+++++++++++++++++++++++++++++++',this.selectedchoice);
        getSuggestedKnowledgeArticles({selectChoice:this.selectedchoice})
            .then(selectedresult =>{
                this.selectedRecords=selectedresult;
                //this.res=this.inputParam;
            });
        }
    }

    handleToggleSectionSelected(event) {
        this.selectedchoiceSugg = '';
        this.activeSectionMessage =
            'Open section name:  ' + event.detail.openSections;
        console.log('0000000000000000000000000000000000',event.detail.openSections);
        this.selectedchoiceSugg=event.detail.openSections;
        console.log('this.selectedchoiceSugg',this.selectedchoiceSugg);
    }
}