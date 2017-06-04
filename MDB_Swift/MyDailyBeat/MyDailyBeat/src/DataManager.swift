//
//  DataManager.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 3/5/17.
//  Copyright © 2017 eVerveCorp. All rights reserved.
//

import UIKit
import CoreData
import API

enum HealthTypes: Int64 {
    case PORTAL = 0
    case PROVIDER = 1
}
class DataManager: NSObject {
    class func getBanks() -> [BankInfo] {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let request = NSFetchRequest<BankRecord>(entityName: "BankRecord")
        var people: [BankRecord] = []
        do {
            people = try context.fetch(request)
        } catch _ as NSError {
            print("Failed to get banks.")
            return []
        }
        
        var banks: [BankInfo] = []
        for bank in people {
            banks.append(bank.toBankInfo())
        }
        
        return banks
    }
    
    class func insertBank(_ bank: BankInfo) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "BankRecord", in: context)!
        let bankRecord = BankRecord(entity: entity, insertInto: context)
        bankRecord.populateFromBankInfo(bank)
        
        do {
            try context.save()
        } catch _ as NSError {
            print("Could not add bank")
        }
    }
    
    class func getHealthPortals() -> [HealthInfo] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let request = NSFetchRequest<HealthRecord>(entityName: "HealthRecord")
        request.predicate = NSPredicate(format: "type == %d", HealthTypes.PORTAL.rawValue)
        var people: [HealthRecord] = []
        do {
            people = try context.fetch(request)
        } catch _ as NSError {
            print("Failed to get health portals.")
            return []
        }
        
        var banks: [HealthInfo] = []
        for bank in people {
            banks.append(bank.toHealthInfo())
        }
        
        return banks
    }
    
    class func insertHealthPortal(_ info: HealthInfo) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "HealthRecord", in: context)!
        let healthRecord = HealthRecord(entity: entity, insertInto: context)
        healthRecord.populateFromHealthInfo(info)
        
        do {
            try context.save()
        } catch _ as NSError {
            print("Could not add health portal")
        }
    }
    
    class func getPrescriptionProviders() -> [PrescripProviderInfo] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let request = NSFetchRequest<HealthRecord>(entityName: "HealthRecord")
        request.predicate = NSPredicate(format: "type == %d", HealthTypes.PROVIDER.rawValue)
        var people: [HealthRecord] = []
        do {
            people = try context.fetch(request)
        } catch _ as NSError {
            print("Failed to get health portals.")
            return []
        }
        
        var banks: [PrescripProviderInfo] = []
        for bank in people {
            banks.append(bank.toPrescriptionProviderInfo())
        }
        
        return banks
    }
    
    class func insertPrescriptionProvider(_ info: PrescripProviderInfo) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "HealthRecord", in: context)!
        let healthRecord = HealthRecord(entity: entity, insertInto: context)
        healthRecord.populateFromPrescriptionProviderInfo(info)
        
        do {
            try context.save()
        } catch _ as NSError {
            print("Could not add prescriotion provider.")
        }
    }
    
    class func deleteAllBanks() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "BankRecord")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try context.execute(request)
        } catch {
            fatalError("Failed to execute request: \(error)")
        }
    }
    
    class func deleteAllPortals() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "HealthRecord")
        fetch.predicate = NSPredicate(format: "type == %d", HealthTypes.PORTAL.rawValue)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try context.execute(request)
        } catch {
            fatalError("Failed to execute request: \(error)")
        }
    }
    
    class func deleteAllProviders() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "HealthRecord")
        fetch.predicate = NSPredicate(format: "type == %d", HealthTypes.PROVIDER.rawValue)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try context.execute(request)
        } catch {
            fatalError("Failed to execute request: \(error)")
        }
    }
}

extension BankRecord {
    func toBankInfo() -> BankInfo {
        let info = BankInfo(uniqueId: Int(self.id), name: self.appName!, appURL: self.appURL!, iconURL: self.iconURL!)
        return info
        
    }
    
    func populateFromBankInfo(_ info: BankInfo) {
        self.id = Int64(info.uniqueId)
        self.appURL = info.appURL
        self.appName = info.appName
        self.iconURL = info.iconURL
    }
}

extension HealthRecord {
    func toHealthInfo() -> HealthInfo {
        let info = HealthInfo(uniqueId: Int(self.id), url: self.url!, logoURL: self.logoURL!)
        return info
    }
    
    func populateFromHealthInfo(_ info: HealthInfo) {
        self.id = Int64(info.uniqueId)
        self.url = info.url
        self.logoURL = info.logoURL
        self.type = HealthTypes.PORTAL.rawValue
    }
    
    func toPrescriptionProviderInfo() -> PrescripProviderInfo {
        let info = PrescripProviderInfo(uniqueId: Int(self.id), url: self.url!, logoURL: self.logoURL!)
        return info
    }
    
    func populateFromPrescriptionProviderInfo(_ info: PrescripProviderInfo) {
        self.id = Int64(info.uniqueId)
        self.url = info.url
        self.logoURL = info.logoURL
        self.type = HealthTypes.PROVIDER.rawValue
    }
}
