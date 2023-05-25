import { LightningElement, api } from 'lwc';
import chartjs from '@salesforce/resourceUrl/ChartJs';
import { loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
 
export default class RS_CustomerProfileChart extends LightningElement {
    //@api chartConfig;
    //height management
    @api componentHeight;
    get style() {
        return this.componentHeight;
    }

    set style(value) {
        this.componentHeight = value;
        this.setAttribute('style', "height: " + this.componentHeight);
    }    
    //height management
    inputParam;

    @api set chartConfig(value){
         // console.log('chartConfig vlue ' , value);
        this.inputParam = value;
        this.connectedCallback();
    }
    get chartConfig(){
        return this.inputParam;
    }
    isChartJsInitialized;
    
    connectedCallback() {
        this.displayChart();
    }

    displayChart(){

       //console.log('inside RS_CustomerProfileChart ' , JSON.stringify(this.inputParam));
       if(this.inputParam !=null){
           if (this.isChartJsInitialized) {
            //return false;
        }
        // load chartjs from the static resource
        Promise.all([loadScript(this, chartjs)])
            .then(() => {
                //console.log('1111111111111111111111111111');
                this.isChartJsInitialized = true;
                const ctx = this.template.querySelector('canvas.barChart').getContext('2d');
                if(this.chart) this.chart.destroy();
                this.chart = new window.Chart(ctx, JSON.parse(JSON.stringify(this.inputParam)));
              
                this.chart.update();
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
}