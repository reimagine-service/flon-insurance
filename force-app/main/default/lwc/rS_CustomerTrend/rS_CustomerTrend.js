import { LightningElement, wire, api} from 'lwc';
import getSentimentsById from '@salesforce/apex/RS_trendChartcontroller.getSentimentsById';
 
export default class RS_CustomerTrend extends LightningElement {
    chartConfiguration;
    @api recordId;
    @wire(getSentimentsById, {caseId: '$recordId'})
    getSentimentsById({ error, data }) {
        if (error) {
            this.error = error;
            this.chartConfiguration = undefined;
        } 
        else if (data) {
            let chartSentiData = [];
            let chartLabel = [];
            let chartCustomerSentiment = [];
            let chartConversationChannel = [];
            let newdt;
            data.forEach(senti => {
                chartSentiData.push(senti.Sentiment_Value__c);
                 if (senti.LastModifiedDate) {
                    let dt = new Date(senti.LastModifiedDate);
                    const options = {year:'numeric',month:'short',day:'numeric'};                 
                    newdt = new Intl.DateTimeFormat('en-GB',options).format( dt ); 
                }
                chartLabel.push(senti.Conversation_Channel__c+':'+'\n'+newdt);
                //chartLabel.push(newdt);
                chartCustomerSentiment.push(senti.Customer_Sentiments__c);
                chartConversationChannel.push(senti.Conversation_Channel__c);
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
                       /*animations: {
                                        tension: {
                                            duration: 100,
                                            easing: 'linear',
                                            from: 1,
                                            to: 0,
                                            loop: true
                                        }
                                    },*/
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
        }
    }
}