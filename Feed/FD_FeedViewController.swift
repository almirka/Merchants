//
//  ViewController.swift
//  Feed
//
//  Created by Almir Akmalov on 24.06.17.
//  Copyright © 2017 Akm. All rights reserved.
//

import UIKit

private let reuseIdentifier = "FeedCellBase"//FeedCell

protocol FD_FeedViewInput {
    
    func setupInitialState()
    func showEmptyState()
    //func showFeedState(result : Array<FD_FeedItem>!)
    
}

final class FD_FeedViewController: FD_BaseViewController, FD_FeedViewInput, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var loadingView: UIView!
    @IBOutlet private var emptyView: UIView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    //private var feedArray : Array<FD_FeedItem>! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 80.0
        self.presenter.setupPresenter()
    }
    
    //MARK: FD_FeedViewInput
    
    override func setupInitialState() {
        self.view = self.loadingView
        self.activityIndicator.startAnimating()
    }
    
    override func showEmptyState() {
        self.view = self.emptyView
        self.activityIndicator.stopAnimating()
    }
    
    /*func showFeedState(result : Array<FD_FeedItem>!) {
        self.feedArray = result
        self.view = self.tableView
        self.activityIndicator.stopAnimating()
        self.tableView.reloadData()
    }*/
    
    //MARK: UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0//self.feedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //let feedItem = feedArray[indexPath.row]
        //cell.textLabel?.text = feedItem.feedTitle
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! FD_FeedDetailView
        let presenter = vc.presenter as! FD_FeedDetailPresenter
        let indexPath = sender as! IndexPath
        //presenter.dataArray = [feedArray[indexPath.row]]
        
    }
    
    
}

