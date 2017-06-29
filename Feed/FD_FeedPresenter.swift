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

@objc final class FD_FeedPresenter : FD_BasePresenter, FD_PresenterInput, FD_FeedInteractorOutput {
    
    //MARK: FD_PresenterInput
    override func setupPresenter() {
        self.view.setupInitialState()
        (self.interactor as! FD_FeedInteractor).setupTable()
        self.interactor.giveParsedArray()
    }
    
    //MARK: FD_FeedInteractorOutput
    
    /*func recivedFeedItems(result : Array<FD_FeedItem>?) {
        if result != nil {
            self.view.showFeedState(result: result)
        } else {
            self.view.showEmptyState()
        }
    }*/
    
}
