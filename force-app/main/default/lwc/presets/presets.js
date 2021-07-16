import { LightningElement, track, wire, api } from 'lwc';
import getPresets from '@salesforce/apex/ItemDataService.getPresets';
import getPresetLabels from '@salesforce/apex/ItemDataService.getPresetLabels';
import ItemMC from '@salesforce/messageChannel/ItemMessageChannel__c';
import PresetsMC from '@salesforce/messageChannel/PresetsMC__c';
import { refreshApex } from '@salesforce/apex';
import { updateRecord, createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {
    subscribe,
    publish,
    MessageContext,
    APPLICATION_SCOPE
} from 'lightning/messageService';
import PRESET_OBJECT from '@salesforce/schema/Preset__c';
import BOOTS from '@salesforce/schema/Preset__c.Boots__c';
import ARMOR_CHEST from '@salesforce/schema/Preset__c.Armor_Chest__c';
import ID_FIELD from '@salesforce/schema/Preset__c.Id';
import HELMET from '@salesforce/schema/Preset__c.Helmet__c';
import GLOVES from '@salesforce/schema/Preset__c.Gloves__c';
import RING1 from '@salesforce/schema/Preset__c.Ring1__c';
import RING2 from '@salesforce/schema/Preset__c.Ring2__c';
import WEAPON1 from '@salesforce/schema/Preset__c.Weapon1__c';
import WEAPON2 from '@salesforce/schema/Preset__c.Weapon2__c';
import TROUSERS from '@salesforce/schema/Preset__c.Trousers__c';
import armor from '@salesforce/label/c.Armor_Object_Label';
import weapon from '@salesforce/label/c.Weapon_Object_Label';
import consumable from '@salesforce/label/c.Consumable_Object_Label';
import jewellery from '@salesforce/label/c.Jewellery_Object_Label';
import other from '@salesforce/label/c.Other_Item_Object_Label';
export default class Presets extends LightningElement {
    constants = {
        armor,
        weapon,
        consumable,
        jewellery,
        other
    }

    @wire(getPresetLabels)
    wiredPresetLabels(data,error){
        if (data) {
            let labels = data["data"];
            for (var key in labels) {
              this.constants[key] = labels[key];
            }
          } else if(error){
            console.log('An error occurred while extracting characteristics labels.');
          }
    }

    @wire(getPresets)
    presets;

    @track
    activePresetIndex;

    @track
    error;

    @wire(MessageContext)
    messageContextPublish;

    @wire(MessageContext)
    messageContextSubscribe;

    updateSelectedTile(event) {
        const item = event.detail.item
        const type = event.detail.type
        this.selectedItem = item;
        this.sendMessageService(item, type);
    }

    handleTabClick() {
        this.defineActivePreset();
    }

    /*createPreset(){
        const fields = {};
        const recordInput = { apiName: PRESET_OBJECT.objectApiName, fields };
        createRecord(recordInput)
            .then(() => {
                return refreshApex(this.presets);
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });
    }*/

    defineActivePreset() {
        let activePresetId = this.template.querySelector('lightning-tabset').activeTabValue;
        let data = this.presets.data;
        for (let i = 0; i < data.length; i++) {
            if (data[i].Id === activePresetId) {
                this.activePresetIndex = i;
            }
        }
    }

    sendMessageService(item, type) {
        // explicitly pass boatId to the parameter recordId
        const payload = { item: item, type: type };
        publish(this.messageContextPublish, ItemMC, payload);
    }

    subscribeMC() {
        this.subscription = subscribe(
            this.messageContextSubscribe,
            PresetsMC,
            (message) => this.handleMessage(message),
            { scope: APPLICATION_SCOPE }
        );
    }

    handleMessage(message) {
        const isPresetItem = message.isPresetItem;
        const presetItem = message.presetItem;
        const fields = {};
        let presets = this.presets.data;
        let index = this.activePresetIndex;
        fields[ID_FIELD.fieldApiName] = presets[index].Id;
        if (message.type === armor) {
            switch (presetItem.Type__c) {
                case 'Helmet':
                    fields[HELMET.fieldApiName] = isPresetItem ? '' : presetItem.Id;
                    break;
                case 'Chest Armor':
                    fields[ARMOR_CHEST.fieldApiName] = isPresetItem ? '' : presetItem.Id;
                    break;
                case 'Gloves':
                    fields[GLOVES.fieldApiName] = isPresetItem ? '' : presetItem.Id;
                    break;
                case 'Trousers':
                    fields[TROUSERS.fieldApiName] = isPresetItem ? '' : presetItem.Id;
                    break;
                case 'Boots':
                    fields[BOOTS.fieldApiName] = isPresetItem ? '' : presetItem.Id;
                    break;
            }
        } else if (message.type === weapon) {
            if (presetItem.Type__c == 'Two-Handed') {
                fields[WEAPON1.fieldApiName] = presetItem.Id;
                fields[WEAPON2.fieldApiName] = '';
            } else {
                if ((presets[index].Weapon1__c == undefined) ||
                    (presets[index].Weapon1__c != undefined && presets[index].Weapon2__c != undefined && presets[index].Weapon2__c != presetItem.Id) ||
                    (presets[index].Weapon1__r.Type__c == 'Two-Handed')) {
                    if (presets[index].Weapon2__c == presetItem.Id) {
                        fields[WEAPON1.fieldApiName] = '';
                        fields[WEAPON2.fieldApiName] = '';
                    } else {
                        fields[WEAPON1.fieldApiName] = isPresetItem ? '' : presetItem.Id;
                    }
                } else {
                    if (presets[index].Weapon1__c == presetItem.Id) {
                        fields[WEAPON1.fieldApiName] = '';
                        fields[WEAPON2.fieldApiName] = '';
                    } else {
                        fields[WEAPON2.fieldApiName] = isPresetItem ? '' : presetItem.Id;
                    }
                }
            }
        } else if (message.type === jewellery) {
            if ((presets[index].Ring1__c == undefined) ||
                (presets[index].Ring1__c != undefined && presets[index].Ring2__c != undefined && presets[index].Ring2__c != presetItem.Id)) {
                if (presets[index].Ring2__c == presetItem.Id) {
                    fields[RING1.fieldApiName] = '';
                    fields[RING2.fieldApiName] = '';
                } else {
                    fields[RING1.fieldApiName] = isPresetItem ? '' : presetItem.Id;
                }
            } else {
                if (presets[index].Ring1__c == presetItem.Id) {
                    fields[RING1.fieldApiName] = '';
                    fields[RING2.fieldApiName] = '';
                } else {
                    fields[RING2.fieldApiName] = isPresetItem ? '' : presetItem.Id;
                }

            }
        }
        this.updateActivePreset(fields);
    }

    updateActivePreset(fields) {
        for (let field in fields) {
            if (field != ID_FIELD.fieldApiName) {
                if (this.presets.data[this.activePresetIndex][field] == fields[field]) {
                    fields[field] = '';
                }
            }
        }

        const recordInput = { fields };

        updateRecord(recordInput)
            .then(() => {
                return refreshApex(this.presets);
            }).catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }

    connectedCallback() {
        this.subscribeMC();
    }
}