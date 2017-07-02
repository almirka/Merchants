//
//  FD_FeedDetailView.swift
//  Feed
//
//  Created by akmalov on 24/06/2017.
//  Copyright © 2017 Akm. All rights reserved.
//

import UIKit

private let reuseIdentifier = "DetailCell"

final class FD_FeedDetailView: FD_BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet private weak var emptyView: UIView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    //
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var merchantLogo: UIImageView!
    @IBOutlet private weak var merchantName: UILabel!
    @IBOutlet private weak var merchantDescription: UILabel!
    
    
    var storesArray : Array<Store>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 60
        
        self.presenter.setupPresenter()
    }
    
    override func setupInitialState() {
        self.loadingView.isHidden = false
        self.headerView.isHidden = true
        self.emptyView.isHidden = true
        self.tableView.isHidden = true
        self.activityIndicator.startAnimating()
    }
    
    override func showEmptyState() {
        self.loadingView.isHidden = true
        self.headerView.isHidden = true
        self.emptyView.isHidden = false
        self.tableView.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
    override func showFeedState(result: Array<Any>!) {
        self.storesArray = result as! Array<Store>
        self.loadingView.isHidden = true
        self.emptyView.isHidden = true
        self.headerView.isHidden = false
        self.tableView.isHidden = false
        self.activityIndicator.stopAnimating()
        let imageData = self.storesArray.first?.merchant?.logoData
        if imageData != nil {
            self.merchantLogo.image = UIImage.init(data:imageData!)
        }
        self.merchantName.text = self.storesArray.first?.merchant?.name
        self.merchantDescription.text = self.storesArray.first?.merchant?.merchantDescription
        self.tableView.reloadData()
    }
    
    //MARK :
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.storesArray != nil {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.storesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let detailCell = cell as! FD_DetailCell
        let store = self.storesArray[indexPath.row]
        detailCell.addressLabel.text = store.address
        detailCell.cityLabel.text = store.cityName
        
    }
    
}
