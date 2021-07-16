@isTest
public with sharing class ItemDataServiceTest {

    private static Integer count = TestConstants.TEST_COUNT;

    @testSetup
    private static void SetupTestData(){
        TestDataFactory.InsertTestData(count);
    }

    @isTest
    private static void TestGetArmor(){
        List<Armor__c> armorItems = ItemDataService.getArmor();
        System.assertEquals(count, armorItems.size());
    }
    @isTest
    private static void TestGetWeapons(){
        List<Weapon__c> weaponItems = ItemDataService.getWeapons();
        System.assertEquals(count, weaponItems.size());
    }
    @isTest
    private static void TestGetJewellery(){
        List<Jewellery__c> jewelleryItems = ItemDataService.getJewellery();
        System.assertEquals(count, jewelleryItems.size());
    }
    @isTest
    private static void TestGetConsumables(){
        List<Consumable__c> consumableItems = ItemDataService.getConsumables();
        System.assertEquals(count, consumableItems.size());
    }
    @isTest
    private static void TestGetOtherItems(){
        List<Other_Item__c> otherItems = ItemDataService.getOtherItems();
        System.assertEquals(count, otherItems.size());
    }
    @isTest
    private static void TestGetPresets(){
        List<Preset__c> preset = ItemDataService.getPresets();
        System.assertEquals(1, preset.size());
    }
    @isTest
    private static void TestGetGeneralWeight(){
        System.assertEquals(count*count*5, ItemDataService.getGeneralWeight());
    }
    @isTest
    private static void TestGetPresetLabels(){
        List<String> labels = new List<String>();
        Map<String, Schema.SObjectField> describeSobjectsResult = Schema.getGlobalDescribe().get('Preset__c').getDescribe().fields.getMap();
        labels.add(describeSobjectsResult.get('Helmet__c').getDescribe().getLabel());
        labels.add(describeSobjectsResult.get('Armor_Chest__c').getDescribe().getLabel());
        labels.add(describeSobjectsResult.get('Gloves__c').getDescribe().getLabel());
        labels.add(describeSobjectsResult.get('Trousers__c').getDescribe().getLabel());
        labels.add(describeSobjectsResult.get('Boots__c').getDescribe().getLabel());
        labels.add(describeSobjectsResult.get('Ring1__c').getDescribe().getLabel());
        labels.add(describeSobjectsResult.get('Ring2__c').getDescribe().getLabel());
        labels.add(describeSobjectsResult.get('Weapon1__c').getDescribe().getLabel());
        labels.add(describeSobjectsResult.get('Weapon2__c').getDescribe().getLabel());

        List<String> labelsFromMethod = ItemDataService.getPresetLabels().values();

        for(String label : labels){
            System.assert(labelsFromMethod.contains(label));
        }
    }
    @isTest
    private static void TestGetCharacteristicsLabels(){
        List<String> labels = new List<String>();
        List<String> objectsName = new List<String>{'Armor__c', 'Weapon__c', 'Jewellery__c', 'Consumable__c'};
        List<Schema.DescribeSObjectResult> describeSobjectsResult = Schema.describeSObjects(objectsName);
        labels.add(describeSobjectsResult[0].fields.getMap().get('Physical_protection__c').getDescribe().getLabel());
        labels.add(describeSobjectsResult[0].fields.getMap().get('Magical_protection__c').getDescribe().getLabel());
        labels.add(describeSobjectsResult[1].fields.getMap().get('Physical_Damage__c').getDescribe().getLabel());
        labels.add(describeSobjectsResult[1].fields.getMap().get('Electric_Damage__c').getDescribe().getLabel());
        labels.add(describeSobjectsResult[1].fields.getMap().get('Fire_Damage__c').getDescribe().getLabel());
        labels.add(describeSobjectsResult[1].fields.getMap().get('Poison_Damage__c').getDescribe().getLabel());
        labels.add(describeSobjectsResult[1].fields.getMap().get('Water_Damage__c').getDescribe().getLabel());
        labels.add(describeSobjectsResult[2].fields.getMap().get('Magical_Protection__c').getDescribe().getLabel());
        labels.add(describeSobjectsResult[3].fields.getMap().get('Effect__c').getDescribe().getLabel());

        List<String> labelsFromMethod = ItemDataService.getCharacteristicsLabels().values();

        for(String label : labels){
            System.assert(labelsFromMethod.contains(label));
        }
    }
    @isTest
    private static void TestRecieveArmorItems(){
        List<Armor__c> armorItemsBefore = [SELECT Name FROM Armor__c];
        System.assertEquals(count, armorItemsBefore.size());

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetArmorItemsResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');

        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        ItemDataService.recieveItems(Constants.ARMOR_OBJECT_LABEL);
        Test.stopTest();
 
        List<Armor__c> armorItemsAfter = [SELECT Name FROM Armor__c];
        System.assertEquals(count+2, armorItemsAfter.size());
    }
    @isTest
    private static void TestRecieveWeaponItems(){
        List<Weapon__c> weaponItemsBefore = [SELECT Name FROM Weapon__c];
        System.assertEquals(5, weaponItemsBefore.size());

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetWeaponItemsResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');

        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        ItemDataService.recieveItems(Constants.WEAPON_OBJECT_LABEL);
        Test.stopTest();
 
        List<Weapon__c> weaponItemsAfter = [SELECT Name FROM Weapon__c];
        System.assertEquals(7, weaponItemsAfter.size());
    }
    @isTest
    private static void TestRecieveJewelleryItems(){
        List<Jewellery__c> jewelleryItemsBefore = [SELECT Name FROM Jewellery__c];
        System.assertEquals(count, jewelleryItemsBefore.size());

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetJewelleryItemsResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');

        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        ItemDataService.recieveItems(Constants.JEWELLERY_OBJECT_LABEL);
        Test.stopTest();
 
        List<Jewellery__c> jewelleryItemsAfter = [SELECT Name FROM Jewellery__c];
        System.assertEquals(count+2, jewelleryItemsAfter.size());
    }
    @isTest
    private static void TestRecieveConsumableItems(){
        List<Consumable__c> consumableItemsBefore = [SELECT Name FROM Consumable__c];
        System.assertEquals(count, consumableItemsBefore.size());

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetConsumableItemsResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');

        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        ItemDataService.recieveItems(Constants.CONSUMABLE_OBJECT_LABEL);
        Test.stopTest();
 
        List<Consumable__c> consumableItemsAfter = [SELECT Name FROM Consumable__c];
        System.assertEquals(count+1, consumableItemsAfter.size());
    }
    @isTest
    private static void TestRecieveOtherItems(){
        List<Other_Item__c> otherItemsBefore = [SELECT Name FROM Other_Item__c];
        System.assertEquals(count, otherItemsBefore.size());

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetOtherItemsResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');

        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        ItemDataService.recieveItems(Constants.OTHER_OBJECT_LABEL);
        Test.stopTest();
 
        List<Other_Item__c> otherItemsAfter = [SELECT Name FROM Other_Item__c];
        System.assertEquals(count+1, otherItemsAfter.size());
    }
    @isTest
    private static void TestUnloadArmorItems(){
        Test.setMock(HttpCalloutMock.class, new ItemsHttpCalloutMock()); 
        Test.startTest();
        ItemDataService.unloadItemsAsync(Constants.ARMOR_OBJECT_LABEL);
        Test.stopTest();
        System.assertEquals(200, Utils.unloadArmorStatusCode);
    }
    @isTest
    private static void TestUnloadWeaponItems(){
        Test.setMock(HttpCalloutMock.class, new ItemsHttpCalloutMock()); 
        Test.startTest();
        ItemDataService.unloadItemsAsync(Constants.WEAPON_OBJECT_LABEL);
        Test.stopTest();
        System.assertEquals(200, Utils.unloadWeaponStatusCode);
    }
    @isTest
    private static void TestUnloadJewelleryItems(){
        Test.setMock(HttpCalloutMock.class, new ItemsHttpCalloutMock()); 
        Test.startTest();
        ItemDataService.unloadItemsAsync(Constants.JEWELLERY_OBJECT_LABEL);
        Test.stopTest();
        System.assertEquals(200, Utils.unloadJewelleryStatusCode);
    }
    @isTest
    private static void TestUnloadConsumableItems(){
        Test.setMock(HttpCalloutMock.class, new ItemsHttpCalloutMock());  
        Test.startTest();
        ItemDataService.unloadItemsAsync(Constants.CONSUMABLE_OBJECT_LABEL);
        Test.stopTest();
        System.assertEquals(200, Utils.unloadConsumableStatusCode);
    }
    @isTest
    private static void TestUnloadOtherItems(){
        Test.setMock(HttpCalloutMock.class, new ItemsHttpCalloutMock());  
        Test.startTest();
        ItemDataService.unloadItemsAsync(Constants.OTHER_OBJECT_LABEL);
        Test.stopTest();
        System.assertEquals(200, Utils.unloadOtherItemsStatusCode);
    }
}
