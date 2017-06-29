//
//  FD_RequestManager.swift
//  Feed
//
//  Created by Almir Akmalov on 24.06.17.
//  Copyright © 2017 Akm. All rights reserved.
//

import Foundation
import AFNetworking

typealias completionResult = (FD_RequestResult) -> ()

fileprivate let concurrentDownloadQueue = DispatchQueue(label: "com.vigroup.akm", attributes: .concurrent)

private let _sharedManager = FD_RequestManager()

class FD_RequestManager {
    
    class var sharedManager: FD_RequestManager {
        _sharedManager.requestQueue = OperationQueue()
        _sharedManager.requestQueue.maxConcurrentOperationCount = 5
        return _sharedManager
    }
    var requestQueue : OperationQueue!
    
    func sendRequest(request:FD_Request, completionHandler:@escaping completionResult) -> Void {
        
        
        concurrentDownloadQueue.async(execute: {
            let urlRequest = self.buildURLRequest(request: request)
            
            let requestOperation = AFHTTPRequestOperation.init(request: urlRequest)
            requestOperation.setCompletionBlockWithSuccess({ (operation, responseObject) in
                
                let receivedDict = try! JSONSerialization.jsonObject(with: responseObject as! Data, options: JSONSerialization.ReadingOptions(rawValue: 0))
                
                
                self.parseAndCallHandler(json: receivedDict as! Dictionary<String, AnyObject>, receivedData: responseObject as! Data, request: request, handler: completionHandler)
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = self.isRequiredPending()
                
            }, failure: { (operation, error) in
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = self.isRequiredPending()
            })
            self.requestQueue.addOperation(requestOperation)
        })
    }
    
    func buildURLRequest(request:FD_Request) -> URLRequest {
        
        let urlString = request.serverUrlString() + request.handlerString() + request.paramsDictionary().stringFromHttpParameters()
        let url = URL(string: urlString)
        var urlRequest = URLRequest(url: url!)
        
        urlRequest.httpMethod = "GET"
        
        urlRequest.timeoutInterval = request.requestParams.timeout
        
        urlRequest.cachePolicy = .reloadIgnoringCacheData
        urlRequest.networkServiceType = .default
        urlRequest.httpShouldUsePipelining = true
        
        return urlRequest
    }
    
    func parseAndCallHandler(json:Dictionary<String, AnyObject>, receivedData:Data, request:FD_Request, handler:@escaping completionResult) {
        
        let requestResult = request.requestResultFromJson(json: json)
        
        DispatchQueue.main.async {
            handler(requestResult)
        }
    }
    
    func isRequiredPending() -> Bool {
        return self.requestQueue.operations.count > 0
    }
    
    func cancelAllRequests() {
        self.requestQueue.cancelAllOperations()
    }
    
}

extension String {
    
    func addingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
    
}

extension Dictionary {
    
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).addingPercentEncodingForURLQueryValue()!
            let strValue = String(describing: value)
            let percentEscapedValue = strValue.addingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return parameterArray.joined(separator: "&")
    }
    
}
