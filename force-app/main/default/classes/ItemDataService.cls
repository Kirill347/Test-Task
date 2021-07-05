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

}
