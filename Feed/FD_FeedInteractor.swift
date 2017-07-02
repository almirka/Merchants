//
//  FD_FeedInteractor.swift
//  Feed
//
//  Created by Almir Akmalov on 24.06.17.
//  Copyright © 2017 Akm. All rights reserved.
//

import Foundation
import SQLite

extension String {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8), options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

fileprivate let concurrentDownloadLogoQueue = DispatchQueue(label: "com.vigroup.logo", attributes: .concurrent)

protocol FD_FeedInteractorInput {
    func setupTable()
}


@objc final class FD_FeedInteractor : FD_BaseInteractor, FD_FeedInteractorInput {
    
    //MARK: FD_FeedInteractorInput
    
    var db : Connection! = nil
    
    func setupTable() {
        
        let fileManager = FileManager.default
        let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationSqliteURL = url.appendingPathComponent("Vitamin.db")
        
        UserDefaults.standard.set(destinationSqliteURL.absoluteString, forKey: "Database")
        
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
        
        if !UserDefaults.standard.bool(forKey: SQLTableStores) {
            let store = Table(SQLTableStores)
            
            let ident = Expression<String>("ident")
            let merchantId = Expression<String?>("merchantId")
            let cityId = Expression<String?>("cityId")
            let address = Expression<String?>("address")
            let version = Expression<String>("version")
            let isDeleted = Expression<Bool>("isDeleted")
            
            try! db.run(store.create { t in
                t.column(ident)
                t.column(merchantId)
                t.column(cityId)
                t.column(address)
                t.column(isDeleted)
                t.column(version, unique: true)
            })
            UserDefaults.standard.set(true, forKey: SQLTableStores)
        }
        
        if !UserDefaults.standard.bool(forKey: SQLTableMerchants) {
            let merchants = Table(SQLTableMerchants)
            
            let ident = Expression<String>("ident")
            let name = Expression<String?>("name")
            let logo_url = Expression<String?>("logo_url")
            let logoData = Expression<Data?>("logoData")
            let merchantDescription = Expression<String?>("merchantDescription")
            let discount_description_url = Expression<String?>("discount_description_url")
            let discountDescription = Expression<String?>("discountDescription")
            let version = Expression<String>("version")
            let isDeleted = Expression<Bool>("isDeleted")
            
            try! db.run(merchants.create { t in
                t.column(ident)
                t.column(name)
                t.column(logo_url)
                t.column(logoData)
                t.column(merchantDescription)
                t.column(discount_description_url)
                t.column(discountDescription)
                t.column(isDeleted)
                t.column(version, unique: true)
            })
            UserDefaults.standard.set(true, forKey: SQLTableMerchants)
        }
        
        if !UserDefaults.standard.bool(forKey: SQLTableCities) {
            let Cities = Table(SQLTableCities)
            
            let ident = Expression<String>("ident")
            let name = Expression<String?>("name")
            let isDeleted = Expression<Bool>("isDeleted")
            let version = Expression<String>("version")
            
            try! db.run(Cities.create { t in
                t.column(ident)
                t.column(name)
                t.column(isDeleted)
                t.column(version, unique: true)
            })
            UserDefaults.standard.set(true, forKey: SQLTableCities)
        }
        
    }
    
    override func giveParsedArray() {
        
        let sqlMaxVersion = String.init(format: "SELECT max(version) FROM %@", SQLTableMerchants)
        let version = try! self.db.scalar(sqlMaxVersion)
        var minVersion = ""
        if version != nil {
            minVersion = version as! String
        }
        
        let request = MerchantsRequest.init(min_version: minVersion, max_version: "", direction: "up", count: 99)
        
        FD_RequestManager.sharedManager.sendRequest(request: request) { (result) in
            let merchantsResult = result as! MerchantsResult
            
            let ident = Expression<String>("ident")
            let name = Expression<String?>("name")
            let logo_url = Expression<String?>("logo_url")
            let logoData = Expression<Data?>("logoData")
            let merchantDescription = Expression<String?>("merchantDescription")
            let discount_description_url = Expression<String?>("discount_description_url")
            let discountDescription = Expression<String?>("discountDescription")
            let version = Expression<String>("version")
            let isDeleted = Expression<Bool>("isDeleted")
            
            let merchantsTable = Table(SQLTableMerchants)
            
            if merchantsResult.merchantsArray != nil {
                for merchant in merchantsResult.merchantsArray! {
                    
                    if merchant.version > minVersion {
                        if (merchant.is_deleted.boolValue && minVersion.characters.count > 0) {
                            
                            let sqlDelete = String.init(format: "DELETE FROM %@ WHERE (ident = %@)", SQLTableMerchants, merchant.ident)
                            _ = try! self.db.scalar(sqlDelete)
                        } else {
                            let sqlCheckUpdate = String.init(format: "SELECT version FROM %@ WHERE (ident = %@)", SQLTableMerchants, merchant.ident)
                            let currentVersion = try! self.db.scalar(sqlCheckUpdate)
                            if currentVersion != nil {
                                let rowForUpdate = merchantsTable.filter(ident == merchant.ident)
                                try! self.db.run(rowForUpdate.update(name <- merchant.name,
                                                                     logo_url <- merchant.logo_url,
                                                                     merchantDescription <- merchant.merchantDescription,
                                                                     discount_description_url <- merchant.discount_description_url,
                                                                     version <- merchant.version,
                                                                     isDeleted <- merchant.is_deleted.boolValue))
                                
                            } else {
                                let insert = merchantsTable.insert(ident <- merchant.ident,
                                                                   name <- merchant.name,
                                                                   logo_url <- merchant.logo_url,
                                                                   merchantDescription <- merchant.merchantDescription,
                                                                   discount_description_url <- merchant.discount_description_url,
                                                                   version <- merchant.version,
                                                                   isDeleted <- merchant.is_deleted.boolValue)
                                
                                try! self.db.run(insert)
                            }
                            if merchant.logo_url != nil {
                                concurrentDownloadLogoQueue.async(execute: {
                                    let url = URL.init(string: merchant.logo_url!)
                                    if url != nil {
                                        let imageData = try! Data.init(contentsOf:url!)
                                        let rowForUpdate = merchantsTable.filter(ident == merchant.ident)
                                        try! self.db.run(rowForUpdate.update(logoData <- imageData))
                                    }
                                })
                            }
                        }
                    }
                }
            }
            
            concurrentDownloadLogoQueue.sync(execute: { 
                
                var merchantsDictionary : Array<Any>! = []
                
                for merchantFromTable in try! self.db.prepare(merchantsTable) {
                    
                    let merchant = Merchant()!
                    merchant.ident = merchantFromTable[ident]
                    merchant.name = merchantFromTable[name]
                    merchant.logo_url = merchantFromTable[logo_url]
                    merchant.logoData = merchantFromTable[logoData]
                    merchant.merchantDescription = merchantFromTable[merchantDescription]
                    merchant.discount_description_url = merchantFromTable[discount_description_url]
                    merchant.discountDescription = merchantFromTable[discountDescription]
                    merchant.is_deleted = merchantFromTable[isDeleted] as NSNumber
                    merchant.version = merchantFromTable[version]
                    
                    merchantsDictionary.append(merchant)
                }
                self.presenter.receivedBuildedData(result: merchantsDictionary)
                
            })
            
        }
    }
    
}

