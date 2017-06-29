//
//  FD_FeedDetailInteractor.swift
//  Feed
//
//  Created by akmalov on 24/06/2017.
//  Copyright © 2017 Akm. All rights reserved.
//

import Foundation



protocol FD_FeedDetailInteractorOutput {
    //func recivedFeedItems(result : Array<FD_FeedItem>?)
}

@objc final class FD_FeedDetailInteractor : FD_BaseInteractor {
    
    //MARK: FD_InteractorInput
    
    
    
    override func giveParsedArray() {
        /*let minVersion = try! db.scalar("SELECT max(version) FROM Stores") as! String
        
        let request = StoresRequest.init(min_version: minVersion, max_version: "", direction: "up", count: 2)
        FD_RequestManager.sharedManager.sendRequest(request: request) { (result) in
            let testResult = result as! StoresResult
            
            let ident = Expression<String>("ident")
            let merchantId = Expression<String?>("merchantId")
            let cityId = Expression<String?>("cityId")
            let address = Expression<String?>("address")
            let version = Expression<String>("version")
            
            self.db.trace { print($0) }
            
            let storesTable = Table("Stores")
            print(testResult.storesArray!.count)
            
            if testResult.storesArray != nil {
                for store in testResult.storesArray! {
                    
                    let insert = storesTable.insert(ident <- store.ident, merchantId <- store.merchantId, cityId <- store.cityId, address <- store.address,version <- store.version)
                    try! self.db.run(insert)
                }
            }
        }*/
    }
    
}
