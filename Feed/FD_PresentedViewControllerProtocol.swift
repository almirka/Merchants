//
//  FD_PresentedViewControllerProtocol.swift
//  Feed
//
//  Created by akmalov on 24/06/2017.
//  Copyright © 2017 Akm. All rights reserved.
//

import Foundation


@objc protocol FD_PresentedViewControllerProtocol {
    
    func setupInitialState()
    @objc optional func showEmptyState()
    @objc optional func showFeedState(result : Array<Any>!)
    
}
