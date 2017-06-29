//
//  FD_BaseViewController.swift
//  Feed
//
//  Created by akmalov on 24/06/2017.
//  Copyright © 2017 Akm. All rights reserved.
//

import UIKit

@objc class FD_BaseViewController : UIViewController, FD_PresentedViewControllerProtocol {
    
    @IBOutlet var presenter: FD_BasePresenter!
    
    func setupInitialState() {
        
    }
    func showEmptyState() {
        
    }
    func showFeedState(result : Array<Any>!) {
        
    }
    
}
