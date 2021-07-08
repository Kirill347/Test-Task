import { LightningElement, api, wire } from 'lwc';
const TILE_WRAPPER_UNSELECTED_CLASS = "tile-wrapper";
const PRESET_TILE_WRAPPER_UNSELECTED_CLASS = "preset-tile-wrapper";
const PRESET_ITEM_CLASS = "preset-tile";
const ITEM_CLASS = "tile";
import { publish, MessageContext } from 'lightning/messageService';
import PresetsMC from '@salesforce/messageChannel/PresetsMC__c';
export default class ItemTile extends LightningElement {
  @api
  item;

  @api
  type;

  @api
  isPresetItem;

  @api
  selectedItemId;

  @wire(MessageContext)
  messageContext;


  // Getter for dynamically setting the background image for the picture
  get backgroundStyle() {
    if (this.item != undefined) {
      const itemPicture = this.item.Picture__c;
      return `background-image:url(${itemPicture})`;
    }
  }

  get tileClass() {
    return this.isPresetItem ? PRESET_TILE_WRAPPER_UNSELECTED_CLASS : TILE_WRAPPER_UNSELECTED_CLASS;
  }

  get imageClass(){
    return this.isPresetItem ? PRESET_ITEM_CLASS : ITEM_CLASS;
  }

  // Fires event with the Id of the boat that has been selected.
  selectItem() {
    if (this.item) {
      const itemselectEvent = new CustomEvent('itemselect', {
        detail: { item: this.item, type: this.type }
      });
      this.dispatchEvent(itemselectEvent);
    }
  }

  handleDoubleClick() {
    if (this.item) {
      this.sendMessageService();
    }
  }

  sendMessageService() {
    // explicitly pass boatId to the parameter recordId
    const payload = { presetItem: this.item, type: this.type };
    console.log('double click!!');
    publish(this.messageContext, PresetsMC, payload);
  }
}