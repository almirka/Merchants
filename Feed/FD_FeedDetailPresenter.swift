//
//  FD_FeedDetailPresenter.swift
//  Feed
//
//  Created by akmalov on 24/06/2017.
//  Copyright © 2017 Akm. All rights reserved.
//

import Foundation

protocol FD_FeedDetailPresenterInput {
    func setupPresenter()
}

@objc final class FD_FeedDetailPresenter : FD_BasePresenter, FD_FeedDetailPresenterInput {
    
    var merchant : Merchant!
    
    //MARK: FD_PresenterInput
    override func setupPresenter() {
        self.view.setupInitialState()
        let interactor = self.interactor as! FD_FeedDetailInteractor
        interactor.merchant = self.merchant
        interactor.giveParsedArray()
    }
    
    override func receivedBuildedData(result : Array<Any>!) {
        if result.count > 0 {
            self.view.showFeedState(result: result)
        } else {
            self.view.showEmptyState()
        }
    }
    
    
}
