//
//  MainViewController.swift
//  MoviesApp
//
//  Created by Armin Spahic on 22/06/2018.
//  Copyright © 2018 Armin Spahic. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
   
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cellContentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellImageView?.layer.cornerRadius = 15.0
        }

}
