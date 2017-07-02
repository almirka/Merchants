//
//  FD_FeedDetailInteractor.swift
//  Feed
//
//  Created by akmalov on 24/06/2017.
//  Copyright © 2017 Akm. All rights reserved.
//

import Foundation
import SQLite

//fileprivate let concurrentDownloadLogoQueue = DispatchQueue(label: "com.vigroup.logo", attributes: .concurrent)

protocol FD_FeedDetailInteractorOutput {
    //func recivedFeedItems(result : Array<FD_FeedItem>?)
}

@objc final class FD_FeedDetailInteractor : FD_BaseInteractor {
    
    //MARK: FD_InteractorInput
    
    var db : Connection! = nil
    var merchant : Merchant!
    override func giveParsedArray() {
        
        if self.db == nil {
            let destinationSqliteURL = UserDefaults.standard.string(forKey: "Database")
            self.db = try! Connection(destinationSqliteURL!)
        }
        
        let sqlCitiesMaxVersion = String.init(format: "SELECT max(version) FROM %@", SQLTableCities)
        let citiesVersion = try! self.db.scalar(sqlCitiesMaxVersion)
        var minCitiesVersion = ""
        if citiesVersion != nil {
            minCitiesVersion = citiesVersion as! String
        }
        
        let citiesRequest = CitiesRequest.init(min_version: minCitiesVersion, max_version: "", direction: "up", count: 99)
        
        FD_RequestManager.sharedManager.sendRequest(request: citiesRequest) { (_citiesResult) in
            
            let citiesResult = _citiesResult as! CitiesResult
            
            let citiesIdent = Expression<String>("ident")
            let citiesName = Expression<String?>("name")
            let citiesVersion = Expression<String>("version")
            let citiesIsDeleted = Expression<Bool>("isDeleted")
            
            let citiesTable = Table(SQLTableCities)
            
            if citiesResult.citiesArray != nil {
                for city in citiesResult.citiesArray! {
                    
                    if city.version > minCitiesVersion {
                        if (city.is_deleted.boolValue && minCitiesVersion.characters.count > 0) {
                            
                            let sqlDelete = String.init(format: "DELETE FROM %@ WHERE (ident = %@)", SQLTableCities, city.ident)
                            _ = try! self.db.scalar(sqlDelete)
                        } else {
                            let sqlCheckUpdate = String.init(format: "SELECT version FROM %@ WHERE (ident = %@)", SQLTableCities, city.ident)
                            let currentVersion = try! self.db.scalar(sqlCheckUpdate)
                            if currentVersion != nil {
                                let rowForUpdate = citiesTable.filter(citiesIdent == city.ident)
                                try! self.db.run(rowForUpdate.update(citiesVersion <- city.version,
                                                                     citiesName <- city.name,
                                                                     citiesIsDeleted <- city.is_deleted.boolValue))
                                
                            } else {
                                let insert = citiesTable.insert(citiesIdent <- city.ident,
                                                                citiesVersion <- city.version,
                                                                citiesName <- city.name,
                                                                citiesIsDeleted <- city.is_deleted.boolValue)
                                
                                try! self.db.run(insert)
                            }
                        }
                    }
                }
            }
            
            //stores
            let sqlStoresMaxVersion = String.init(format: "SELECT max(version) FROM %@", SQLTableStores)
            let storesVersion = try! self.db.scalar(sqlStoresMaxVersion)
            var minStoresVersion = ""
            if storesVersion != nil {
                minStoresVersion = storesVersion as! String
            }
            
            let storesRequest = StoresRequest.init(min_version: minStoresVersion, max_version: "", direction: "up", count: 99)
            
            FD_RequestManager.sharedManager.sendRequest(request: storesRequest) { (result) in
                let storesResult = result as! StoresResult
                
                let storesIdent = Expression<String>("ident")
                let storesMerchantId = Expression<String?>("merchantId")
                let storesCityId = Expression<String?>("cityId")
                let storesAddress = Expression<String?>("address")
                let storesVersion = Expression<String>("version")
                let storesIsDeleted = Expression<Bool>("isDeleted")
                
                self.db.trace { print($0) }
                
                let storesTable = Table(SQLTableStores)
                
                
                if storesResult.storesArray != nil {
                    for store in storesResult.storesArray! {
                        
                        if store.version > minStoresVersion {
                            if (store.is_deleted.boolValue && minStoresVersion.characters.count > 0) {
                                
                                let sqlDelete = String.init(format: "DELETE FROM %@ WHERE (ident = %@)", SQLTableStores, store.ident)
                                _ = try! self.db.scalar(sqlDelete)
                            } else {
                                let sqlCheckUpdate = String.init(format: "SELECT version FROM %@ WHERE (ident = %@)", SQLTableStores, store.ident)
                                let currentVersion = try! self.db.scalar(sqlCheckUpdate)
                                if currentVersion != nil {
                                    let rowForUpdate = storesTable.filter(storesIdent == store.ident)
                                    try! self.db.run(rowForUpdate.update(storesVersion <- store.version,
                                                                         storesMerchantId <- store.merchantId,
                                                                         storesCityId <- store.cityId,
                                                                         storesAddress <- store.address,
                                                                         storesIsDeleted <- store.is_deleted.boolValue))
                                    
                                } else {
                                    let insert = storesTable.insert(storesIdent <- store.ident,
                                                                    storesVersion <- store.version,
                                                                    storesMerchantId <- store.merchantId,
                                                                    storesCityId <- store.cityId,
                                                                    storesAddress <- store.address,
                                                                    storesIsDeleted <- store.is_deleted.boolValue)
                                    
                                    try! self.db.run(insert)
                                }
                            }
                        }
                    }
                }
                
                var storesArray : Array<Any>! = []
                
                
                
                
                for storeFromTable in try! self.db.prepare(storesTable) {
                    
                    if self.merchant.ident == storeFromTable[storesMerchantId] {
                        let store = Store()!
                        store.ident = storeFromTable[storesIdent]
                        store.merchantId = storeFromTable[storesMerchantId]
                        store.cityId = storeFromTable[storesCityId]
                        store.address = storeFromTable[storesAddress]
                        store.is_deleted = storeFromTable[storesIsDeleted] as NSNumber
                        store.version = storeFromTable[storesVersion]
                        
                        if store.cityId != nil {
                            let sqlCityName = String.init(format: "SELECT name FROM %@ WHERE (ident = %@)", SQLTableCities, store.cityId!)
                            let cityName = try! self.db.scalar(sqlCityName)
                            store.cityName = cityName as? String
                        }
                        store.merchant = self.merchant
                        storesArray.append(store)
                    }
                    
                }
                self.presenter.receivedBuildedData(result: storesArray)
                
            }
            
        }
        
        
        
    }
    
}
