import { LightningElement , api,track} from 'lwc';
import getPickListValuesIntoList from '@salesforce/apex/RS_AgentGuidedWorkflow.getPickListValuesIntoList';
export default class Guidedflow_GuidedWorkflowChoices extends LightningElement {
   
    @api scripting;
    @api agentInstruction;
    @api additionalAgentInstructions;
    @api choices;
    @api focus;
    @track textchoice=[];
    @track buttonchoice=[];
    @track flagchoice=[];
    @track pickchoice=[];
    @track datetimechoice=[];
    @track inputvalue;
    @track picklistValues;
    @track picklistSeletedValue;

    renderedCallback(){
        //code
        var target = this.template.querySelector('[data-id="YES"]');
        if(target != null){
            console.log("inside");
            //target.scrollIntoView({ block: 'nearest', inline: 'start' });
             target.scrollIntoView({behavior: "smooth", block: "nearest", inline: "nearest"});
        }
    } 

    connectedCallback() {
         console.log('agentInstruction',this.agentInstruction);
         console.log('agentInstruction',this.additionalAgentInstructions)
        console.log('inside child cmp&^*&^*&');
         console.log('Choices',JSON.stringify(this.choices));
            var choices1=this.choices;
            console.log('choices1',choices1.length);
            var textce=[];
            var buttonch=[];
            var intentch=[];
            var pickch=[];
            var datatimepickch=[];
            for (let i = 0; i < choices1.length; i++) {
                console.log('choices1',JSON.stringify(choices1[i]));
                //Seperate List for text workflow
                if(choices1[i].actionType=='Input Parameter'){
                    console.log('choices1[i].actionType',choices1[i].actionType);
                    if(choices1[i].textfielddatatype=='datetime' && choices1[i].textfielddatatype!=null){
                         console.log('hoices1[i].textfielddatatype',choices1[i].textfielddatatype);
                        datatimepickch.push(choices1[i]);
                        console.log('datatimepickch',JSON.stringify(datatimepickch));
                    }
                    else{
                    textce.push(choices1[i]);
                    }
                    console.log('textce',JSON.stringify(textce));
                }
                //Seperate List for Picklist workflow
                else if(choices1[i].actionType=='Picklist'){
                    console.log('choices1[i].actionType',choices1[i].actionType);
                    pickch.push(choices1[i]);
                    console.log('pickch',JSON.stringify(textce));
                }
                //Seperate List for Button workflow
                else if(choices1[i].actionType=='Button' || choices1[i].actionType=='LWC' || choices1[i].actionType=='Flow'){
                    buttonch.push(choices1[i]);
                    console.log('textce',JSON.stringify(textce));
                }
            }
this.textchoice=textce;
this.buttonchoice=buttonch;
//picklist workflow list
this.pickchoice=pickch;
this.datetimechoice=datatimepickch;
console.log('Test');
console.log('this.pickchoicedgsg',JSON.stringify(this.pickchoice));
console.log('this.pickchoice.isEmpty()b gsg',typeof pickch);
//Get picklist Values Method
for (let i = 0; i < this.pickchoice.length; i++) {
     getPickListValuesIntoList({objectName:'Case',fieldname:this.pickchoice[i].textfieldtoupdate})
        .then(result =>{
            console.log('result',result);
            let options = [];
                const propertyNames = Object.keys(result);
                console.log('propertyNames',JSON.stringify(propertyNames));
                    console.log('this.picklistValues',this.picklistValues)
                    for(var key in result){
                  options.push({ label: result[key], value: result[key] });
                    // Here Name and Id are fields from sObject list.
                }
                this.picklistValues=options;
                console.log('options',JSON.stringify(options));
                })
            }
        }

    labelSelected(event){
        console.log('inside child cmp');
        // alert('dataId is '+event.target.dataset.id)
        var count = 1;
        var selectedChoiceMap=[];
        var selectedWorkFlowData = event.target.dataset.id
         console.log('Input Value Check1234',(this.inputvalue!=null));
        console.log('selectedWorkFlowData',selectedWorkFlowData);
        console.log('Input Value Check1234',(this.inputvalue!=null));
        if(this.inputvalue!=null){
            console.log('inside map 2524',this.inputvalue);
            var input=this.inputvalue;
             console.log('input',input);
             console.log('this.textchoice',this.textchoice.length);
             if(this.textchoice.length){
                selectedChoiceMap.push({"value":input,"key":this.textchoice[0].textfieldtoupdate});
             }
             if(this.datetimechoice.length){
                selectedChoiceMap.push({"value":input,"key":this.datetimechoice[0].textfieldtoupdate});
             }
              console.log('selectedChoiceMap',selectedChoiceMap);
        }
        if(this.picklistSeletedValue!=null){
            console.log('inside map Pick',this.picklistSeletedValue);
            var input=this.picklistSeletedValue;
            selectedChoiceMap.push({"value":input,"key":this.pickchoice[0].textfieldtoupdate});
        }
        console.log('selectedChoiceMap',JSON.stringify(selectedChoiceMap));
        console.log('Input Value Check',this.inputvalue+(this.inputvalue==null));
        var selectedWorkFlowData = event.target.dataset.id
        const custEvent = new CustomEvent(
                'callrenderworkflows',{
                    detail:{
                        WorkflowId:selectedWorkFlowData,
                          InputMap:selectedChoiceMap
                        }
                        }
                        );
                         this.dispatchEvent(custEvent);
    }
    //ONCHANGE EVENT OF PICKLIST INPUT TO SAVE THE SELECTED VALUE
    savePickListValue(event){
        this.picklistSeletedValue=event.target.value;
        console.log('inputvalue1234567',this.picklistSeletedValue);
        console.log('TYPE',typeof this.picklistSeletedValue)
    }
    //ONSUBMIT BUTTON EVENT
    validateFields(event) {
        console.log('Insode validateFields');
        this.template.querySelectorAll('.validate').forEach(element => {
            element.reportValidity();
            console.log(' element.reportValidity() Text;', element.reportValidity());
             console.log('dataId is validateFields',event.target.dataset.id);
            if(element.reportValidity()){
                this.labelSelected(event);
            }
        });
    }
     handleDateChange(event) {
    // Get the date value from the input field
    console.log('INSIDE handleDateChange');
    const selectedDate = this.inputvalue;
    console.log('selectedDate',selectedDate);
    // Check if the selected date is in the future
    const isValidDate = new Date(selectedDate) > new Date();
     console.log('isValidDate',isValidDate);
    // Set a custom validity message if the selected date is not valid
    if (isValidDate) {
          console.log('Inside If');
         this.labelSelected(event);
    } else {
        this.validateFields(event);
    }
    // Trigger the validation of the input field
  }
    //ONCHANGE EVENT ON INPUT VALUE TO SAVE VALUE ENTERED
     saveInputValue(event){
        this.inputvalue=event.target.value;
        console.log('inputvalue1234567',this.inputvalue);
          console.log('TYPE',typeof this.inputvalue)
    }

   get todaysDate() {
        var today = new Date();
        console.log('today',today);
        const tomorrow = new Date(today);
        
        console.log('tomorrow',tomorrow);
        tomorrow.setDate(tomorrow.getDate() + 2);
        console.log('tomorrowrrwtwt',tomorrow);
        var dd = String(tomorrow.getDate()).padStart(2, '0');
        var mm = String(tomorrow.getMonth() + 1).padStart(2, '0'); //January is 0!
        var yyyy = tomorrow.getFullYear();
        today = mm + '/' + dd + '/' + yyyy;
        return today
    }
}