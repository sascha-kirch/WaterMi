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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        card.layer.cornerRadius = card.frame.size.height / 5 //rounden the card shape
        
        // crate round image View!!
        plantImageView.layer.borderWidth = 1
        plantImageView.layer.masksToBounds = false
        plantImageView.layer.borderColor = UIColor.black.cgColor
        plantImageView.layer.cornerRadius = plantImageView.bounds.width/2
        plantImageView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}