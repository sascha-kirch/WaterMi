//
//  AdCell.swift
//  WaterMi
//
//  Created by Sascha on 26.10.20.
//

import UIKit


class AdCell:UITableViewCell {
    
    
    @IBOutlet weak var card: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayers()
    }

    private func setupLayers() {
        
        card.layer.cornerRadius = card.frame.size.height / 5 //rounden the card shape
        
        //Shoddow bellow Card
        card.layer.shadowOpacity = 0.75
        card.layer.shadowOffset = CGSize(width: 0, height: 2)
        card.layer.shadowRadius = 2.0
        card.layer.isGeometryFlipped = false
    }
}
