import { LightningElement, wire, api,track } from 'lwc';
import getAggregateRecordsByAccountId from '@salesforce/apex/RS_CustomerProfileChartController.getAggregateRecordsByAccountId'; 
export default class RS_CustomerProfileRelatedList extends LightningElement {
    @track chartConfiguration;
    @api recordId;
    //@api strTabInformation;
    inputParam;
    @track displayGraphData = false;

    @api set strTabInformation(value){
        this.inputParam = value;
        this.connectedCallback();
    }
    get strTabInformation(){
        return this.inputParam;
    }
   
connectedCallback() {
     //console.log('tablabel RS_CustomerProfileRelatedList', this.inputParam, this.recordId);
     this.displaygraph(this.recordId,this.inputParam);
}

displaygraph(recordId,inputParam){
    
    //console.log('recordId : ' + this.recordId);
     getAggregateRecordsByAccountId({accountId:this.recordId, tabDetails: inputParam})
              .then(data => {
        //console.log('getAggregateRecordsByAccountId data ::' , data.length);
        //console.log('strTabInformation ', this.strTabInformation);
        // if (error) {
        //     console.log('innside error');
        //     this.error = error;
        //     this.chartConfiguration = undefined;
        // } else if (data) {
            //console.log('data getAggregateRecordsByAccountId ' , data);
            let chartAmtData = [];
            let chartRevData = [];
            let chartLabel = [];
            let newdt;
            
            if(data.length > 0){
                this.displayGraphData = true;
                //console.log('@@@@@@@@@@@@@@@@@@@@@@');
                 data.forEach(obj => {
                //chartAmtData.push(obj.CRDATE);
                //console.log('obj' , obj);
                chartRevData.push(obj.Total);
                if (obj.CRDATE) {
                    let dt = new Date(obj.CRDATE);
                    const options = {year:'numeric',month:'short',day:'numeric'};                 
                    newdt = new Intl.DateTimeFormat('en-GB',options).format( dt ); 
                }
                chartLabel.push(newdt);
            });
 
            this.chartConfiguration = {
                type: 'bar',
                data: {
                    datasets: [/*{
                            label: 'Amount',
                            backgroundColor: "green",
                            data: chartAmtData,
                        },*/
                        {
                            label: 'Total Records',
                            //backgroundColor: "orange",
                            backgroundColor: 'rgba(0,255,255,0.6)',
                            data: chartRevData,
                        },
                    ],
                    labels: chartLabel,
                },
                options: {
                     responsive: true,
                    maintainAspectRatio: false,
                    legend: {
                            display: false
                        },
                    scales: {
                            yAxes: [{
                                display: true,
                                stacked: true,
                                ticks: {
                                    min: 0, // minimum value
                                    //mintitle: "Negative",
                                    //max:  4, // maximum value
                                    //maxtitle: "Positive",
                                    stepSize: 10
                                },
                                scaleLabel: {
                                    display: true,
                                    labelString: 'Total Records',
                                    fontStyle: "bold",
                                    fontSize: 13
                                }
                            }],
                            xAxes: [{
                                display: true,
                                stacked: true,
                                scaleLabel: {
                                    display: true,
                                    labelString: 'Created Date',
                                    fontStyle: "bold",
                                    fontSize: 13
                                }
                            }]
                        }
                },
            };
            console.log('data => ', data);
            this.error = undefined;
            }else{
                this.displayGraphData = false;
            }
           
       // }
    })
}
}