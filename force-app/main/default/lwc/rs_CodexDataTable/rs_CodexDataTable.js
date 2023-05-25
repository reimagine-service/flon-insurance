import LightningDatatable from 'lightning/datatable';
import imageTableControl from './imageTableControl.html';

export default class Rs_CodexDataTable extends LightningDatatable  {
    static customTypes = {
        image: {
            template: imageTableControl
        }
    };
}