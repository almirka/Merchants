//
//  FD_FeedDetailView.swift
//  Feed
//
//  Created by akmalov on 24/06/2017.
//  Copyright © 2017 Akm. All rights reserved.
//

import UIKit

private let reuseIdentifier = "DetailCell"

protocol FD_FeedDetailViewInput {
    
    func setupInitialState()
    func showEmptyState()
    //func showFeedState(result : Array<FD_FeedItem>!)
    
}

final class FD_FeedDetailView: FD_BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private var tableView: UITableView!
    
    //var feedItem : FD_FeedItem!
    
    override func viewDidLoad() {
        self.tableView.rowHeight = 120
        
        self.presenter.setupPresenter()
    }
    
    override func showFeedState(result: Array<Any>!) {
        //self.feedItem = result[0] as! FD_FeedItem
        self.view = self.tableView
        self.tableView.reloadData()
    }
    
    //MARK :
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        /*
        let detailCell = cell as! FD_DetailCell
        if indexPath.row == 0 {
            detailCell.feedDescriptionLabel.text = self.feedItem.feedDescription
        } else {
            if self.feedItem.feedImageData != nil {
                detailCell.imageView?.image = UIImage.init(data: self.feedItem.feedImageData!)
            }
        }
        */
        
        
        
    }
}
