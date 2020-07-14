//
//  FeedCollectionViewCell.swift
//  Github Feed
//
//  Created by Beniamin Idziak on 12/07/2020.
//  Copyright © 2020 Beniamin Idziak. All rights reserved.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var feedDataLabel: UILabel!
    
    
    func fillCell(with event: GithubEvent) {
        
        timeLabel.text = event.readableDate
        feedDataLabel.attributedText = event.eventDescription
    }

}
