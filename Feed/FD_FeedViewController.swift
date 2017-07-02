//
//  ViewController.swift
//  Feed
//
//  Created by Almir Akmalov on 24.06.17.
//  Copyright © 2017 Akm. All rights reserved.
//

import UIKit

private let reuseIdentifier = "FeedCellBase"//FeedCell

final class FD_FeedViewController: FD_BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var loadingView: UIView!
    @IBOutlet private var emptyView: UIView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var feedArray :  Array<Any>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 80.0
        self.presenter.setupPresenter()
    }
    
    //MARK: FD_FeedViewInput
    
    override func setupInitialState() {
        self.loadingView.isHidden = false
        self.emptyView.isHidden = true
        self.tableView.isHidden = true
        self.activityIndicator.startAnimating()
    }
    
    override func showEmptyState() {
        self.loadingView.isHidden = true
        self.emptyView.isHidden = false
        self.tableView.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
    override func showFeedState(result :  Array<Any>!) {
        self.feedArray = result as! Array<Merchant>
        self.loadingView.isHidden = true
        self.emptyView.isHidden = true
        self.tableView.isHidden = false
        self.activityIndicator.stopAnimating()
        self.tableView.reloadData()
    }
    
    //MARK: UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        if self.feedArray != nil {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = nil
        cell.imageView?.image = nil
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let merchant = self.feedArray[indexPath.row] as! Merchant
        cell.textLabel?.text = merchant.name
        if merchant.logoData != nil {
            cell.imageView?.image = UIImage.init(data:merchant.logoData!)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowDetail", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! FD_FeedDetailView
        let presenter = vc.presenter as! FD_FeedDetailPresenter
        let indexPath = sender as! IndexPath
        let merchant = self.feedArray[indexPath.row] as! Merchant
        presenter.merchant = merchant
        
    }
    
    
}

