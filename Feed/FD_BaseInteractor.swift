//
//  FD_BaseInteractor.swift
//  Feed
//
//  Created by akmalov on 24/06/2017.
//  Copyright © 2017 Akm. All rights reserved.
//

import Foundation

protocol FD_BaseInteractorInput {
    func giveParsedArray()
}


protocol FD_BaseInteractorOutput {
    //func recivedFeedItems(result : Array<FD_FeedItem>?)
}

@objc class FD_BaseInteractor : NSObject, FD_BaseInteractorInput {
    
    @IBOutlet weak var presenter: FD_BasePresenter!
    
    //MARK: FD_FeedInteractorInput
    
    func giveParsedArray() {
        
    }
    
}
