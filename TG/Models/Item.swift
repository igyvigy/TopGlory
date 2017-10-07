//
//  Item.swift
//  TG
//
//  Created by Andrii Narinian on 8/6/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation

var itemList = Set<String>() {
    didSet {
        print(itemList.sorted(by: { $0 < $1 }))
    }
}

enum ItemCategory: String {
    case ability,
    defense,
    weapon,
    utility,
    consumable
}

enum Tier: String {
    case one, two, three
}

class Item: Model {

    var category: ItemCategory?
    var tier: Tier?
    var price: Int?
    var itemStatsId: String?
    
    required init(dict: [String: Any?]) {
        
        self.category = ItemCategory(rawValue: dict["category"] as? String ?? "")
        self.tier = Tier(rawValue: dict["tier"] as? String ?? "")
        self.price = dict["price"] as? Int
        self.itemStatsId = dict["itemStatsId"] as? String
        super.init(dict: dict)
        self.type = "Item"
        self.id = dict["id"] as? String
        self.url = dict["url"] as? String
        self.name = dict["name"] as? String
    }
    
    required init(id: String, type: ModelType) {
        if id == "Healing Flask" {
            
        }
        
        let item = AppConfig.current.itemCatche[id]
        
        self.itemStatsId = item?.itemStatsId
        self.category = item?.category
        self.tier = item?.tier
        self.price = item?.price
        
        super.init(id: id, type: type)
    }
    
    override var encoded: [String: Any?] {
        let dict: [String: Any?] = [
            "id": id,
            "url": url,
            "name": name,
            "type": type,
            "category": category?.r,
            "tier": tier?.r,
            "price": price,
            "itemStatsId": itemStatsId
        ]
        return dict
    }
}

enum ItemType: String, EnumCollection {
    case
    alternatingCurrent = "Alternating Current",
    aegis = "Aegis",
    aftershock = "Aftershock",
    atlasPauldron = "Atlas Pauldron",
    barbedNeedle = "Barbed Needle",
    blazingSalvo = "Blazing Salvo",
    bonesaw = "Bonesaw",
    bookOfEulogies = "Book Of Eulogies",
    
    breakingPoint = "Breaking Point",
    brokenMyth = "Broken Myth",
    chronograph = "Chronograph",
    clockwork = "Clockwork",
    coatOfPlates = "Coat Of Plates",
    contraption = "Contraption",
    crucible = "Crucible",
    crystalBit = "Crystal Bit",
    
    crystalInfusion = "Crystal Infusion",
    dragonbloodContract = "Dragonblood Contract",
    dragonheart = "Dragonheart",
    echo = "Echo",
    eclipsePrism = "Eclipse Prism",
    energyBattery = "Energy Battery",
    eveOfHarvest = "Eve Of Harvest",
    flare = "Flare",
    
    flareGun = "Flaregun",
    fountainOfRenewal = "Fountain of Renewal",
    frostburn = "Frostburn",
    halcyonChargers = "Halcyon Chargers",
    halcyonPotion = "Halcyon Potion",
    heavyPrism = "Heavy Prism",
    heavySteel = "Heavy Steel",
    hourglass = "Hourglass",
    
    ironguardContract = "Ironguard Contract",
    journeyBoots = "Journey Boots",
    kineticShield = "Kinetic Shield",
    levelJuice = "Level Juice",
    lifespring = "Lifespring",
    lightArmor = "Light Armor",
    lightShield = "Light Shield",
    luckyStrike = "Lucky Strike",
    
    metalJacket = "Metal Jacket",
    minionCandy = "Minion Candy",
    minionsFoot = "Minions Foot",
    nullwaveGauntlet = "Nullwave Gauntlet",
    oakheart = "Oakheart",
    piercingShard = "Piercing Shard",
    piercingSpear = "Piercing Spear",
    poisonedShiv = "Poisoned Shiv",
    
    potOfGold = "Pot Of Gold",
    protectorContract = "Protector Contract",
    reflexBlock = "Reflex Block",
    scoutTrap = "Scout Trap",
    serpentMask = "Serpent Mask",
    shatterglass = "Shatterglass",
    shiversteel = "Shiversteel",
    sixSins = "Six Sins",
    
    slumberingHusk = "Slumbering Husk",
    sorrowblade = "Sorrowblade",
    sprintBoots = "Sprint Boots",
    stormcrown = "Stormcrown",
    stormguardBanner = "Stormguard Banner",
    swiftShooter = "Swift Shooter",
    tensionBow = "Tension Bow",
    tornadoTrigger = "Tornado Trigger",
    
    travelBoots = "Travel Boots",
    tyrantsMonocle = "Tyrants Monocle",
    voidBattery = "Void Battery",
    warTreads = "War Treads",
    weaponBlade = "Weapon Blade",
    weaponInfusion = "Weapon Infusion",
    
    candyVOTaunt = "Candy - VO Taunt",
    candyTaunt = "Candy - Taunt",
    candyKissy = "Candy - Kissy",
    none
    
    init(string: String) {
        if let item = ItemType(rawValue: string) {
            self = item
        }
//        else if let statsItem = itemTypeWithItemStatsId(string) {
//            
//        }
        else {
            print("item missing: \(string)")
            if !itemList.contains(string) {
                itemList.insert(string)
            }
            self = .none
        }
    }
    
    func itemTypeWithItemStatsId(_ itemStatsId: String) -> ItemType? {
        let dropppedFirstSeven = itemStatsId.chopPrefix(7).chopSuffix().removingWhitespaces()
        if let item =  AppConfig.current.itemCatche.values
            .filter({ $0.name?.contains(dropppedFirstSeven) ?? false })
            .first {
            return ItemType(rawValue: item.id ?? "")
        } else {
            return nil
        }
    }
    
    var itemStatsId: String? {
        return "*Item_" + r.removingWhitespaces() + "*"
    }
    
    var encoded: [String: Any?] {
        let dict: [String: Any?] = [
            "id": r,
            "url": imageUrl,
            "name": name,
            "type": "Item",
            "category": category.r,
            "tier": tier.r,
            "price": price,
            "itemStatsId": itemStatsId
        ]
        return dict
    }
    
    var imageUrl: String? {
        switch self {
        case .alternatingCurrent:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/alternating-current.png"
        case .aegis:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/aegis.png"
        case .aftershock:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/aftershock.png"
        case .atlasPauldron:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/atlas-pauldron.png"
        case .barbedNeedle:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/barbed-needle.png"
        case .blazingSalvo:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/blazing-salvo.png"
        case .bonesaw:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/bonesaw.png"
        case .bookOfEulogies:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/book-of-eulogies.png"
          
        case .breakingPoint:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/breaking-point.png"
        case .brokenMyth:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/broken-myth.png"
        case .chronograph:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/chronograph.png"
        case .clockwork:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/clockwork.png"
        case .coatOfPlates:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/coat-of-plates.png"
        case .contraption:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/contraption.png"
        case .crucible:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/crucible.png"
        case .crystalBit:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/crystal-bit.png"
            
            
        case .crystalInfusion:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/crystal-infusion.png"
        case .dragonbloodContract:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/dragonblood-contract.png"
        case .dragonheart:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/dragonheart.png"
        case .echo:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/echo.png"
        case .eclipsePrism:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/eclipse-prism.png"
        case .energyBattery:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/energy-battery.png"
        case .eveOfHarvest:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/eve-of-harvest.png"
        case .flare:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/flare.png"
            
        case .flareGun:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/flare-gun.png"
        case .fountainOfRenewal:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/fountain-of-renewal.png"
        case .frostburn:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/frostburn.png"
        case .halcyonChargers:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/halcyon-chargers.png"
        case .halcyonPotion:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/halcyon-potion.png"
        case .heavyPrism:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/heavy-prism.png"
        case .heavySteel:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/heavy-steel.png"
        case .hourglass:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/hourglass.png"
            
        case .ironguardContract:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/ironguard-contract.png"
        case .journeyBoots:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/journey-boots.png"
        case .kineticShield:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/kinetic-shield.png"
        case .levelJuice:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/level-juice.png"
        case .lifespring:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/lifespring.png"
        case .lightArmor:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/light-armor.png"
        case .lightShield:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/light-shield.png"
        case .luckyStrike:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/lucky-strike.png"
            
        case .metalJacket:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/metal-jacket.png"
        case .minionCandy:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/minion-candy.png"
        case .minionsFoot:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/minions-foot.png"
        case .nullwaveGauntlet:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/nullwave-gauntlet.png"
        case .oakheart:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/oakheart.png"
        case .piercingShard:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/piercing-shard.png"
        case .piercingSpear:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/piercing-spear.png"
        case .poisonedShiv:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/poisoned-shiv.png"
            
            
        case .potOfGold:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/pot-of-gold.png"
        case .protectorContract:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/protector-contract.png"
        case .reflexBlock:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/reflex-block.png"
        case .scoutTrap:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/scout-trap.png"
        case .serpentMask:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/serpent-mask.png"
        case .shatterglass:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/shatterglass.png"
        case .shiversteel:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/shiversteel.png"
        case .sixSins:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/six-sins.png"
            
        case .slumberingHusk:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/slumbering-husk.png"
        case .sorrowblade:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/sorrowblade.png"
        case .sprintBoots:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/sprint-boots.png"
        case .stormcrown:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/stormcrown.png"
        case .stormguardBanner:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/stormguard-banner.png"
        case .swiftShooter:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/swift-shooter.png"
        case .tensionBow:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/tension-bow.png"
        case .tornadoTrigger:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/tornado-trigger.png"
            
        case .travelBoots:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/travel-boots.png"
        case .tyrantsMonocle:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/tyrants-monocle.png"
        case .voidBattery:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/void-battery.png"
        case .warTreads:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/war-treads.png"
        case .weaponBlade:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/weapon-blade.png"
        case .weaponInfusion:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/weapon-infusion.png"
        case .candyVOTaunt, .candyTaunt, .candyKissy:
            return "https://www.vaingloryfire.com/images/wikibase/icon/items/minion-candy.png"
        case .none: return nil
        }
    }
    var name: String {
        switch self {
        case .alternatingCurrent: return "Alternating Current".localized
        case .aegis: return "Aegis".localized
        case .aftershock: return "Aftershock".localized
        case .atlasPauldron: return "Atlas Pauldron".localized
        case .barbedNeedle: return "Barbed Needle".localized
        case .blazingSalvo: return "Blazing Salvo".localized
        case .bonesaw: return "Bonesaw".localized
        case .bookOfEulogies: return "Book Of Eulogies".localized
            
        case .breakingPoint: return "Breaking Point".localized
        case .brokenMyth: return "Broken Myth".localized
        case .chronograph: return "Chronograph".localized
        case .clockwork: return "Clockwork".localized
        case .coatOfPlates: return "Coat Of Plates".localized
        case .contraption: return "Contraption".localized
        case .crucible: return "Crucible".localized
        case .crystalBit: return "Crystal Bit".localized
            
        case .crystalInfusion: return "Crystal Infusion".localized
        case .dragonbloodContract: return "Dragonblood Contract".localized
        case .dragonheart: return "Dragonheart".localized
        case .echo: return "Echo".localized
        case .eclipsePrism: return "Eclipse Prism".localized
        case .energyBattery: return "Energy Battery".localized
        case .eveOfHarvest: return "Eve Of Harvest".localized
        case .flare: return "Flare".localized
            
        case .flareGun: return "Flare Gun".localized
        case .fountainOfRenewal: return "Fountain of Renewal".localized
        case .frostburn: return "Frostburn".localized
        case .halcyonChargers: return "Halcyon Chargers".localized
        case .halcyonPotion: return "Halcyon Potion".localized
        case .heavyPrism: return "Heavy Prism".localized
        case .heavySteel: return "Heavy Steel".localized
        case .hourglass: return "Hourglass".localized
            
        case .ironguardContract: return "Ironguard Contract".localized
        case .journeyBoots: return "Journey Boots".localized
        case .kineticShield: return "Kinetic Shield".localized
        case .levelJuice: return "Level Juice".localized
        case .lifespring: return "Lifespring".localized
        case .lightArmor: return "Light Armor".localized
        case .lightShield: return "Light Shield".localized
        case .luckyStrike: return "Lucky Strike".localized
            
        case .metalJacket: return "Metal Jacket".localized
        case .minionCandy: return "Minion Candy".localized
        case .minionsFoot: return "Minions Foot".localized
        case .nullwaveGauntlet: return "Nullwave Gauntlet".localized
        case .oakheart: return "Oakheart".localized
        case .piercingShard: return "Piercing Shard".localized
        case .piercingSpear: return "Piercing Spear".localized
        case .poisonedShiv: return "Poisoned Shiv".localized
            
        case .potOfGold: return "Pot Of Gold".localized
        case .protectorContract: return "Protector Contract".localized
        case .reflexBlock: return "Reflex Block".localized
        case .scoutTrap: return "Scout Trap".localized
        case .serpentMask: return "Serpent Mask".localized
        case .shatterglass: return "Shatterglass".localized
        case .shiversteel: return "Shiversteel".localized
        case .sixSins: return "Six Sins".localized
            
        case .slumberingHusk: return "Slumbering Husk".localized
        case .sorrowblade: return "Sorrowblade".localized
        case .sprintBoots: return "Sprint Boots".localized
        case .stormcrown: return "Stormcrown".localized
        case .stormguardBanner: return "Stormguard Banner".localized
        case .swiftShooter: return "Swift Shooter".localized
        case .tensionBow: return "Tension Bow".localized
        case .tornadoTrigger: return "Tornado Trigger".localized
            
        case .travelBoots: return "Travel Boots".localized
        case .tyrantsMonocle: return "Tyrants Monocle".localized
        case .voidBattery: return "Void Battery".localized
        case .warTreads: return "War Treads".localized
        case .weaponBlade: return "Weapon Blade".localized
        case .weaponInfusion: return "Weapon Infusion".localized
            
        case .candyVOTaunt, .candyTaunt, .candyKissy: return "Candy - VO Taunt".localized
        case .none: return "None".localized
        }
    }
    var category: ItemCategory {
        switch self {
        case .alternatingCurrent: return .ability
        case .aegis: return .defense
        case .aftershock: return .ability
        case .atlasPauldron: return .defense
        case .barbedNeedle: return .weapon
        case .blazingSalvo: return .weapon
        case .bonesaw: return .weapon
        case .bookOfEulogies: return .weapon
            
        case .breakingPoint: return .weapon
        case .brokenMyth: return .ability
        case .chronograph: return .ability
        case .clockwork: return .ability
        case .coatOfPlates: return .defense
        case .contraption: return .utility
        case .crucible: return .defense
        case .crystalBit: return .ability
            
        case .crystalInfusion: return .consumable
        case .dragonbloodContract: return .consumable
        case .dragonheart: return .defense
        case .echo: return .ability
        case .eclipsePrism: return .ability
        case .energyBattery: return .ability
        case .eveOfHarvest: return .ability
        case .flare: return .consumable
            
        case .flareGun: return .weapon
        case .fountainOfRenewal: return .ability
        case .frostburn: return .ability
        case .halcyonChargers: return .ability
        case .halcyonPotion: return .defense
        case .heavyPrism: return .utility
        case .heavySteel: return .defense
        case .hourglass: return .ability
            
        case .ironguardContract: return .consumable
        case .journeyBoots: return .utility
        case .kineticShield: return .defense
        case .levelJuice: return .consumable
        case .lifespring: return .defense
        case .lightArmor: return .defense
        case .lightShield: return .defense
        case .luckyStrike: return .weapon
            
        case .metalJacket: return .defense
        case .minionCandy: return .consumable
        case .minionsFoot: return .weapon
        case .nullwaveGauntlet: return .utility
        case .oakheart: return .defense
        case .piercingShard: return .ability
        case .piercingSpear: return .weapon
        case .poisonedShiv: return .weapon
            
        case .potOfGold: return .consumable
        case .protectorContract: return .consumable
        case .reflexBlock: return .defense
        case .scoutTrap: return .consumable
        case .serpentMask: return .weapon
        case .shatterglass: return .ability
        case .shiversteel: return .utility
        case .sixSins: return .weapon
            
        case .slumberingHusk: return .defense
        case .sorrowblade: return .weapon
        case .sprintBoots: return .utility
        case .stormcrown: return .utility
        case .stormguardBanner: return .utility
        case .swiftShooter: return .weapon
        case .tensionBow: return .weapon
        case .tornadoTrigger: return .weapon
            
        case .travelBoots: return .utility
        case .tyrantsMonocle: return .weapon
        case .voidBattery: return .ability
        case .warTreads: return .utility
        case .weaponBlade: return .weapon
        case .weaponInfusion: return .consumable
            
        case .candyVOTaunt, .candyTaunt, .candyKissy: return .utility
        case .none: return .ability
        }
    }
    var tier: Tier {
        switch self {
        case .alternatingCurrent: return .three
        case .aegis: return .three
        case .aftershock: return .three
        case .atlasPauldron: return .three
        case .barbedNeedle: return .two
        case .blazingSalvo: return .two
        case .bonesaw: return .three
        case .bookOfEulogies: return .one
            
        case .breakingPoint: return .three
        case .brokenMyth: return .three
        case .chronograph: return .two
        case .clockwork: return .three
        case .coatOfPlates: return .two
        case .contraption: return .three
        case .crucible: return .three
        case .crystalBit: return .one
            
        case .crystalInfusion: return .three
        case .dragonbloodContract: return .three
        case .dragonheart: return .three
        case .echo: return .three
        case .eclipsePrism: return .two
        case .energyBattery: return .two
        case .eveOfHarvest: return .three
        case .flare: return .one
            
        case .flareGun: return .three
        case .fountainOfRenewal: return .three
        case .frostburn: return .two
        case .halcyonChargers: return .three
        case .halcyonPotion: return .two
        case .heavyPrism: return .three
        case .heavySteel: return .three
        case .hourglass: return .one
            
        case .ironguardContract: return .one
        case .journeyBoots: return .three
        case .kineticShield: return .two
        case .levelJuice: return .one
        case .lifespring: return .one
        case .lightArmor: return .one
        case .lightShield: return .one
        case .luckyStrike: return .one
            
        case .metalJacket: return .one
        case .minionCandy: return .one
        case .minionsFoot: return .one
        case .nullwaveGauntlet: return .one
        case .oakheart: return .one
        case .piercingShard: return .one
        case .piercingSpear: return .one
        case .poisonedShiv: return .one
            
        case .potOfGold: return .one
        case .protectorContract: return .one
        case .reflexBlock: return .one
        case .scoutTrap: return .one
        case .serpentMask: return .one
        case .shatterglass: return .one
        case .shiversteel: return .one
        case .sixSins: return .one
            
        case .slumberingHusk: return .one
        case .sorrowblade: return .one
        case .sprintBoots: return .one
        case .stormcrown: return .one
        case .stormguardBanner: return .one
        case .swiftShooter: return .one
        case .tensionBow: return .one
        case .tornadoTrigger: return .one
            
        case .travelBoots: return .one
        case .tyrantsMonocle: return .one
        case .voidBattery: return .one
        case .warTreads: return .one
        case .weaponBlade: return .one
        case .weaponInfusion: return .one
            
        case .candyVOTaunt, .candyTaunt, .candyKissy: return .one
        case .none: return .one
        }
    }
    var price: Int {
        switch self {
        case .alternatingCurrent: return 2800
        case .aegis: return 2250
        case .aftershock: return 2400
        case .atlasPauldron: return 1900
        case .barbedNeedle: return 800
        case .blazingSalvo: return 700
        case .bonesaw: return 2700
        case .bookOfEulogies: return 300
            
        case .breakingPoint: return 2600
        case .brokenMyth: return 2150
        case .chronograph: return 800
        case .clockwork: return 2250
        case .coatOfPlates: return 800
        case .contraption: return 2100
        case .crucible: return 1850
        case .crystalBit: return 300
            
        case .crystalInfusion: return 2800
        case .dragonbloodContract: return 2250
        case .dragonheart: return 2400
        case .echo: return 1900
        case .eclipsePrism: return 800
        case .energyBattery: return 700
        case .eveOfHarvest: return 2700
        case .flare: return 300
            
        case .flareGun: return 2600
        case .fountainOfRenewal: return 2150
        case .frostburn: return 800
        case .halcyonChargers: return 2250
        case .halcyonPotion: return 800
        case .heavyPrism: return 2100
        case .heavySteel: return 1850
        case .hourglass: return 300
            
        case .ironguardContract: return 300
        case .journeyBoots: return 300
        case .kineticShield: return 300
        case .levelJuice: return 300
        case .lifespring: return 300
        case .lightArmor: return 300
        case .lightShield: return 300
        case .luckyStrike: return 300
            
        case .metalJacket: return 300
        case .minionCandy: return 300
        case .minionsFoot: return 300
        case .nullwaveGauntlet: return 300
        case .oakheart: return 300
        case .piercingShard: return 300
        case .piercingSpear: return 300
        case .poisonedShiv: return 300
            
        case .potOfGold: return 300
        case .protectorContract: return 300
        case .reflexBlock: return 300
        case .scoutTrap: return 300
        case .serpentMask: return 300
        case .shatterglass: return 300
        case .shiversteel: return 300
        case .sixSins: return 300
            
        case .slumberingHusk: return 300
        case .sorrowblade: return 300
        case .sprintBoots: return 300
        case .stormcrown: return 300
        case .stormguardBanner: return 300
        case .swiftShooter: return 300
        case .tensionBow: return 300
        case .tornadoTrigger: return 300
            
        case .travelBoots: return 300
        case .tyrantsMonocle: return 300
        case .voidBattery: return 300
        case .warTreads: return 300
        case .weaponBlade: return 300
        case .weaponInfusion: return 300
            
        case .candyVOTaunt, .candyTaunt, .candyKissy: return 0
        case .none: return 0
        }
    }
}
