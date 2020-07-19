//
//  RepositoryTableViewCell.swift
//  Github Feed
//
//  Created by Beniamin Idziak on 13/07/2020.
//  Copyright © 2020 Beniamin Idziak. All rights reserved.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {

    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var licenseLabel: UILabel!
    @IBOutlet weak var updatedAtLabel: UILabel!
    
    func fillCell(with repository: Repository) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        repositoryNameLabel.text = repository.fullName
        descriptionLabel.text = repository.description ?? "-"
        languageLabel.text = repository.language ?? "-"
        licenseLabel.text = repository.license?.name ?? "No license"
        updatedAtLabel.text = "Updated on " + dateFormatter.string(from: repository.updatedAt)
    }
}
