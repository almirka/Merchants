//
//  RequestTest.swift
//  Feed
//
//  Created by Almir Akmalov on 24.06.17.
//  Copyright © 2017 Akm. All rights reserved.
//

import Foundation
import Mantle

class StoresRequest: FD_Request {
    
    let minVersion : String
    let maxVersion : String
    let direction : String
    let count : Int
    
    init(min_version : String, max_version : String, direction : String, count : Int) {
        self.minVersion = min_version
        self.maxVersion = max_version
        self.direction = direction
        self.count = count
    }
    
    override func requestResultClass() -> String {
        return NSStringFromClass(StoresResult.self)
    }
    
    public override func serverUrlString() -> String! {
        return "http://evotor-api.vigroup.ru/v1/";
    }
    
    public override func handlerString() -> String! {
        return "stores?";
    }
    
    public override func paramsDictionary() -> Dictionary<String, Any>! {
        let params = ["min_version":self.minVersion,
                      "max_version":self.maxVersion,
                      "direction":self.direction,
                      "count":self.count] as [String : Any]
        
        let paramsDict = ["no_token":1,
                          "data":params] as [String : Any]
        
        return paramsDict
    }
    
}


class StoresResult: FD_RequestResult {
    
    var storesArray : Array<Store>? = nil
    
    private override init() {
        super.init()
    }
    
    override class func initRequestResult(json: Dictionary<String, Any>?,request:FD_Request) -> FD_RequestResult? {
        let result = StoresResult()
        let stores = try! MTLJSONAdapter.models(of: Store.self, fromJSONArray: json?["list"] as! Array)
        result.storesArray = stores as? Array<Store>
        
        return result
    }
    
}

class MerchantsRequest: FD_Request {
    
    let minVersion : String
    let maxVersion : String
    let direction : String
    let count : Int
    
    init(min_version : String, max_version : String, direction : String, count : Int) {
        self.minVersion = min_version
        self.maxVersion = max_version
        self.direction = direction
        self.count = count
    }
    
    override func requestResultClass() -> String {
        return NSStringFromClass(MerchantsResult.self)
    }
    
    public override func serverUrlString() -> String! {
        return "http://evotor-api.vigroup.ru/v1/";
    }
    
    public override func handlerString() -> String! {
        return "merchants?";
    }
    
    public override func paramsDictionary() -> Dictionary<String, Any>! {
        let params = ["min_version":self.minVersion,
                      "max_version":self.maxVersion,
                      "direction":self.direction,
                      "count":self.count] as [String : Any]
        
        let paramsDict = ["no_token":1,
                          "data":params] as [String : Any]
        
        return paramsDict
    }
    
}


class MerchantsResult: FD_RequestResult {
    
    var storesArray : Array<Merchant>? = nil
    
    private override init() {
        super.init()
    }
    
    override class func initRequestResult(json: Dictionary<String, Any>?,request:FD_Request) -> FD_RequestResult? {
        let result = MerchantsResult()
        let merchants = try! MTLJSONAdapter.models(of: Merchant.self, fromJSONArray: json?["list"] as! Array)
        result.storesArray = merchants as? Array<Merchant>
        
        return result
    }
    
}

class CitiesRequest: FD_Request {
    
    let minVersion : String
    let maxVersion : String
    let direction : String
    let count : Int
    
    init(min_version : String, max_version : String, direction : String, count : Int) {
        self.minVersion = min_version
        self.maxVersion = max_version
        self.direction = direction
        self.count = count
    }
    
    override func requestResultClass() -> String {
        return NSStringFromClass(CitiesResult.self)
    }
    
    public override func serverUrlString() -> String! {
        return "http://evotor-api.vigroup.ru/v1/";
    }
    
    public override func handlerString() -> String! {
        return "cities?";
    }
    
    public override func paramsDictionary() -> Dictionary<String, Any>! {
        let params = ["min_version":self.minVersion,
                      "max_version":self.maxVersion,
                      "direction":self.direction,
                      "count":self.count] as [String : Any]
        
        let paramsDict = ["no_token":1,
                          "data":params] as [String : Any]
        
        return paramsDict
    }
    
}


class CitiesResult: FD_RequestResult {
    
    var storesArray : Array<City>? = nil
    
    private override init() {
        super.init()
    }
    
    override class func initRequestResult(json: Dictionary<String, Any>?,request:FD_Request) -> FD_RequestResult? {
        let result = CitiesResult()
        let stores = try! MTLJSONAdapter.models(of: City.self, fromJSONArray: json?["list"] as! Array)
        result.storesArray = stores as? Array<City>
        
        return result
    }
    
}
