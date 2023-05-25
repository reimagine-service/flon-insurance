import { LightningElement,api } from 'lwc';

export default class rs_ImageControl extends LightningElement {
    @api url;
    @api altText;
}