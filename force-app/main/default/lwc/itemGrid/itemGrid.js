import { LightningElement, wire, track } from 'lwc';
import getArmor from '@salesforce/apex/ItemDataService.getArmor';
import getWeapon from '@salesforce/apex/ItemDataService.getWeapons';
import getJewellery from '@salesforce/apex/ItemDataService.getJewellery';
import getConsumables from '@salesforce/apex/ItemDataService.getConsumables';
import getOtherItems from '@salesforce/apex/ItemDataService.getOtherItems';
import ItemMC from '@salesforce/messageChannel/ItemMessageChannel__c';
import { publish, MessageContext } from 'lightning/messageService';
import getGeneralWeight from '@salesforce/apex/ItemDataService.getGeneralWeight';
import armor from '@salesforce/label/c.Armor_Object_Label';
import weapon from '@salesforce/label/c.Weapon_Object_Label';
import consumable from '@salesforce/label/c.Consumable_Object_Label';
import jewellery from '@salesforce/label/c.Jewellery_Object_Label';
import other from '@salesforce/label/c.Other_Item_Object_Label';
import recieveNewItems from '@salesforce/apex/ItemDataService.recieveItems';
import unloadItemsAsync from '@salesforce/apex/ItemDataService.unloadItemsAsync';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
const SUCCESS_TITLE = 'The Data Was Sent';
const SUCCESS_VARIANT     = 'success';
const ERROR_TITLE = 'An error occurred while sending data';
const ERROR_VARIANT = 'error';
import { refreshApex } from '@salesforce/apex';
export default class ItemGrid extends LightningElement {

  constants = {
    armor, weapon, consumable, jewellery, other
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
  @wire(getGeneralWeight)
  generalWeight;

  @wire(MessageContext)
  messageContext;

  activetabContent = '';

  tabChangeHandler(event) {
    this.activetabContent = event.target.value;
  }

  updateSelectedTile(event) {
    const item = event.detail.item
    const type = event.detail.type
    this.selectedItem = item;
    this.sendMessageService(item, type);
  }

  sendMessageService(item, type) {
    const payload = { item: item, type: type };
    publish(this.messageContext, ItemMC, payload);
  }

  recieveItems() {
    recieveNewItems({ itemClass: this.activetabContent }).then(() => {
      window.location.reload();
    })
      .catch(error => {
        console.log('error: ' + JSON.stringify(error));
      });
  }
  unloadItems(){
    unloadItemsAsync({ itemClass: this.activetabContent }).then(() => {
        const evt = new ShowToastEvent({
          title: SUCCESS_TITLE,
          variant: SUCCESS_VARIANT
      });
      this.dispatchEvent(evt);
    })
      .catch(error => {
        const evt = new ShowToastEvent({
          title: ERROR_TITLE,
          variant: ERROR_VARIANT
      });
      this.dispatchEvent(evt);
      });
  }
}