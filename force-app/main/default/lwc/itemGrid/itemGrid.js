import { LightningElement, wire, track } from 'lwc';
import getArmor from '@salesforce/apex/ItemDataService.getArmor';
import getWeapon from '@salesforce/apex/ItemDataService.getWeapons';
import getJewellery from '@salesforce/apex/ItemDataService.getJewellery';
import getConsumables from '@salesforce/apex/ItemDataService.getConsumables';
import getOtherItems from '@salesforce/apex/ItemDataService.getOtherItems';
import ItemMC from '@salesforce/messageChannel/ItemMessageChannel__c';
import { publish, MessageContext } from 'lightning/messageService';
const ARMOR = 'ARMOR'
const WEAPON = 'WEAPON'
const CONSUMABLE = 'CONSUMABLE'
const JEWELLERY = 'JEWELLERY'
const OTHER = 'OTHER'
export default class ItemGrid extends LightningElement {

  constants = {
    armor:ARMOR, weapon:WEAPON, consumable:CONSUMABLE, jewellery:JEWELLERY, other:OTHER
  }

    selectedItem;

    @track
    items;

    @wire(getArmor)
    armor;
    @wire(getWeapon)
    weapons;
    @wire(getConsumables)
    consumables;
    @wire(getJewellery)
    jewellery;
    @wire(getOtherItems)
    otherItems;

    @wire(MessageContext)
    messageContext;

  /*@wire(getItems) 
  wiredItems(result) { 
      console.log('result: ' + JSON.stringify(result));
      if (result.error) {
        this.error = result.error;
        this.items = undefined;
      }
      this.armor = result;
      //this.weapon = result.Weapon
      //this.consumables = result.Consumable
      //this.jewellery = result.Jewellery
      //this.other = result.Other
      //this.notifyLoading(false);
  }*/

  updateSelectedTile(event) { 
    const item = event.detail.item
    const type = event.detail.type
    this.selectedItem = item;
    this.sendMessageService(item, type);
}

sendMessageService(item, type) { 
  // explicitly pass boatId to the parameter recordId
  const payload = {item: item, type: type};
  publish(this.messageContext, ItemMC, payload);
}
}