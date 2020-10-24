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
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
