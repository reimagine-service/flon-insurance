import { LightningElement, wire, api} from 'lwc';
import getSentimentsByIdForAccount from '@salesforce/apex/RS_trendChartcontroller.getSentimentsByIdForAccount';
//import getAggregateRecordsByAccountId from '@salesforce/apex/RS_CustomerProfileChartController.getAggregateRecordsByAccountId';
 
export default class RS_CustomerSentimentTrend extends LightningElement {
    chartConfiguration;
    @api chartConfig;
    @api componentHeight;
    @api recordId;
    @api tabInformation = 'Sentiment Score List'; 
   
    connectedCallback(){
         console.log('sentiment yrend ***connectedCallback********' , this.recordId);
        this.getSentimentsByIdForAccount(this.recordId, this.tabInformation);
   }   
   
   // @wire(getAggregateRecordsByAccountId, { accId: '$recordId', tabDetails: 'Sentiment_Score_List'})
   
    getSentimentsByIdForAccount(recordId, tabDetails) {
        console.log('sentiment yrend ***********' , recordId);
        getSentimentsByIdForAccount({accountId: recordId,tabDetails: tabDetails})
        .then(data => {
       
            console.log('data sentiment sentiment' , data);
            let chartSentiData = [];
            let chartLabel = [];
            let chartCustomerSentiment = [];
            let chartConversationChannel = [];
            let newdt;
            data.forEach(senti => {
                console.log('senti' , senti);
                chartSentiData.push(senti.Sentiment_Value__c);
                 if (senti.LastModifiedDate) {
                    let dt = new Date(senti.LastModifiedDate);
                    const options = {year:'numeric',month:'short',day:'numeric'};                 
                    newdt = new Intl.DateTimeFormat('en-GB',options).format( dt ); 
                }
                  var caseType= senti.Case__r.Type;
                  if(caseType == 'Maintenance Inquiry'){
                      console.log('caseType' , caseType);
                       caseType = caseType.replace('Maintenance Inquiry','Maintenance');
                       console.log('caseType  111111' , caseType);
                  }   
                  if(caseType == 'Account Information Update'){
                      console.log('caseType' , caseType);
                       caseType = caseType.replace('Account Information Update','Account Info');
                       console.log('caseType  111111' , caseType);
                  }      
                
                const a = [caseType,newdt];
                chartLabel.push(a);
                //chartLabel.push(senti.Case__r.Type+"\r\n"+newdt);
                chartCustomerSentiment.push(senti.Customer_Sentiments__c);
                chartConversationChannel.push(senti.Case__r.Type);
            });
 
            this.chartConfiguration = {
                 type: 'bar',
                    data: {
                        datasets: [{
                            label: 'Probability Score',
                            data: chartSentiData,
                            borderColor: 'rgb(255, 99, 132)',
                            backgroundColor: 'rgba(192,250,255,0.5)',//'rgba(255, 99, 132,0.2)',
                            order: 2
                        }, {
                            label: 'Probability Score',
                            data: chartSentiData,
                            type: 'line',
                            borderColor: 'rgb(54, 162, 235)',
                            order: 1
                        }],
                        labels:chartLabel,
                    },
                    options: {
                        legend: {
                            display: false
                        },
                        tooltips: {
                            enabled: true,
                        },
                        scales: {
                            yAxes: [{
                                display: true,
                                stacked: true,
                                ticks: {
                                    min: -1, // minimum value
                                    max:  1, // maximum value
                                    stepSize: 1
                                },
                                scaleLabel: {
                                    display: true,
                                    labelString: 'Sentiment score',
                                    fontStyle: "bold",
                                    fontSize: 13
                                }
                            }],
                            xAxes: [{
                                display: true,
                                stacked: true,
                                scaleLabel: {
                                    display: true,
                                    labelString: 'Interaction',
                                    fontStyle: "bold",
                                    fontSize: 13
                                }
                            }]
                        },
                        tooltips: {
                                        callbacks: {
                                                label: function(tooltipItem) {
                                                    return "$ and so worth it !";
                                                }
                                        }
                        }
                    },
            };
            console.log('data => ', data);
            this.error = undefined;
        })
    }
}