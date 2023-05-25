import { LightningElement, api } from 'lwc';
import chartjs from '@salesforce/resourceUrl/ChartJs';
import { loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
 
export default class ChartJsTrendAccountSenti extends LightningElement {
   
     @api componentHeight;
    @api set chartConfigSenti(value){
         console.log('chartConfig Chartjssentiment ' , JSON.stringify(value));
        this.inputParam = value;
        this.connectedCallback();
    }
    get chartConfigSenti(){
        return this.inputParam;
    }
    
    get style() {
        return this.componentHeight;
    }

    set style(value) {
        this.componentHeight = value;
        this.setAttribute('style', "height: " + this.componentHeight);
    }    
 
    isChartJsInitialized;

    connectedCallback() {
        console.log('ahgdajdgjagdjagsdagd sentiment');
        this.displayChart();
    }

    displayChart() {
        console.log('1111111111 chartConfig chartConfig' ,JSON.stringify(this.chartConfigSenti) );
        if (this.isChartJsInitialized) {
            return;
        }
        // load chartjs from the static resource
        Promise.all([loadScript(this, chartjs)])
            .then(() => {
                console.log('chartjs displayChart' , chartjs);
                this.isChartJsInitialized = true;
                //const ctx = this.template.querySelector('canvas.barChart').getContext('2d');
                const ctx = this.template.querySelector('canvas.barChart').getContext('2d');
                this.chart = new window.Chart(ctx, JSON.parse(JSON.stringify(this.chartConfigSenti)));
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