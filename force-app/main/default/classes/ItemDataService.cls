global with sharing class ItemDataService {
    
    @AuraEnabled(cacheable=true)
    public static Decimal getGeneralWeight(){
        try {
            Decimal result = 0;

            for(Armor__c obj : getArmor()){
                result+=obj.Weight__c;
            }
            for(Weapon__c obj : getWeapons()){
                result+=obj.Weight__c;
            }
            for(Consumable__c obj : getConsumables()){
                result+=obj.Weight__c;
            }
            for(Jewellery__c obj : getJewellery()){
                result+=obj.Weight__c;
            }
            for(Other_Item__c obj : getOtherItems()){
                result+=obj.Weight__c;
            }

            return result;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Armor__c> getArmor(){
        return [SELECT 
        Name, Magical_protection__c, 
        Physical_protection__c, Picture__c, 
        Weight__c, Type__c, Description__c 
        FROM Armor__c];
    }

    @AuraEnabled(cacheable=true)
    public static List<Weapon__c> getWeapons(){
        return [SELECT Name, Electric_Damage__c, 
        Fire_Damage__c, Physical_Damage__c,
        Poison_Damage__c,Water_Damage__c,
        Picture__c, Weight__c, Type__c, 
        Description__c 
        FROM Weapon__c];
    }

    @AuraEnabled(cacheable=true)
    public static List<Jewellery__c> getJewellery(){
        return [SELECT 
        Name, Magical_Protection__c, Picture__c, 
        Weight__c, Description__c 
        FROM Jewellery__c];
    }

    @AuraEnabled(cacheable=true)
    public static List<Consumable__c> getConsumables(){
        return [SELECT 
        Name, Effect__c, Picture__c, 
        Weight__c, Description__c 
        FROM Consumable__c];
    }

    @AuraEnabled(cacheable=true)
    public static List<Other_Item__c> getOtherItems(){
        return [SELECT 
        Name, Picture__c, 
        Weight__c, Description__c 
        FROM Other_Item__c];
    }

    @AuraEnabled(cacheable=true)
    public static List<Preset__c> getPresets(){

        /*String strQuery = 'SELECT ';
        list<Schema.DescribeSObjectResult> objDiscribe = Schema.describeSObjects(new List<String>{'Preset__c'});
        Map<String, Schema.SObjectField> objFileds = objDiscribe[0].fields.getMap();
        list<String> lstOfFieldNames = new list<String>(objFileds.keySet());
        strQuery = strQuery + String.join(lstOfFieldNames, ', ') + ' FROM ' +'Preset__c';
        strQuery += ' WITH SECURITY_ENFORCED LIMIT 2';
        return Database.query(strQuery);*/
      
            return [
                SELECT Id, Name, 
                Armor_Chest__r.Name, Armor_Chest__r.Magical_protection__c, 
                Armor_Chest__r.Physical_protection__c, Armor_Chest__r.Picture__c, 
                Armor_Chest__r.Weight__c, Armor_Chest__r.Type__c, Armor_Chest__r.Description__c ,
                Boots__r.Name, Boots__r.Magical_protection__c, Boots__r.Physical_protection__c, 
                Boots__r.Picture__c, Boots__r.Weight__c, Boots__r.Type__c, Boots__r.Description__c , 
                Gloves__r.Name, Gloves__r.Magical_protection__c, Gloves__r.Physical_protection__c, 
                Gloves__r.Picture__c, Gloves__r.Weight__c, Gloves__r.Type__c, Gloves__r.Description__c,
                Helmet__r.Name, Helmet__r.Magical_protection__c, Helmet__r.Physical_protection__c, 
                Helmet__r.Picture__c, Helmet__r.Weight__c, Helmet__r.Type__c, Helmet__r.Description__c,
                Ring1__r.Name, Ring1__r.Magical_protection__c, Ring1__r.Picture__c, Ring1__r.Weight__c, Ring1__r.Description__c, 
                Ring2__r.Name, Ring2__r.Magical_protection__c, Ring2__r.Picture__c, Ring2__r.Weight__c, Ring2__r.Description__c, 
                Trousers__r.Name, Trousers__r.Magical_protection__c, Trousers__r.Physical_protection__c, 
                Trousers__r.Picture__c, Trousers__r.Weight__c, Trousers__r.Type__c, Trousers__r.Description__c, 
                Weapon1__r.Name, Weapon1__r.Electric_Damage__c, Weapon1__r.Fire_Damage__c, 
                Weapon1__r.Physical_Damage__c, Weapon1__r.Poison_Damage__c, Weapon1__r.Water_Damage__c,
                Weapon1__r.Picture__c, Weapon1__r.Weight__c, Weapon1__r.Type__c, Weapon1__r.Description__c,
                Weapon2__r.Name, Weapon2__r.Electric_Damage__c, Weapon2__r.Fire_Damage__c, 
                Weapon2__r.Physical_Damage__c, Weapon2__r.Poison_Damage__c, Weapon2__r.Water_Damage__c,
                Weapon2__r.Picture__c, Weapon2__r.Weight__c, Weapon2__r.Type__c, Weapon2__r.Description__c,
                General_Magical_Protection__c, General_Physical_Protection__c
                FROM Preset__c 
                WITH SECURITY_ENFORCED
                ORDER BY Name
                LIMIT :Constants.MAX_PRESETS];
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, String> getPresetLabels(){
        try {
            Map<String, String> result = new Map<String, String>();
            Map<String, Schema.SObjectField> describeSobjectsResult = Schema.getGlobalDescribe().get('Preset__c').getDescribe().fields.getMap();
            result.put('helmet', describeSobjectsResult.get('Helmet__c').getDescribe().getLabel());
            result.put('armorChest', describeSobjectsResult.get('Armor_Chest__c').getDescribe().getLabel());
            result.put('gloves', describeSobjectsResult.get('Gloves__c').getDescribe().getLabel());
            result.put('trousers', describeSobjectsResult.get('Trousers__c').getDescribe().getLabel());
            result.put('boots', describeSobjectsResult.get('Boots__c').getDescribe().getLabel());
            result.put('ring1', describeSobjectsResult.get('Ring1__c').getDescribe().getLabel());
            result.put('ring2', describeSobjectsResult.get('Ring2__c').getDescribe().getLabel());
            result.put('weapon1', describeSobjectsResult.get('Weapon1__c').getDescribe().getLabel());
            result.put('weapon2', describeSobjectsResult.get('Weapon2__c').getDescribe().getLabel());
            return result;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, String> getCharacteristicsLabels(){
        try {
            Map<String, String> result = new Map<String, String>();
            List<String> objectsName = new List<String>{'Armor__c', 'Weapon__c', 'Jewellery__c', 'Consumable__c'};
            List<Schema.DescribeSObjectResult> describeSobjectsResult = Schema.describeSObjects(objectsName);
            result.put('physicalProtection', describeSobjectsResult[0].fields.getMap().get('Physical_protection__c').getDescribe().getLabel());
            result.put('magicalProtection', describeSobjectsResult[0].fields.getMap().get('Magical_protection__c').getDescribe().getLabel());
            result.put('physicalDamage', describeSobjectsResult[1].fields.getMap().get('Physical_Damage__c').getDescribe().getLabel());
            result.put('electricDamage', describeSobjectsResult[1].fields.getMap().get('Electric_Damage__c').getDescribe().getLabel());
            result.put('fireDamage', describeSobjectsResult[1].fields.getMap().get('Fire_Damage__c').getDescribe().getLabel());
            result.put('poisonDamage', describeSobjectsResult[1].fields.getMap().get('Poison_Damage__c').getDescribe().getLabel());
            result.put('waterDamage', describeSobjectsResult[1].fields.getMap().get('Water_Damage__c').getDescribe().getLabel());
            result.put('jewMagicalProtection', describeSobjectsResult[2].fields.getMap().get('Magical_Protection__c').getDescribe().getLabel());
            result.put('effect', describeSobjectsResult[3].fields.getMap().get('Effect__c').getDescribe().getLabel());
            return result;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void recieveItems(String itemClass){
        try {
            if(itemClass==Constants.ARMOR_OBJECT_LABEL){
                   Utils.recieveArmorItems(); 
                }
                else if(itemClass==Constants.WEAPON_OBJECT_LABEL){
                   Utils.recieveWeaponItems();
                 }
                 else if(itemClass==Constants.JEWELLERY_OBJECT_LABEL) {
                     Utils.recieveJewelleryItems();
                 }
                 else if(itemClass==Constants.CONSUMABLE_OBJECT_LABEL) {
                    Utils.recieveConsumableItems();
                 }
                 else if(itemClass==Constants.OTHER_OBJECT_LABEL){
                    Utils.recieveOtherItems();
                 }
            }
              
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void unloadItemsAsync(String itemClass){
        try {
            if(itemClass==Constants.ARMOR_OBJECT_LABEL){
                   Utils.unloadArmorItems(); 
                }
                else if(itemClass==Constants.WEAPON_OBJECT_LABEL){
                   Utils.unloadWeaponItems();
                 }
                 else if(itemClass==Constants.JEWELLERY_OBJECT_LABEL) {
                    Utils.unloadJewelleryItems();
                 }
                 else if(itemClass==Constants.CONSUMABLE_OBJECT_LABEL) {
                    Utils.unloadConsumableItems();
                 }
                 else if(itemClass==Constants.OTHER_OBJECT_LABEL){
                    Utils.unloadOtherItems();
                 }
            }
              
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}