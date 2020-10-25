//
//  FeedbackViewController.swift
//  WaterMi
//
//  Created by Sascha on 23.10.20.
//

import UIKit

class FeedbackViewController: UITableViewController {
    
    var sectionHeaderTitles : [String] = []
    var rowLabels: [Int:[String]] = [:]
    var rowImages: [Int:[String]] = [:]
    
    @IBOutlet weak var feedbackTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register custom cell design!
        tableView.register(UINib(nibName: WMConstant.CustomCell.feedbackCellNibName, bundle: nil), forCellReuseIdentifier: WMConstant.CustomCell.feedbackCellIdentifier)
    }
    
    //MARK: - Actions
    
    
    //MARK: - datasource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaderTitles.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaderTitles[section]
    }
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowLabels[section]!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedbackTableView.dequeueReusableCell(withIdentifier: WMConstant.CustomCell.feedbackCellIdentifier, for: indexPath) as! FeedbackCell
        cell.feedbackCellLabel.text = rowLabels[indexPath.section]![indexPath.row]
        cell.feedbackCellImageView.image = UIImage(systemName: rowImages[indexPath.section]![indexPath.row])
        return cell
    }
    
    
}
