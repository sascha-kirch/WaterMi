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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stackView.layer.cornerRadius = card.frame.size.height / 5 //rounden the card shape
        
        
        // crate round image View!!
        //plantImageView.layer.borderWidth = 1
        //plantImageView.layer.masksToBounds = false
        //plantImageView.layer.borderColor = UIColor.black.cgColor
        //plantImageView.layer.cornerRadius = plantImageView.frame.size.width/2 //Image needs to be rectangular in order to work!
        //plantImageView.clipsToBounds = true
        
        plantImageView.contentMode = UIView.ContentMode.scaleAspectFit
        plantImageView.frame.size.width = 80
        plantImageView.frame.size.height = 80
        plantImageView.layer.cornerRadius = 40
        plantImageView.clipsToBounds = true
        plantImageView.layer.borderWidth = 1
        plantImageView.layer.borderColor = UIColor.black.cgColor
        
        //4
        stackView.layer.shadowOpacity = 0.75
        stackView.layer.shadowOffset = CGSize(width: 0, height: 3)
        stackView.layer.shadowRadius = 3.0
        stackView.layer.isGeometryFlipped = false
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
