global with sharing class ItemDataService {
    
    @AuraEnabled(cacheable=true)
    public static Map<String, List<SObject>> getItems(){
        try {
            Map<String, List<SObject>> items = new Map<String, List<SObject>>();

            List<Armor__c> armorList = getArmor();
            List<Weapon__c> weaponList = getWeapons();
            List<Consumable__c> consumableList = getConsumables();
            List<Jewellery__c> jewelryList = getJewellery();
            List<Other_Item__c> otherList = getOtherItems();

            items.put('Armor', armorList);
            items.put('Weapon', weaponList);
            items.put('Consumable', consumableList);
            items.put('Jewellery', jewelryList);
            items.put('Other', otherList);

            return items;

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
                Weapon2__r.Picture__c, Weapon2__r.Weight__c, Weapon2__r.Type__c, Weapon2__r.Description__c
                FROM Preset__c 
                WITH SECURITY_ENFORCED
                LIMIT 2];
    }

}