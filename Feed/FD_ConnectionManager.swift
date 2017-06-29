//
//  FD_ConnectionManager.swift
//  Feed
//
//  Created by Almir Akmalov on 24.06.17.
//  Copyright © 2017 Akm. All rights reserved.
//

import Foundation
import AFNetworking

let serverUrlString = "http://evotor-api.vigroup.ru/v1/"


typealias completionHandler = (_ responseObject:Dictionary<String, Any>) -> ()
fileprivate let concurrentDownloadQueue = DispatchQueue(label: "com.akm.feed", attributes: .concurrent)

final class FD_ConnectionManager {
    static let sharedManager = FD_ConnectionManager()
    
    private var session : URLSessionConfiguration!
    
    private init() {
        self.urlSession()
    }
    
    private func urlSession() {
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.allowsCellularAccess = true
        sessionConfiguration.requestCachePolicy = .reloadIgnoringCacheData
        sessionConfiguration.httpCookieAcceptPolicy = .never
        session = sessionConfiguration
    }
    
    public func sendRequestWith(handlerString:String, params: Dictionary<String, Any>!, completionHandler:@escaping completionHandler) {
        
        let manager = AFHTTPSessionManager.init(sessionConfiguration: self.session)
        
        manager.get(serverUrlString + handlerString, parameters: params, success: { (task, responseObject) in
            completionHandler(responseObject as! Dictionary)
        }) { (task, error) in
            print(error)
        }
        
        
        
    }
    
    
}
