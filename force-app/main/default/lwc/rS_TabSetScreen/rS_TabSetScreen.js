import { api, LightningElement, track } from 'lwc';
import fetchTabs from '@salesforce/apex/RS_DynamicTabSet.fetchTabs';

export default class rS_TabSetScreen extends LightningElement {


    @api level;
    @api parent;
    @track tabs=[];
    @track subTabs =[];
    @track fetchLevel;
    @track isTabs = false;
    @track isSubTabs = false; 
    //isRendered = false;

    connectedCallback(){
        
        //if(this.isRendered === false){
        console.log('****');
        console.log('level : ',this.level, this.parent);
        this.handleTabs(this.parent, false); // C1: Case , Interaction, C2: SMS, VoiceCall, Email
        //}

    }

    handleTabs(y, n){
        console.log('handleTAbs ',y);
        fetchTabs({ recordName : y})
        .then(result =>{
            let resultList = result;
            let tabList =[]
            resultList.forEach(element => {
                let temp ={}
                let label = element.MasterLabel;
                 temp.TabName = (label.includes(":")) ? label.split(":")[1] : label;
                 console.log(' temp.TabName ' ,  temp.TabName);
                 temp.TabName = (temp.TabName.includes("_")) ? temp.TabName.replace('_', ' ') : temp.TabName;
                 temp.Name = element.MasterLabel;
                 temp.Order = element.Order__c;
                 this.fetchLevel = element.Order__c;
                temp.ChildType = element.Child_ComponentType__c;
                tabList.push(temp);              
            });
            console.log('n', n);
            if(n === false){
            this.tabs = tabList;
            this.isTabs = true;
            }
            else{
                this.subTabs = tabList;
                this.isSubTabs = true;
            }
            console.log('tabs ', JSON.stringify(this.tabs));
            console.log('subtabs', JSON.stringify(this.subTabs));
            //this.isRendered = true;
        })
        .catch(error =>{
            console.log(JSON.stringify(error));
        })
    }
    
    handleActive(event){         
        var evtName = event.target.id;
        var z = evtName.split('-')[0];
        //console.log('evtName ID *** ' , evtName);
        //console.log('event ********', z);
        this.handleTabs(z,true );
    }


    handleActiveSubtab(event){
        var evtName = event.target.id;
        console.log('evtName ** ' , evtName);
        var z = evtName.split('-')[0];
        
        console.log('evtName ID *** ' , evtName);
        console.log('event ********', z);
        
        //console.log('z', z, this.level);        
        const ev = new CustomEvent(
            'selectedtab',{
                detail: {label:z}
            }
        );
        this.dispatchEvent(ev);
    }
}