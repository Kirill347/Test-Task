public with sharing class TestDataFactory {
    public static List<Armor__c> ConstructArmorItems(Integer cnt){
        List<Armor__c> armorItems = new List<Armor__c>();
        List<String> pickListValuesList= new List<String>();
		Schema.DescribeFieldResult fieldResult = Armor__c.Type__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
			pickListValuesList.add(pickListVal.getLabel());
		}    
        for(Integer i=0; i<cnt; i++){
            armorItems.add(new Armor__c(
                Name='Test Armor ' + i, Physical_Protection__c=cnt, Magical_Protection__c=cnt-1, 
                Picture__c='testarmorurl/pict'+i, Type__c=pickListValuesList.get(Math.mod(i,pickListValuesList.size())),
                Weight__c = cnt, Description__c='Test Description for item ' + i
            ));
        }
        return armorItems;
    }

    public static List<Weapon__c> ConstructWeaponItems(Integer cnt){
        List<Weapon__c> weaponItems = new List<Weapon__c>();
        List<String> pickListValuesList= new List<String>();
		Schema.DescribeFieldResult fieldResult = Weapon__c.Type__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
			pickListValuesList.add(pickListVal.getLabel());
		}    
        for(Integer i=0; i<cnt; i++){
            weaponItems.add(new Weapon__c(
                Name='Test Weapon ' + i, Physical_Damage__c=cnt, Poison_Damage__c=cnt, Fire_Damage__c=cnt, Water_Damage__c=cnt, Electric_Damage__c=cnt, 
                Picture__c='testweaponurl/pict'+i, Type__c=pickListValuesList.get(Math.mod(i,pickListValuesList.size())),
                Weight__c = cnt, Description__c='Test Description for item ' + i 
            ));
        }
        return weaponItems;
    }

    public static List<Jewellery__c> ConstructJewelleryItems(Integer cnt){
        List<Jewellery__c> jewelleryItems = new List<Jewellery__c>(); 
        for(Integer i=0; i<cnt; i++){
            jewelleryItems.add(new Jewellery__c(
                Name='Test Jewellery ' + i, Magical_Protection__c=cnt,
                Picture__c='testjewurl/pict'+i,
                Weight__c = cnt, Description__c='Test Description for item ' + i
            ));
        }
        return jewelleryItems;
    }

    public static List<Consumable__c> ConstructConsumableItems(Integer cnt){
        List<Consumable__c> consumableItems = new List<Consumable__c>(); 
        for(Integer i=0; i<cnt; i++){
            consumableItems.add(new Consumable__c(
                Name='Test Consumable ' + i, Effect__c='Test effect',
                Picture__c='testconsurl/pict'+i,
                Weight__c = cnt, Description__c='Test Description for item ' + i
            ));
        }
        return consumableItems;
    }

    public static List<Other_Item__c> ConstructOtherItems(Integer cnt){
        List<Other_Item__c> otherItems = new List<Other_Item__c>(); 
        for(Integer i=0; i<cnt; i++){
            otherItems.add(new Other_Item__c(
                Name='Test Other Item ' + i, Picture__c='testotherurl/pict'+i,
                Weight__c = cnt, Description__c='Test Description for item ' + i
            ));
        }
        return otherItems;
    }

    public static Preset__c ConstructPreset(Armor__c helmet, Weapon__c weapon1, Jewellery__c ring1){
        return new Preset__c(Helmet__c=helmet.Id, Weapon1__c = weapon1.Id, Ring1__c=ring1.Id);
    }

    public static void InsertTestData(Integer cnt){
        List<Armor__c> armorItems = ConstructArmorItems(cnt);
        insert armorItems;
        List<Weapon__c> weaponItems = ConstructWeaponItems(cnt);
        insert weaponItems;
        List<Jewellery__c> jewelleryItems = ConstructJewelleryItems(cnt);
        insert jewelleryItems;
        List<Consumable__c> consumableItems = ConstructConsumableItems(cnt);
        insert consumableItems;
        List<Other_Item__c> otherItems = ConstructOtherItems(cnt);
        insert otherItems;
        Preset__c preset = ConstructPreset(armorItems[0], weaponItems[0], jewelleryItems[0]);
        insert preset;
    }
}
