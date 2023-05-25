import { LightningElement,api,track } from 'lwc';
import fetchAppointments from '@salesforce/apex/RS_DynamicRelatedListController.getWrapperOfSObjectFieldColumnActionValues';
export default class RS_DynamicRelatedListLWC extends LightningElement {
@api recordId;
@track DataTableResponseWrappper = [];
@track finalSObjectDataList;
@track errorAppData;
@api tabLabel;
@api tabHeading;
   // JS Properties 
pageSizeOptions = 5;
@track columns; //holds column info. //columns information available in the data table
    totalRecords = 0; //Total no.of records
    pageSize; //No.of records to be displayed per page
    totalPages; //Total no.of pages
    pageNumber = 1; //Page number    
    recordsToDisplay = []; //Records to be displayed on the page
    
get bDisableFirst() {
        return this.pageNumber == 1;
    }

get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }

connectedCallback() {
      console.log('#####recordId : ', this.recordId);
      fetchAppointments({tableName:this.tabLabel, recordId:this.recordId})
      .then(data =>{
         if (data != null) {
            
       let sObjectRelatedFieldListValues = [];
            console.log('datat dynamic table ' , data );
             console.log('result*ddd** ', JSON.stringify(data));
           for (let row of data.lstDataTableData) 
           {
               console.log('row****** ' + JSON.stringify(row));
                const finalSobjectRow = {}
                let rowIndexes = Object.keys(row); 
                rowIndexes.forEach((rowIndex) => 
                {
                    const relatedFieldValue = row[rowIndex];
                    if(relatedFieldValue.constructor === Object)
                    {
                        this._flattenTransformation(relatedFieldValue, finalSobjectRow, rowIndex)        
                    }
                    else
                    {
                        finalSobjectRow[rowIndex] = relatedFieldValue;
                    }
                    
                });
                sObjectRelatedFieldListValues.push(finalSobjectRow);
            }
            this.columns = data.lstDataTableColumns;
             
                    
            console.log('@@@@@@@@@@@columns', JSON.stringify(this.DataTableResponseWrappper));
            this.finalSObjectDataList = sObjectRelatedFieldListValues;
            console.log('@@@@@@@@@@@finalList', JSON.stringify(this.finalSObjectDataList));
                    this.totalRecords =  this.finalSObjectDataList.length; // update total records count                 
                    this.pageSize = this.pageSizeOptions;
                    this.paginationHelper(); // call helper menthod to update pagination logic 
                     this.DataTableResponseWrappper = [...this.columns].filter(col => col.label != 'CaseNo');
      }
      })
      .catch(error =>{
        this.errorAppData = error;
      })
    }

      previousPage() {
        this.pageNumber = this.pageNumber - 1;
        this.paginationHelper();
    }

    nextPage() {
        this.pageNumber = this.pageNumber + 1;
        this.paginationHelper();
    }
       // JS function to handel pagination logic 
    paginationHelper() {
        this.recordsToDisplay = [];
        // calculate total pages
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        // set page number 
        if (this.pageNumber <= 1) {
            this.pageNumber = 1;
        } else if (this.pageNumber >= this.totalPages) {
            this.pageNumber = this.totalPages;
        }

        // set records to display on current page 
        for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
            if (i === this.totalRecords) {
                break;
            }
            this.recordsToDisplay.push(this.finalSObjectDataList[i]);
        }
    }

    _flattenTransformation = (fieldValue, finalSobjectRow, fieldName) => 
    {        
        let rowIndexes = Object.keys(fieldValue);
        rowIndexes.forEach((key) => 
        {
            let finalKey = fieldName + '.'+ key;
            finalSobjectRow[finalKey] = fieldValue[key];
        })
    }


}