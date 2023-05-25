import { LightningElement, track, wire,api } from 'lwc';
import getDynamicTableDataList from '@salesforce/apex/RS_DynamicLWCDataTableController.GetWrapperOfSObjectFieldColumnActionValues';


export default class RS_Dynamic_DataTable extends LightningElement {
    @track DataTableResponseWrappper;
    @track finalSObjectDataList =[];
    @track displayTable = false;
    @api recordId;
    inputParam;
    @track page = 1; //this will initialize 1st page
    @track items = []; //it contains all the records.
    @track data = []; //data to be displayed in the table
    @track columns; //holds column info.
    @track startingRecord = 1; //start record position per page
    @track endingRecord = 0; //end record position per page
    @track pageSize = 5; //default value we are assigning
    @track totalRecountCount = 0; //total record count received from all retrieved records
    @track totalPage = 0; //total number of page is needed to display all records
    sfdcBaseURL;
    @track showNavbuttonPrev = true;
    @track showNavbuttonNext = true;
    

    @api set tablabel(value){        
        this.inputParam = value;
        this.startingRecord = 1;
        this.endingRecord = 0;
        this.totalRecountCount = 0;
        this.page = 1;
        this.totalPage = 0;
        this.connectedCallback();
    }
    get tablabel(){
        return this.inputParam;
    }
    connectedCallback() {   
        //this.recordId = currentPageReference.state.recordId;
        console.log('iside connected callback datatatble input param ' , this.inputParam);
        console.log('iside connected callback datatatble recordid ' , this.recordId);
        this.displayDatatable(this.inputParam,this.recordId);
        this.displayRecordPerPage(this.page);   
    }

    displayDatatable(inputParam,recordId){
       getDynamicTableDataList({label:inputParam,recordId:this.recordId})
        .then(data => {
          
            let sObjectRelatedFieldListValues = [];
            console.log('datat dynamic table ' , data );
            
           for (let row of data.lstDataTableData) 
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
            this.columns = data.lstDataTableColumns;
            console.log('sObjectRelatedFieldListValues  ***** ', JSON.stringify(sObjectRelatedFieldListValues));
            this.items = sObjectRelatedFieldListValues;
            this.totalRecountCount = Object.keys(sObjectRelatedFieldListValues).length; 
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); 
            
            //initial data to be displayed ----------->
            //slice will take 0th element and ends with 5, but it doesn't include 5th element
            //so 0 to 4th rows will be displayed in the table
            this.finalSObjectDataList = this.items.slice(0,this.pageSize); 
            //this.endingRecord = this.pageSize;

            if(this.totalRecountCount >= 5){
                this.endingRecord = this.pageSize;
            }else{
                this.endingRecord = this.totalRecountCount;
            }
       
       

            //this.columns = this.DataTableResponseWrappper.lstDataTableColumns;
            if(data.lstDataTableData.length > 0){
                this.displayTable = true;
            }else{
                this.displayTable = false;
            }
            
       
             if(this.totalPage == 1){
                 
                this.showNavbuttonNext = false;
                this.showNavbuttonPrev = false;
            }else if(this.totalPage > 1){
                
                this.showNavbuttonNext = true;
                this.showNavbuttonPrev = false;
                
            }
            //     if(this.page >= 2){
            //         this.showNavbuttonPrev = true;
            //     }                
            // }else if(this.page == this.totalPage){
            //     this.showNavbuttonNext = false;
            //     this.showNavbuttonPrev = true;
            // }
            //   console.log('data.lstDataTableColumns @@@@@@@@@2' , (this.columns.fieldName));
            //   for (let x of this.columns) {
            //       console.log('x &&&&&&&&& ' , JSON.stringify(x)  );
            //       x["fieldName"] = "S.No";
            //       Object.preventExtensions(x);
            //   }
            // [...this.columns]['fieldName'] = "S.No";
            // [...this.columns]['label'] = "S.No";
            // [...this.columns]['type'] = Number;
            // [...this.columns]['typeAttributes'] = '';
            
            //Object.preventExtensions(this.columns);
           
            
           // return every column but the one you want to hide
            this.DataTableResponseWrappper = [...this.columns].filter(col => col.label != 'CaseNo');
                    
            
               
        })
        // .catch(error =>{
        //     console.log('error', JSON.stringify(error));
        // })
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

   
     //clicking on previous button this method will be called
    previousHandler() {       
        if (this.page > 1) {            
            this.showNavbuttonPrev = true;
            this.showNavbuttonNext = true;
            this.page = this.page - 1; //decrease page by 1
            this.displayRecordPerPage(this.page);
        } else if(this.page == 1){
            this.showNavbuttonPrev = false;
        } 
        
    }

    //clicking on next button this method will be called
    nextHandler() {
        if((this.page<this.totalPage) && this.page !== this.totalPage){
            this.showNavbuttonNext = true;
            this.showNavbuttonPrev = true;
            this.page = this.page + 1; //increase page by 1
            this.displayRecordPerPage(this.page);            
        } else{
            this.showNavbuttonNext = false;
        }
        
         
    }

     //this method displays records page by page
    displayRecordPerPage(page){

        /*let's say for 2nd page, it will be => "Displaying 6 to 10 of 23 records. Page 2 of 5"
        page = 2; pageSize = 5; startingRecord = 5, endingRecord = 10
        so, slice(5,10) will give 5th to 9th records.
        */
        this.startingRecord = ((page -1) * this.pageSize) ;
        this.endingRecord = (this.pageSize * page);

        this.endingRecord = (this.endingRecord > this.totalRecountCount) 
                            ? this.totalRecountCount : this.endingRecord; 

        this.finalSObjectDataList = this.items.slice(this.startingRecord, this.endingRecord);

        //increment by 1 to display the startingRecord count, 
        //so for 2nd page, it will show "Displaying 6 to 10 of 23 records. Page 2 of 5"
        this.startingRecord = this.startingRecord + 1;
    }
}