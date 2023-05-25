import { LightningElement, track ,api} from 'lwc';
import { loadStyle } from "lightning/platformResourceLoader";
import WrappedHeaderTable from "@salesforce/resourceUrl/WrappedHeaderTable";
import getBTTCmetaDetail from '@salesforce/apex/RS_BestTimeToCallController.getBTTCmetaDetail';
import getPicklistValuesForMonth from "@salesforce/apex/RS_BestTimeToCallController.getPicklistValuesForMonth";
import getPicklistValuesForIssueType from "@salesforce/apex/RS_BestTimeToCallController.getPicklistValuesForIssueType";
import getDynamicTableDataList from '@salesforce/apex/RS_BestTimeToCallController.getWrapperOfSObjectFieldColumnActionValues';
export default class rS_BestTimeToCall extends LightningElement {
@track value='';
@track value1='Billing';
@api recordId;
@api details = [];
@api Metadetails = [];
@track boolvar=false;
@track sortedDetails=[];
@track finalSObjectDataList;
@track picklistOptions= [];
@track picklistOptionsList=[];
@track optionslist=[];
@track picklistOptionsListPass=[];
@track options=[];
@track dataToRefresh=[];
@track dataresult=[];
@track DataTableResponseWrappper = [];

 
 
connectedCallback() {
   console.log('11111111111',this.value1);
   console.log('2222222222222',this.value);
   if (!this.stylesLoaded) {
    Promise.all([loadStyle(this, WrappedHeaderTable)])
        .then(() => {
            console.log("Custom styles loaded");
            this.stylesLoaded = true;
        })
        .catch((error) => {
            console.error("Error loading custom styles");
        });
}
  
   var date = new Date();
   const monthNames = ["January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December"];

   const d = new Date();
   var current_date = monthNames[d.getMonth()];
   console.log('this.value',this.value);
   console.log('this.value',this.value.length);
   if(!this.value.length){
                  console.log('inside curretn date');
                  this.value=current_date;
                }
   

    getPicklistValuesForMonth()
        .then(r =>{
           console.log('@@@@@@@@@@@@resultmonth',JSON.stringify(r));
           for(var key in r){
                  this.options.push({ label: r[key], value: r[key] });
                }      console.log('****options',this.options);
           this.picklistOptions = this.options;
           console.log('****picklistoptions',JSON.stringify(this.picklistOptions));
              getPicklistValuesForIssueType()
        .then(optionList =>{
          console.log('@@@@@@@@@@@@resultissuetype',JSON.stringify(optionList));
           for(var i in optionList){
                  this.picklistOptionsListPass.push({ label: optionList[i], value: optionList[i] });
                }
           this.picklistOptionsList= this.picklistOptionsListPass;
           console.log('****picklistOptionsList',JSON.stringify(this.picklistOptionsList));
        })
        if(this.picklistOptions != null && this.picklistOptionsList != null){
          console.log('current_date',current_date);
          console.log('current_date value',this.value);
          getBTTCmetaDetail()
                .then(data1 =>{
                  console.log('result data---->  ', JSON.stringify(data1));
                  this.dataresult=data1;
                  console.log('3333333333333333333333333333333333333333333333333333333333333',JSON.stringify(this.dataresult));  
                  //this.Metadetails = data1;
            if(this.value!='' && this.value1!=''){
                console.log('3333333333333333333333333333333333333333333333333333333333333');  
                this.fetchDisplay(data1);
            }
            });
            
         }

 })
}


sorter = {
  // "sunday": 0, // << if sunday is first day of week
  "monday": 1,
  "tuesday": 2,
  "wednesday": 3,
  "thursday": 4,
  "friday": 5,
  "saturday": 6,
  "sunday": 7
}
  handleChange(event) {
        this.value = event.detail.value;
        console.log('handleChange',event.detail.value);
        if(this.value1!=''){
         this.fetchDisplay();
        }
     }
  handleIssueTypeChange(event) {
        this.value1 = event.detail.value;
        console.log('handleIssueTypeChange',event.detail.value);
        if(this.value.length){
          console.log('inside if');
        this.fetchDisplay();
        }
     }

  

  fetchDisplay(data1){
    console.log('inside fetchDisplay');
    console.log('result data---->  ', JSON.stringify(this.dataresult));
     console.log('3333333333333333333333333333333333333333333333333333333333333',JSON.stringify(this.dataresult));
       this.sortedDetails = [];
       var Afternoon_Label;
       var Morning_Label;
       var Evening_Label;
       
        
        getDynamicTableDataList({tableName: 'BTTC_List',accountId : this.recordId,issueType:this.value1,month:this.value})
        .then(r =>{
            console.log('result*** ', JSON.stringify(r));

              let sObjectRelatedFieldListValues = [];
            console.log('******table length',r.lstDataTableData.length);
            
           for (let row of r.lstDataTableData) 
           {
                const finalSobjectRow = {}
                let rowIndexes = Object.keys(row); 
                rowIndexes.forEach((rowIndex) => 
                {
                   
                    const relatedFieldValue = row[rowIndex];
                 
                    if(relatedFieldValue.constructor === Object)
                    {
                        this.getTableDetails(relatedFieldValue, finalSobjectRow, rowIndex) 
                    }
                    else
                    {
                       finalSobjectRow[rowIndex] = relatedFieldValue;                   
                      
                    }
                    
                });
                sObjectRelatedFieldListValues.push(finalSobjectRow);
                
            }
          this.DataTableResponseWrappper = r.lstDataTableColumns;
          this.finalSObjectDataList = sObjectRelatedFieldListValues;
          console.log('@@@@@@@@@@@data table length',JSON.stringify(data1));
            console.log('@@@@@@@@@@@finalSObjectDataList', JSON.stringify(sObjectRelatedFieldListValues));
           for(let j in this.dataresult){
            
            this.Metadetails[j] = this.dataresult[j];
            console.log('metadata value in fetch ==', this.Metadetails[j].Value_2__c);
           
          

               for (let i = 0; i < this.finalSObjectDataList.length; i++) {
                this.details[i] = this.finalSObjectDataList[i];
                console.log('karan data inside loop', JSON.stringify(this.details[i].Afternoon__c));
                if(this.details[i].Afternoon__c >= this.Metadetails[j].Value_1__c && this.details[i].Afternoon__c <= this.Metadetails[j].Value_2__c){
                  Afternoon_Label =  this.Metadetails[j].Result__c;
                  this.details[i].Afternoon__c = Afternoon_Label;
                  console.log('updated afternoon data inside loop==', Afternoon_Label);
                }
                
                if(this.details[i].Morning__c >= this.Metadetails[j].Value_1__c && this.details[i].Morning__c <= this.Metadetails[j].Value_2__c){
                  Morning_Label = this.Metadetails[j].Result__c;
                  this.details[i].Morning__c = Morning_Label;
                  console.log('updated morning data inside loop==', Morning_Label);
                }
                if(this.details[i].Evening__c >= this.Metadetails[j].Value_1__c && this.details[i].Evening__c <= this.Metadetails[j].Value_2__c){
                  Evening_Label = this.Metadetails[j].Result__c;
                  this.details[i].Evening__c = Evening_Label;
                  console.log('updated evening data inside loop==', Evening_Label);
                }
                
                
              }
            }
          
           

            console.log('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA',JSON.stringify(this.details));
            
            const sorter = {
              Monday: 1,
              Tuesday : 2,
              Wednesday : 3,
              Thursday: 4,
              Friday: 5,
              Saturday: 6,
              Sunday: 7
            };

            const newList = {
              "1": "Monday" ,
              "2": "Tuesday",
              "3":  "Wednesday",
              "4": "Thursday",
              "5": "Friday",
              "6": "Saturday",
              "7": "Sunday"
            };
          
                  
            this.details.sort(function sortByDay(a, b) {
              for(var k in newList){    
                 if (newList[k] === a.DayOfWeek__c) {
                    return sorter[a.DayOfWeek__c] - sorter[b.DayOfWeek__c];                 
                }
               }
          });          
          console.log('data ' , JSON.stringify(this.details));
          this.sortedDetails = this.details;
        })
        
     }

         getTableDetails(fieldValue, finalSobjectRow, fieldName){
        let rowIndexes = Object.keys(fieldValue);
        rowIndexes.forEach((key) => 
        {
            console.log('key getTableDetails ' , key);
            let finalKey = fieldName + '.'+ key;
            console.log('getTableDetails ' , finalKey);
            if(fieldValue["RelatedRecord.Id"] != undefined && fieldValue["RelatedRecord.Id"] != null){
                fieldValue["RelatedRecordId"] = fieldValue["RelatedRecord.Name"];
            }
            finalSobjectRow[finalKey] = fieldValue[key];
            console.log('finalSobjectRow[finalKey]  ' , finalSobjectRow[finalKey] );

        })
    }
    
}