import { LightningElement, api } from 'lwc';

const TILE_WRAPPER_SELECTED_CLASS = "tile-wrapper selected";
const TILE_WRAPPER_UNSELECTED_CLASS = "tile-wrapper";
export default class ItemTile extends LightningElement {
    @api
    item;

    @api
    type;

    @api
    selectedItemId;
    
    
    // Getter for dynamically setting the background image for the picture
    get backgroundStyle() { 
       const itemPicture = this.item.Picture__c;
       return `background-image:url(${itemPicture})`;
    }
    
    get tileClass() { 
      return this.item.Id == this.selectedItemId ? TILE_WRAPPER_SELECTED_CLASS : TILE_WRAPPER_UNSELECTED_CLASS;
  }
    
    // Fires event with the Id of the boat that has been selected.
    selectItem() {
        const itemselectEvent = new CustomEvent('itemselect', {
          detail: {item: this.item, type: this.type}
        });
        this.dispatchEvent(itemselectEvent);
      }
}