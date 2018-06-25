//
//  CustomMessageCell.swift
//  Flash Chat
//
//  Created by Angela Yu on 30/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
   
   @IBOutlet weak var movieImageView: UIImageView!
   @IBOutlet weak var informationContentView: UIView!
   @IBOutlet weak var movieDescription: UILabel!
   @IBOutlet weak var movieTitle: UILabel!
   @IBOutlet weak var movieNumber: UILabel!
   @IBOutlet weak var voteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code goes here
        CellSetup()
        
        
        }

    func CellSetup() {
        movieImageView.layer.cornerRadius = 15.0
    }

}
