//
//  FD_FeedInteractor.swift
//  Feed
//
//  Created by Almir Akmalov on 24.06.17.
//  Copyright © 2017 Akm. All rights reserved.
//

import Foundation
import SQLite

protocol FD_FeedInteractorInput {
    func setupTable()
}

protocol FD_FeedInteractorOutput {
    //func recivedFeedItems(result : Array<FD_FeedItem>?)
}

@objc final class FD_FeedInteractor : FD_BaseInteractor, FD_FeedInteractorInput {
    
    //MARK: FD_FeedInteractorInput
    
    var db : Connection! = nil
    
    func setupTable() {
        
        let fileManager = FileManager.default
        let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationSqliteURL = url.appendingPathComponent("Vitamin.db")
        
        UserDefaults.standard.set(destinationSqliteURL, forKey: "Database")
        
        if !fileManager.fileExists(atPath: destinationSqliteURL.path) {
            do {
                self.db = try! Connection(destinationSqliteURL.absoluteString)
                print(destinationSqliteURL.path)
            } catch let error as NSError {
                print("Unable to create database \(error.debugDescription)")
            }
        }
        if self.db == nil {
            self.db = try! Connection(destinationSqliteURL.absoluteString)
        }
        
        if !UserDefaults.standard.bool(forKey: "Stores") {
            let store = Table("Stores")
            
            let ident = Expression<String>("ident")
            let merchantId = Expression<String?>("merchantId")
            let cityId = Expression<String?>("cityId")
            let address = Expression<String?>("address")
            let version = Expression<String>("version")
            
            try! db.run(store.create { t in
                t.column(ident)
                t.column(merchantId)
                t.column(cityId)
                t.column(address)
                t.column(version, unique: true)
            })
            UserDefaults.standard.set(true, forKey: "Stores")
        }
        
        if !UserDefaults.standard.bool(forKey: "Merchants") {
            let merchants = Table("Merchants")
            
            let ident = Expression<String>("ident")
            let name = Expression<String?>("name")
            let merchantDescription = Expression<String?>("merchantDescription")
            let discount_description_url = Expression<String?>("discount_description_url")
            let version = Expression<String>("version")
            
            try! db.run(merchants.create { t in
                t.column(ident)
                t.column(name)
                t.column(merchantDescription)
                t.column(discount_description_url)
                t.column(version, unique: true)
            })
            UserDefaults.standard.set(true, forKey: "Merchants")
        }
        
        if !UserDefaults.standard.bool(forKey: "Cities") {
            let Cities = Table("Cities")
            
            let ident = Expression<String>("ident")
            let name = Expression<String?>("name")
            let version = Expression<String>("version")
            
            try! db.run(Cities.create { t in
                t.column(ident)
                t.column(name)
                t.column(version, unique: true)
            })
            UserDefaults.standard.set(true, forKey: "Cities")
        }
        
    }
    
    override func giveParsedArray() {
        
        //let version = try! self.db.scalar("SELECT max(version) FROM \"Merchants\"")
        //let minVersion = version as! String
        
        let request = StoresRequest.init(min_version: "", max_version: "", direction: "up", count: 2)
        FD_RequestManager.sharedManager.sendRequest(request: request) { (result) in
            let merchantsResult = result as! MerchantsResult
            
            let ident = Expression<String>("ident")
            let name = Expression<String?>("name")
            let merchantDescription = Expression<String?>("merchantDescription")
            let discount_description_url = Expression<String?>("discount_description_url")
            let version = Expression<String>("version")
            
            self.db.trace { print($0) }
            
            let storesTable = Table("Merchants")
            print(merchantsResult.storesArray!.count)
            
            if merchantsResult.storesArray != nil {
                for merchant in merchantsResult.storesArray! {
                    //if merchant.version > minVersion {
                        let insert = storesTable.insert(ident <- merchant.ident, name <- merchant.name, merchantDescription <- merchant.merchantDescription, discount_description_url <- merchant.discount_description_url, version <- merchant.version)
                        try! self.db.run(insert)
                    //}
                }
                
                
                
            }
        }
    }
    
}



