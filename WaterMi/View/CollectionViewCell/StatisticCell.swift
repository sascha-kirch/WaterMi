//
//  CollectionCell.swift
//  WaterMi
//
//  Created by Sascha on 27.10.20.
//

import UIKit

final class StatisticCell: UICollectionViewCell {
    
    @IBOutlet weak var statisticImageView: UIImageView!
    @IBOutlet weak var statisticDescription: UILabel!
    @IBOutlet weak var statisticContent: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var card: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayers()
    }
    
    fileprivate func setupLayers() {
        
        stackView.layer.cornerRadius = card.frame.size.height / 5 //rounden the card shape
        //Shoddow bellow Card
        stackView.layer.shadowOpacity = 0.75
        stackView.layer.shadowOffset = CGSize(width: 0, height: 2)
        stackView.layer.shadowRadius = 2.0
        stackView.layer.isGeometryFlipped = false
    }
}
