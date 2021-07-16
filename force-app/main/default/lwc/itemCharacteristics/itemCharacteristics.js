import { LightningElement, track, wire } from 'lwc';
import ItemMC from '@salesforce/messageChannel/ItemMessageChannel__c';
import armor from '@salesforce/label/c.Armor_Object_Label';
import weapon from '@salesforce/label/c.Weapon_Object_Label';
import consumable from '@salesforce/label/c.Consumable_Object_Label';
import jewellery from '@salesforce/label/c.Jewellery_Object_Label';
import other from '@salesforce/label/c.Other_Item_Object_Label';
import getCharacteristicsLabels from '@salesforce/apex/ItemDataService.getCharacteristicsLabels';
import {
  subscribe,
  MessageContext,
  APPLICATION_SCOPE
} from 'lightning/messageService';
export default class ItemCharacteristics extends LightningElement {
  @track
  subscription = null;
  item;
  type;

  characteristicsLabels = {}

  @wire(getCharacteristicsLabels)
  wiredCharacteristicsLabels(data, error) {
    if (data) {
      let labels = data["data"];
      for (var key in labels) {
        this.characteristicsLabels[key] = labels[key];
      }
    } else if(error){
      console.log('An error occurred while extracting characteristics labels.');
    }
  }

  get isArmor() {
    return this.type === armor
  }
  get isWeapon() {
    return this.type === weapon
  }
  get isConsumable() {
    return this.type === consumable
  }
  get isJewellery() {
    return this.type === jewellery
  }
  get isOther() {
    return this.type === other
  }
  get backgroundStyle() {
    if (this.item != undefined) {
      const itemPicture = this.item.Picture__c;
      return `background-image:url(${itemPicture}); background-color: grey; background-position: right top;
        background-size: contain; background-repeat: no-repeat;`;
    }
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
      { scope: APPLICATION_SCOPE }
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