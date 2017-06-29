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

@objc final class FD_FeedDetailPresenter : FD_BasePresenter, FD_FeedDetailPresenterInput, FD_FeedInteractorOutput {
    
    var dataArray : Array<Any>!
    
    
    //MARK: FD_PresenterInput
    override func setupPresenter() {
        self.view.showFeedState(result:dataArray)
    }
    
    
    
}
