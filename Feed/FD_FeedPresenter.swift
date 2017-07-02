//
//  FD_FeedPresenter.swift
//  Feed
//
//  Created by Almir Akmalov on 24.06.17.
//  Copyright © 2017 Akm. All rights reserved.
//

import Foundation

protocol FD_PresenterInput {
    func setupPresenter()
}

@objc final class FD_FeedPresenter : FD_BasePresenter, FD_PresenterInput {
    
    //MARK: FD_PresenterInput
    override func setupPresenter() {
        self.view.setupInitialState()
        (self.interactor as! FD_FeedInteractor).setupTable()
        self.interactor.giveParsedArray()
    }
    
    //MARK: FD_FeedInteractorOutput
    
    override func receivedBuildedData(result : Array<Any>!) {
        if result.count > 0 {
            self.view.showFeedState(result: result)
        } else {
            self.view.showEmptyState()
        }
    }
    
}
