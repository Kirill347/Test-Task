import { LightningElement, track, wire} from 'lwc';
import ItemMC from '@salesforce/messageChannel/ItemMessageChannel__c';
import {
    subscribe,
    MessageContext,
    APPLICATION_SCOPE
  } from 'lightning/messageService';
const ARMOR = 'ARMOR'
const WEAPON = 'WEAPON'
const CONSUMABLE = 'CONSUMABLE'
const JEWELLERY = 'JEWELLERY'
const OTHER = 'OTHER'
export default class ItemCharacteristics extends LightningElement {
    @track
    subscription = null;
    item;
    type;

    get isArmor(){
        return this.type==='ARMOR'
    }
    get isWeapon(){
        return this.type==='WEAPON'
    }
    get isConsumable(){
        return this.type==='CONSUMABLE'
    }
    get isJewellery(){
        return this.type==='JEWELLERY'
    }
    get isOther(){
        return this.type==='OTHER'
    }

    

    @wire(MessageContext)
    messageContext;

    subscribeMC() {
        if (this.subscription || this.recordId) {
          return;
        }
        
        this.subscription = subscribe(
          this.messageContext,
          ItemMC,
          (message) => this.handleMessage(message),
          {scope: APPLICATION_SCOPE}
      );
      }

      handleMessage(message) {
        this.item = message.item; 
        this.type = message.type
    }
    
      // Calls subscribeMC()
      connectedCallback() {
        this.subscribeMC();
      }
}