import { LightningElement,api,track } from 'lwc';
import getJsonData from '@salesforce/apex/RS_ChatTranscriptAPI.jsonToLWC';

export default class Rs_JSONINLWC extends LightningElement {

    @api recordId;
    @track jsonData = [];
    @track mapData = [];
    datalist = [];
    @track visibility;
    @track visibilityMsg;


     connectedCallback() {   
        this.displayTextFileData(this.recordId);   
    }

    displayTextFileData(recordId){
         getJsonData({caseId:recordId})
        .then(data => {
             this.jsonData = data;      
             var count = 0;    
             for (let row of this.jsonData) {
                 console.log('row.userMessage ' , row.userMessage);
                 row.key = count++;
                 if(row.userMessage == '' || row.userMessage == undefined || row.userMessage == 'welcome' ){
                     console.log('111111111');                     
                     row.visibilityMsg = 'display: none';
                     
                 }
                 else{
                     row.visibilityMsg = 'visibility: visible';
                 }

                 if( row.botResponse == '' || row.botResponse == undefined){
                     console.log('111111111');                     
                     row.visibility = 'display: none';
                     
                 }
                 else{
                     row.visibility = 'visibility: visible';
                 }

                this.datalist.push(row);
              }                         
             this.mapData = this.datalist;
             console.log('this.mapData ' , JSON.stringify(this.mapData));


          
            // let temp = [];
            // this.mapDataNew.forEach( (value,key,data) => {
            //     console.log('data ##### ' +  data);
            //      temp.push({"userMessage":key,"botResponse": value})

            // });
            //  console.log('*******' + JSON.stringify(temp) );
            //  this.mapData = temp;
            //  console.log('1111111' + this.mapData );
        })
    }
}