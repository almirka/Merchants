//
//  File.swift
//  Feed
//
//  Created by Almir Akmalov on 24.06.17.
//  Copyright © 2017 Akm. All rights reserved.
//

import Foundation

struct FD_RequestParams {
    
    var timeout : TimeInterval = 120
    var isXml : Bool = false
    var isJson : Bool = false
}
/*
protocol FD_XmlProtocol {
    var isXml : Bool { get set }
}
protocol FD_JsonProtocol {
    var isJson : Bool! { get set }
}*/
/*
extension NSObject {
    var theClassName: String {
        return NSStringFromClass(type(of: self.requestResultClass()))
    }
}*/

class FD_Request {
    
    let requestParams : FD_RequestParams
    
    init() {
        self.requestParams = FD_RequestParams()
    }
    
    public func serverUrlString() -> String! {
        return nil;
    }
    
    public func handlerString() -> String! {
        return nil;
    }
    
    public func paramsDictionary() -> Dictionary<String, Any>! {
        return nil;
    }
    
    public func isJson() -> Bool {
        return self.requestParams.isJson
    }
    
    func requestResultClass() -> String {
        return ""
    }
    
    func requestResultFromJson(json: Dictionary<String, Any>?) -> FD_RequestResult {
        
        let aClassName = self.requestResultClass()
        let aClassType = NSClassFromString(aClassName) as! FD_RequestResult.Type
        let result = aClassType.initRequestResult(json: json, request: self)!
        
        return result
    }
    
}
/*
class FD_XmlRequest: FD_Request, FD_XmlProtocol {
    var isXml: Bool = true
}
*/

class FD_JsonRequest: FD_Request/*, FD_JsonProtocol*/ {
    //var isJson: Bool
    /*
    public override func paramsData() -> Data! {
        let dict = Dictionary<AnyHashable, Any>()
        return try! JSONSerialization.data(withJSONObject:dict, options: JSONSerialization.WritingOptions(rawValue: 0))
    }*/
    
}

