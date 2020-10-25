//
//  PlantCell.swift
//  WaterMi
//
//  Created by Sascha on 21.10.20.
//

import UIKit
import SwipeCellKit

class PlantCell : SwipeTableViewCell {
    
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var timeLeftLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stackView.layer.cornerRadius = card.frame.size.height / 5 //rounden the card shape
        
        timeLeftLabel.text = "23h"
        
        plantImageView.contentMode = UIView.ContentMode.scaleAspectFit
        plantImageView.layer.cornerRadius = plantImageView.frame.size.width/2 //Image needs to be rectangular in order to work
        plantImageView.clipsToBounds = true
        plantImageView.layer.borderWidth = 1
        plantImageView.layer.borderColor = UIColor.black.cgColor
        
        //Shoddow bellow Card
        stackView.layer.shadowOpacity = 0.75
        stackView.layer.shadowOffset = CGSize(width: 0, height: 2)
        stackView.layer.shadowRadius = 2.0
        stackView.layer.isGeometryFlipped = false
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
