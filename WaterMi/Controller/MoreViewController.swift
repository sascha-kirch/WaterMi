//
//  MoreViewController.swift
//  WaterMi
//
//  Created by Sascha on 23.10.20.
//

import UIKit

class MoreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    enum EfeedbackIndicator {
        case happy
        case confused
        case unhappy
        case none
    }
    var feedbackIndicator : EfeedbackIndicator = .none
    
    @IBAction func askForFeedbackButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Hi User!", message: "How do you feel about WaterMi?", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Happy", style: .default, handler: { (_) in
                    self.feedbackIndicator = .happy
                    self.performSegue(withIdentifier: WMConstant.SegueID.feedbackViewController, sender: self)
                }))

                alert.addAction(UIAlertAction(title: "Confused", style: .default, handler: { (_) in
                    self.feedbackIndicator = .confused
                    self.performSegue(withIdentifier: WMConstant.SegueID.feedbackViewController, sender: self)
                }))

        alert.addAction(UIAlertAction(title: "Unhappy", style: .default, handler: { (_) in
            self.feedbackIndicator = .unhappy
            self.performSegue(withIdentifier: WMConstant.SegueID.feedbackViewController, sender: self)
                }))

                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                    self.performSegue(withIdentifier: WMConstant.SegueID.feedbackViewController, sender: self)
                }))

        self.present(alert, animated: true, completion: .none)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Only executed for the transition to the detail View!
        if let destinationVC = segue.destination as? FeedbackViewController {
            switch feedbackIndicator {
            case .happy:
                destinationVC.sectionHeaderTitles = ["Section 1", "TELL YOUR FRIENDS"]
                destinationVC.rowLabels = [
                    0:["Write a Review","Contact the WaterMi Team"],
                    1:["Tweet about WaterMi","Tell your friends about WaterMi"]
                ]
                destinationVC.rowImages = [
                    0:["star","envelope"],
                    1:["t.circle","f.circle"]
                ]
            
            case .confused:
                destinationVC.sectionHeaderTitles = ["Section 1"]
                destinationVC.rowLabels = [
                    0:["Getting Started Guide","Contact the WaterMi Team"]
                ]
                destinationVC.rowImages = [
                    0:["person.fill.questionmark","envelope"]
                ]
            
            case .unhappy:
                destinationVC.sectionHeaderTitles = ["Section 1"]
                destinationVC.rowLabels = [
                    0:["Contact the WaterMi Team"]
                ]
                destinationVC.rowImages = [
                    0:["envelope"]
                ]
            
            default:
                print("default")
            }
        }
    }
}
