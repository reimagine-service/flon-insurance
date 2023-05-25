import { LightningElement , track,api} from 'lwc';
import startLabel from '@salesforce/label/c.rs_TabConfigurationStartNode';

export default class RS_customerSnapshotTab extends LightningElement {
    
    @track clevel;
    @track cparent;
    @track sublevel;
    @track dataTableParam;
    @api tabLabel;
    //label = {startLabel};
    isLoaded = false;
    loadDatatable = false;
    @api recordId;

    connectedCallback(){
        this.clevel = 1;
        console.log('in cc');
        this.cparent=startLabel;
        console.log(this.clevel,startLabel,this.cparent, this.tabLabel);
        this.sublevel =this.clevel+1;
        this.isLoaded = true;
    }
    selectedTabHandler(event){
        console.log('in selectedTabHandler ' , event);
        let z = event.detail;
        this.cparent = z.label;
        this.dataTableParam = z.label;
        //this.sublevel =parseInt(z.level)+1;
        console.log('in tab handler: ',JSON.stringify(z));
        this.loadDatatable = true;
    }



}