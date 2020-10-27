//
//  FeedbackViewController.swift
//  WaterMi
//
//  Created by Sascha on 23.10.20.
//

import UIKit
import MessageUI

final class FeedbackViewController: UITableViewController{
    
    var sectionHeaderTitles : [String] = []
    var rowLabels: [Int:[String]] = [:]
    var rowImages: [Int:[String]] = [:]
    //Dictionary of int as key and methods with zero inputs and void as return value as value
    var rowActions: [Int:[((UIViewController) -> Void)]] = [:]
    var feedbackIndicator: EfeedbackIndicator = .none
    
    @IBOutlet weak var feedbackTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedbackTableView.dataSource = self
        feedbackTableView.delegate = self
        
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


//MARK: - Table Cell Delegates

/**Defines what happens, when item has been selected*/
override func tableView(_ tableView: UITableView,
                        didSelectRowAt indexPath: IndexPath) {
    
    //executes the method provided in the dictionary of methods!!!
    rowActions[indexPath.section]![indexPath.row](self)
    tableView.deselectRow(at: indexPath, animated: true)
}
}

//MARK: - Mail Support

extension FeedbackViewController: MFMailComposeViewControllerDelegate  {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

//MARK: - Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI

extension FeedbackViewController: UIViewControllerRepresentable {
    
  func makeUIViewController(context: Context) -> FeedbackViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
      guard let viewController =  storyboard.instantiateViewController(
                identifier: WMConstant.StoryBoardID.FeedbackViewController) as? FeedbackViewController else {
          fatalError("Cannot load from storyboard")
      }
      // Configure the view controller here
    viewController.sectionHeaderTitles = ["Section 1", "TELL YOUR FRIENDS"]
    viewController.rowLabels = [
        0:["Write a Review","Contact the WaterMi Team"],
        1:["Tweet about WaterMi","Tell your friends in Facebook"]
    ]
    viewController.rowImages = [
        0:["star","envelope"],
        1:["t.circle","f.circle"]
    ]
      return viewController
  }

  func updateUIViewController(_ uiViewController: FeedbackViewController,
    context: Context) {
  }
}

struct FeedbackViewControllerPreviews: PreviewProvider {
  static var previews: some View {
    FeedbackViewController()
        .environment(\.colorScheme, .light)
        .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
        .previewDisplayName("iPhone 11")
    
    FeedbackViewController()
        .environment(\.colorScheme, .light)
        .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (2nd generation)"))
        .previewDisplayName("iPad Pro (11-inch) (2nd generation)")
    
    FeedbackViewController()
        .environment(\.colorScheme, .dark)
        .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
        .previewDisplayName("iPhone SE")
  }
}
#endif
