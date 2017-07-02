//
//  FeedItem.swift
//  Feed
//
//  Created by Almir Akmalov on 18.06.17.
//  Copyright © 2017 Akm. All rights reserved.
//

import Foundation
import Mantle

let SQLTableMerchants = "Merchants"
let SQLTableCities = "Cities"
let SQLTableStores = "Stores"

extension Dictionary {
    
    mutating func merge(with dictionary: Dictionary) {
        dictionary.forEach { updateValue($1, forKey: $0) }
    }
    
    func merged(with dictionary: Dictionary) -> Dictionary {
        var dict = self
        dict.merge(with: dictionary)
        return dict
    }
}

class BaseObject: MTLModel, MTLJSONSerializing {
    
    var ident: String = ""
    
    class func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return ["ident": "id"]
    }
    
    static func identJSONTransformer() -> ValueTransformer {
        return MTLValueTransformer.init(block: { (obj) -> Any? in
            if (obj != nil)  {
                return String(format:"%@", obj as! CVarArg)
            }
            return obj
        })
    }
}

final class Merchant : BaseObject {
    
    var name: String? = nil
    var merchantDescription: String? = nil
    var logo_url : String? = nil
    var logoData : Data? = nil
    var discount_description_url: String? = nil
    var discountDescription: String? = nil
    var is_deleted: NSNumber! = 0//пришлось использовать NSNumber т.к. в Bool парсить не мог
    var version: String! = nil
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        
        let params = BaseObject.jsonKeyPathsByPropertyKey()
        return params?.merged(with: ["merchantDescription":"description"])
        
    }
    
}

final class Store : BaseObject {
    
    var merchantId : String? = nil
    var merchant : Merchant? = nil
    var cityId : String? = nil
    var cityName : String? = nil
    var address : String? = nil
    var version: String! = nil
    var is_deleted: NSNumber! = 0
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        
        let params = BaseObject.jsonKeyPathsByPropertyKey()
        return params?.merged(with: ["merchantId":"merchant_id",
                                     "cityId":"city_id"])
        
    }
    
    static func cityIdJSONTransformer() -> ValueTransformer {
        return MTLValueTransformer.init(block: { (obj) -> Any? in
            if (obj != nil)  {
                return String(format:"%@", obj as! CVarArg)
            }
            return obj
        })
    }
    
    static func merchantIdJSONTransformer() -> ValueTransformer {
        return MTLValueTransformer.init(block: { (obj) -> Any? in
            if (obj != nil)  {
                return String(format:"%@", obj as! CVarArg)
            }
            return obj
        })
    }
}

final class City : BaseObject {
    
    var name : String? = nil
    var version: String! = nil
    var is_deleted: NSNumber! = 0
    
}
