import { LightningElement, api } from 'lwc';
import chartjs from '@salesforce/resourceUrl/ChartJs';
import { loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
 
export default class Chartjssentiment extends LightningElement {
    @api chartConfig;
   
    isChartJsInitialized;

     connectedCallback() {
        console.log('ahgdajdgjagdjagsdagd sentiment');
        this.displayChart();
    }

    displayChart() {
        //console.log('1111111111' ,JSON.stringify(this.chartConfig) );
        if (this.isChartJsInitialized) {
            return;
        }
        // load chartjs from the static resource
        Promise.all([loadScript(this, chartjs)])
            .then(() => {
                console.log('chartjs ' , chartjs);
                this.isChartJsInitialized = true;
                //const ctx = this.template.querySelector('canvas.barChart').getContext('2d');
                const ctx = this.template.querySelector('canvas.barChart').getContext('2d');               
                    this.chart = new window.Chart(ctx, JSON.parse(JSON.stringify(this.chartConfig)));                               
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error loading Chart',
                        message: error.message,
                        variant: 'error',
                    })
                );
            });
    }
}