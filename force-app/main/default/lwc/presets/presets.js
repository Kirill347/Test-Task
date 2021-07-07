import { LightningElement, track, wire, api } from 'lwc';
import getPresets from '@salesforce/apex/ItemDataService.getPresets';
import ItemMC from '@salesforce/messageChannel/ItemMessageChannel__c';
import PresetsMC from '@salesforce/messageChannel/PresetsMC__c';
import { refreshApex } from '@salesforce/apex';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {
    subscribe,
    publish,
    MessageContext,
    APPLICATION_SCOPE
} from 'lightning/messageService';
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
const ARMOR = 'ARMOR'
const WEAPON = 'WEAPON'
const CONSUMABLE = 'CONSUMABLE'
const JEWELLERY = 'JEWELLERY'
const OTHER = 'OTHER'
export default class Presets extends LightningElement {
    constants = {
        armor: ARMOR,
        weapon: WEAPON,
        consumable: CONSUMABLE,
        jewellery: JEWELLERY,
        other: OTHER
    }

    @wire(getPresets)
    presets;

    activePreset;

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

    defineActivePreset() {
        let activePresetId = this.template.querySelector('lightning-tabset').activeTabValue;
        let data = this.presets.data;
        for (let i = 0; i < data.length; i++) {
            if (data[i].Id === activePresetId) {
                this.activePreset = data[i];
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
        console.log('Presets. Type = ' + message.type + ', item = ' + message.presetItem);
        const presetItem = message.presetItem;
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.activePreset.Id;
        if (message.type === ARMOR) {
            switch (presetItem.Type__c) {
                case 'Helmet':
                        fields[HELMET.fieldApiName] = presetItem.Id;
                    break;
                case 'Chest Armor':
                        fields[ARMOR_CHEST.fieldApiName] = presetItem.Id;
                    break;
                case 'Gloves':
                        fields[GLOVES.fieldApiName] = presetItem.Id;
                    break;
                case 'Trousers':
                    let apiName = TROUSERS.fieldApiName;
                    console.log('api name: ' + this.activePreset[apiName]);
                        fields[TROUSERS.fieldApiName] = presetItem.Id;
                    break;
                case 'Boots':
                        fields[BOOTS.fieldApiName] = presetItem.Id;
                    break;
            }
        } else if (message.type === WEAPON) {
            if (presetItem.Type__c === 'Two-Handed') {
                    fields[WEAPON1.fieldApiName] = presetItem.Id;
                    fields[WEAPON2.fieldApiName] = '';
            } else {
                console.log('Weapon 1 type: ' + this.activePreset.Weapon1__r.Type__c)
                if ((this.activePreset.Weapon1__c == undefined) ||
                    (this.activePreset.Weapon1__c != undefined && this.activePreset.Weapon2__c != undefined) ||
                    (this.activePreset.Weapon1__r.Type__c == 'Two-Handed')) {
                        fields[WEAPON1.fieldApiName] = presetItem.Id;
                } else {
                    fields[WEAPON2.fieldApiName] = presetItem.Id;
                }
            }
        } else if (message.type === JEWELLERY) {
            if ((this.activePreset.Ring1__c == undefined) ||
                (this.activePreset.Ring1__c != undefined && this.activePreset.Ring2__c != undefined)) {
                fields[RING1.fieldApiName] = presetItem.Id;
            } else {
                fields[RING2.fieldApiName] = presetItem.Id;
            }
        }
        this.updateActivePreset(fields);
    }

    updateActivePreset(fields) {
        for(let field in fields){
           if(field != ID_FIELD.fieldApiName) {
               if(this.activePreset[field] == fields[field]){
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
        this.defineActivePreset();
    }

    connectedCallback() {
        this.subscribeMC();
    }
}