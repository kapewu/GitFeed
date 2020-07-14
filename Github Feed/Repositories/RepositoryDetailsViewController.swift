//
//  RepositoryDetailsViewController.swift
//  Github Feed
//
//  Created by Beniamin Idziak on 14/07/2020.
//  Copyright © 2020 Beniamin Idziak. All rights reserved.
//

import UIKit

class RepositoryDetailsViewController: UIViewController {
    
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var starsCountLabel: UILabel!
    @IBOutlet weak var forkCountLabel: UILabel!
    @IBOutlet weak var watchersCountLabel: UILabel!
    @IBOutlet weak var issuesCountLabel: UILabel!
    @IBOutlet weak var licenseLabel: UILabel!
    
    var item: Repository!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ownerNameLabel.text = item.owner.login
        repositoryNameLabel.text = item.name
        descriptionLabel.text = item.description ?? "-"
        starsCountLabel.text = item.stargazersCount == 1 ? "1 star" : "\(item.stargazersCount) stars"
        forkCountLabel.text = item.forksCount == 1 ? "1 fork" : "\(item.forksCount) forks"
        watchersCountLabel.text = item.forksCount == 1 ? "1 watcher" : "\(item.watchersCount) watchers"
        issuesCountLabel.text = item.openIssuesCount == 1 ? "1 issue" : "\(item.openIssuesCount) issues"
        licenseLabel.text = item.license?.name ?? "No license"
    }
}
