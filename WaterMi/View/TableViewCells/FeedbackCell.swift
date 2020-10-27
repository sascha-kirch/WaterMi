//
//  FeedbackCell.swift
//  WaterMi
//
//  Created by Sascha on 24.10.20.
//

import UIKit

class FeedbackCell : UITableViewCell  {
    
    
    @IBOutlet weak var feedbackCellImageView: UIImageView!
    @IBOutlet weak var feedbackCellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
