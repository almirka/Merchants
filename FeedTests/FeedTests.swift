//
//  FeedTests.swift
//  FeedTests
//
//  Created by Almir Akmalov on 17.06.17.
//  Copyright © 2017 Akm. All rights reserved.
//

import XCTest
@testable import Feed
import Mantle

let timeout : TimeInterval = 300
class FeedTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRequestObject() {
        
        var expectation:XCTestExpectation? = self.expectation(description: "testRequestObject")
        
        let request = TestRequest.init(min_version: "", max_version: "", direction: "", count: 1)
        FD_RequestManager.sharedManager.sendRequest(request: request) { (result) in
            let testResult = result as! TestResult
            print(testResult)
            expectation?.fulfill()
            expectation = nil
        }
        
        self.waitForExpectations(timeout: timeout) { (error) in
            if error != nil {
                XCTFail(error.debugDescription)
            }
        }
        
    }
    
    func testSendRequestMerchantsWith() {
        
        var expectation:XCTestExpectation? = self.expectation(description: "testSendRequestMerchantsWith")
        
        
        let params = ["min_version":"-9223372036854775067",
                      "max_version":"-9223372036854775078",
                      "direction":"down",
                      "count":3] as [String : Any]
        
        let paramsDict = ["no_token":1,
                          "data":params] as [String : Any]
        FD_ConnectionManager.sharedManager.sendRequestWith(handlerString: "merchants", params: paramsDict) { (responseObject) in
            let merch = try! MTLJSONAdapter.models(of: Merchant.self, fromJSONArray: responseObject["list"] as! Array)
            print(merch)
            expectation?.fulfill()
            expectation = nil
        }
        
        
        self.waitForExpectations(timeout: timeout) { (error) in
            if error != nil {
                XCTFail(error.debugDescription)
            }
        }
    }
    
    func testSendRequestStoresWith() {
        
        var expectation:XCTestExpectation? = self.expectation(description: "testSendRequestStoresWith")
        
        
        let params = ["min_version":"-9223372036854775067",
                      "max_version":"-9223372036854775078",
                      "direction":"down",
                      "count":3] as [String : Any]
        
        let paramsDict = ["no_token":1,
                          "data":params] as [String : Any]
        FD_ConnectionManager.sharedManager.sendRequestWith(handlerString: "stores", params: paramsDict) { (responseObject) in
            let stores = try! MTLJSONAdapter.models(of: Store.self, fromJSONArray: responseObject["list"] as! Array)
            print(stores)
            expectation?.fulfill()
            expectation = nil
        }
        
        
        self.waitForExpectations(timeout: timeout) { (error) in
            if error != nil {
                XCTFail(error.debugDescription)
            }
        }
    }
    
    func testSendRequestCitiesWith() {
        
        var expectation:XCTestExpectation? = self.expectation(description: "testSendRequestCitiesWith")
        
        
        let params = ["min_version":"-9223372036854775067",
                      "max_version":"-9223372036854775078",
                      "direction":"down",
                      "count":3] as [String : Any]
        
        let paramsDict = ["no_token":1,
                          "data":params] as [String : Any]
        FD_ConnectionManager.sharedManager.sendRequestWith(handlerString: "cities", params: paramsDict) { (responseObject) in
            let stores = try! MTLJSONAdapter.models(of: City.self, fromJSONArray: responseObject["list"] as! Array)
            print(stores)
            expectation?.fulfill()
            expectation = nil
        }
        
        
        self.waitForExpectations(timeout: timeout) { (error) in
            if error != nil {
                XCTFail(error.debugDescription)
            }
        }
    }
}
