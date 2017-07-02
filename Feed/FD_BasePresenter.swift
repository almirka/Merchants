//
//  FD_BasePresenter.swift
//  Feed
//
//  Created by akmalov on 24/06/2017.
//  Copyright © 2017 Akm. All rights reserved.
//

import UIKit

protocol FD_BasePresenterInput {
    func setupPresenter()
}

@objc class FD_BasePresenter : NSObject, FD_BasePresenterInput, FD_BaseInteractorOutput {
    
    @IBOutlet weak var view: FD_BaseViewController!
    @IBOutlet weak var interactor: FD_BaseInteractor!
    
    //MARK: FD_PresenterInput
    func setupPresenter() {
        
    }
    
    //MARK: FD_FeedInteractorOutput
    
    func receivedBuildedData(result : Array<Any>!) {
        
    }
    
}
