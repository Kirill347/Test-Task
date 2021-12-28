public with sharing class Utils {

    private static final Http HTTP = new Http();
    private static final HttpRequest REQUEST = new HttpRequest();

    public static Integer unloadArmorStatusCode;
    public static Integer unloadWeaponStatusCode;
    public static Integer unloadJewelleryStatusCode;
    public static Integer unloadConsumableStatusCode;
    public static Integer unloadOtherItemsStatusCode;

    
    @future(callout=true)
    public static void recieveWeaponItems() {
        REQUEST.setEndpoint(Constants.WEAPON_ENDPOINT);
        REQUEST.setMethod('GET');
        HttpResponse response = HTTP.send(REQUEST);
        if (response.getStatusCode() == 200) {
            List<String> weaponNames = new List<String>();
            List<Weapon__c> oldWeapons = [SELECT Name From Weapon__c];
            for(Weapon__c weapon : oldWeapons){
                weaponNames.add(weapon.name);
            }
            List<Weapon__c> newWeapons = new List<Weapon__c> ();
            List<Object> items = (List<Object>) JSON.deserializeUntyped(response.getBody());
            System.debug('Received weapon items: ' + items.size());
            for (Object item: items) {
                Map<String, Object> m = (Map<String, Object>)item;
                if(!weaponNames.contains((String)m.get('name'))){
                    newWeapons.add(new Weapon__c(Name=(String)m.get('name'), Physical_Damage__c=(Decimal)m.get('physicalDamage'), Poison_Damage__c = (Decimal)m.get('poisonDamage'), 
                    Water_Damage__c=(Decimal)m.get('waterDamage'), Fire_Damage__c = (Decimal)m.get('fireDamage'), Electric_Damage__c = (Decimal)m.get('electricDamage'), 
                    Picture__c = (String)m.get('imageURL'), Weight__c = (Decimal)m.get('weight'), Type__c = (String)m.get('type'), Description__c=(String)m.get('description')));
                    weaponNames.add((String)m.get('name'));
                }
            }
            insert newWeapons;
        }
    }
    @future(callout=true)
    public static void recieveArmorItems() {
        REQUEST.setEndpoint(Constants.ARMOR_ENDPOINT);
        REQUEST.setMethod('GET');
        HttpResponse response = HTTP.send(REQUEST);
        if (response.getStatusCode() == 200) {
            List<String> armorNames = new List<String>();
            List<Armor__c> oldArmor = [SELECT Name From Armor__c];
            for(Armor__c armor : oldArmor){
                armorNames.add(armor.name);
            }
            List<Armor__c> newArmor = new List<Armor__c> ();
            List<Object> items = (List<Object>) JSON.deserializeUntyped(response.getBody());
            System.debug('Received weapon items: ' + items.size());
            for (Object item: items) {
                Map<String, Object> m = (Map<String, Object>)item;
                if(!armorNames.contains((String)m.get('name'))){
                    newArmor.add(new Armor__c(Name = (String)m.get('name'), Magical_Protection__c = (Decimal)m.get('magicalProtection'), Physical_protection__c = (Decimal)m.get('physicalProtection'), 
                        Picture__c = (String)m.get('imageURL'),Weight__c = (Decimal)m.get('weight'), Type__c = (String)m.get('type'), Description__c = (String)m.get('description')));
                    armorNames.add((String)m.get('name'));
                }
            }
            insert newArmor;
        }
    }
    @future(callout=true)
    public static void recieveJewelleryItems() {
        REQUEST.setEndpoint(Constants.JEWELLERY_ENDPOINT);
        REQUEST.setMethod('GET');
        HttpResponse response = HTTP.send(REQUEST);
        if (response.getStatusCode() == 200) {
            List<String> jewelleryNames = new List<String>();
            List<Jewellery__c> oldJewellery = [SELECT Name From Jewellery__c];
            for(Jewellery__c jew : oldJewellery){
                jewelleryNames.add(jew.name);
            }
            List<Jewellery__c> newJewellery = new List<Jewellery__c> ();
            List<Object> items = (List<Object>) JSON.deserializeUntyped(response.getBody());
            System.debug('Received weapon items: ' + items.size());
            for (Object item: items) {
                Map<String, Object> m = (Map<String, Object>)item;
                if(!jewelleryNames.contains((String)m.get('name'))){
                    newJewellery.add(new Jewellery__c(Name = (String)m.get('name'), Magical_Protection__c = (Decimal)m.get('magicalProtection'), Picture__c = (String)m.get('imageURL'),
                        Weight__c = (Decimal)m.get('weight'), Description__c = (String)m.get('description')));
                    jewelleryNames.add((String)m.get('name'));
                }
            }
            insert newJewellery;
        }
    }
    @future(callout=true)
    public static void recieveConsumableItems() {
        REQUEST.setEndpoint(Constants.CONSUMABLE_ENDPOINT);
        REQUEST.setMethod('GET');
        HttpResponse response = HTTP.send(REQUEST);
        if (response.getStatusCode() == 200) {
            List<String> consumablesNames = new List<String>();
            List<Consumable__c> oldConsumables = [SELECT Name From Consumable__c];
            for(Consumable__c consumable : oldConsumables){
                consumablesNames.add(consumable.name);
            }
            List<Consumable__c> newConsumables = new List<Consumable__c> ();
            List<Object> items = (List<Object>) JSON.deserializeUntyped(response.getBody());
            System.debug('Received weapon items: ' + items.size());
            for (Object item: items) {
                Map<String, Object> m = (Map<String, Object>)item;
                if(!consumablesNames.contains((String)m.get('name'))){
                    newConsumables.add(new Consumable__c(Name = (String)m.get('name'), Picture__c = (String)m.get('imageURL'),
                        Weight__c = (Decimal)m.get('weight'), Effect__c = (String)m.get('effect'), Description__c = (String)m.get('description')));
                    consumablesNames.add((String)m.get('name'));
                }
            }
            insert newConsumables;
        }
    }
    @future(callout=true)
    public static void recieveOtherItems() {
        REQUEST.setEndpoint(Constants.OTHER_ITEMS_ENDPOINT);
        REQUEST.setMethod('GET');
        HttpResponse response = HTTP.send(REQUEST);
        if (response.getStatusCode() == 200) {
            List<String> otherItemsNames = new List<String>();
            List<Other_Item__c> oldOtherItems = [SELECT Name From Other_Item__c];
            for(Other_Item__c other : oldOtherItems){
                otherItemsNames.add(other.name);
            }
            List<Other_Item__c> newOther = new List<Other_Item__c> ();
            List<Object> items = (List<Object>) JSON.deserializeUntyped(response.getBody());
            System.debug('Received weapon items: ' + items.size());
            for (Object item: items) {
                Map<String, Object> m = (Map<String, Object>)item;
                if(!otherItemsNames.contains((String)m.get('name'))){
                    newOther.add(new Other_Item__c(Name = (String)m.get('name'), Picture__c = (String)m.get('imageURL'),Weight__c = (Decimal)m.get('weight'), 
                        Description__c = (String)m.get('description')));
                    otherItemsNames.add((String)m.get('name'));
                }
            }
            insert newOther;
        }  
    }

    @future(callout=true)
    public static void unloadArmorItems(){
        REQUEST.setEndpoint(Constants.ARMOR_UNLOAD_ENDPOINT);
        REQUEST.setMethod('POST');
        REQUEST.setHeader('Content-Type', 'application/json');
        String body = '[';
        List<Armor__c> armorItemsList = [SELECT Name, Magical_protection__c, Physical_protection__c, Picture__c, Weight__c, Type__c, Description__c FROM Armor__c];
        for(Armor__c ar : armorItemsList){
            body+='{'+
            '"name": "'+ar.Name +'",'+
            '"magicalProtection": '+ ar.Magical_Protection__c +','+
            '"physicalProtection": '+ ar.Physical_Protection__c +','+
            '"imageURL": "'+ ar.Picture__c +'",'+
            '"weight": '+ ar.Weight__c +','+
            '"type": "'+ ar.Type__c +'",'+
            '"description": "' + ar.Name +' from DS"},';
        }
        body = body.Substring(0,body.length()-1);
        body+=']';
        System.debug(body);
        REQUEST.setBody(body);
        HttpResponse response = HTTP.send(REQUEST);
        // Parse the JSON response
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
        unloadArmorStatusCode = response.getStatusCode();
    }
    @future(callout=true)
    public static void unloadWeaponItems(){
        REQUEST.setEndpoint(Constants.WEAPON_UNLOAD_ENDPOINT);
        REQUEST.setMethod('POST');
        REQUEST.setHeader('Content-Type', 'application/json');
        String body = '[';
        List<Weapon__c> armorItemsList = [SELECT Name, Electric_Damage__c, Fire_Damage__c, Physical_Damage__c,
            Poison_Damage__c,Water_Damage__c,Picture__c, Weight__c, Type__c, Description__c FROM Weapon__c];
        for(Weapon__c ar : armorItemsList){
            body+='{'+
            '"name": "'+ar.Name +'",'+
            '"physicalDamage": '+ ar.Physical_Damage__c +','+
            '"poisonDamage": '+ ar.Poison_Damage__c +','+
            '"waterDamage": '+ ar.Water_Damage__c +','+
            '"fireDamage": '+ ar.Fire_Damage__c +','+
            '"electricDamage": '+ ar.Electric_Damage__c +','+
            '"imageURL": "'+ ar.Picture__c +'",'+
            '"weight": '+ ar.Weight__c +','+
            '"type": "'+ ar.Type__c +'",'+
            '"description": "' + ar.Name +' from DS"},';
        }
        body = body.Substring(0,body.length()-1);
        body+=']';
        System.debug(body);
        REQUEST.setBody(body);
        HttpResponse response = HTTP.send(REQUEST);
        // Parse the JSON response
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
        unloadWeaponStatusCode = response.getStatusCode();
    }
    @future(callout=true)
    public static void unloadJewelleryItems(){
        REQUEST.setEndpoint(Constants.JEWELLERY_UNLOAD_ENDPOINT);
        REQUEST.setMethod('POST');
        REQUEST.setHeader('Content-Type', 'application/json');
        String body = '[';
        List<Jewellery__c> armorItemsList = [SELECT 
        Name, Magical_Protection__c, Picture__c, 
        Weight__c, Description__c 
        FROM Jewellery__c];
        for(Jewellery__c ar : armorItemsList){
            body+='{'+
            '"name": "'+ar.Name +'",'+
            '"magicalProtection": '+ ar.Magical_Protection__c +','+
            '"imageURL": "'+ ar.Picture__c +'",'+
            '"weight": '+ ar.Weight__c +','+
            '"description": "' + ar.Name +' from DS"},';
        }
        body = body.Substring(0,body.length()-1);
        body+=']';
        System.debug(body);
        REQUEST.setBody(body);
        HttpResponse response = HTTP.send(REQUEST);
        // Parse the JSON response
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
        unloadJewelleryStatusCode = response.getStatusCode();
    }
    @future(callout=true)
    public static void unloadConsumableItems(){
        REQUEST.setEndpoint(Constants.CONSUMABLE_UNLOAD_ENDPOINT);
        REQUEST.setMethod('POST');
        REQUEST.setHeader('Content-Type', 'application/json');
        String body = '[';
        List<Consumable__c> armorItemsList = [SELECT 
        Name, Effect__c, Picture__c, 
        Weight__c, Description__c 
        FROM Consumable__c];
        for(Consumable__c ar : armorItemsList){
            body+='{'+
            '"name": "'+ar.Name +'",'+
            '"imageURL": "'+ ar.Picture__c +'",'+
            '"weight": '+ ar.Weight__c +','+
            '"effect": "'+ ar.Effect__c +'",'+
            '"description": "' + ar.Name +' from DS"},';
        }
        body = body.Substring(0,body.length()-1);
        body+=']';
        System.debug(body);
        REQUEST.setBody(body);
        HttpResponse response = HTTP.send(REQUEST);
        // Parse the JSON response
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
        unloadConsumableStatusCode = response.getStatusCode();
    }
    @future(callout=true)
    public static void unloadOtherItems(){
        REQUEST.setEndpoint(Constants.OTHER_ITEMS_UNLOAD_ENDPOINT);
        REQUEST.setMethod('POST');
        REQUEST.setHeader('Content-Type', 'application/json');
        String body = '[';
        List<Other_Item__c> armorItemsList = [SELECT 
        Name, Picture__c, 
        Weight__c, Description__c 
        FROM Other_Item__c];
        for(Other_Item__c ar : armorItemsList){
            body+='{'+
            '"name": "'+ar.Name +'",'+
            '"imageURL": "'+ ar.Picture__c +'",'+
            '"weight": '+ ar.Weight__c +','+
            '"description": "' + ar.Name +' from DS"},';
        }
        body = body.Substring(0,body.length()-1);
        body+=']';
        REQUEST.setBody(body);
        HttpResponse response = HTTP.send(REQUEST);
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
        unloadOtherItemsStatusCode = response.getStatusCode();
    }
}