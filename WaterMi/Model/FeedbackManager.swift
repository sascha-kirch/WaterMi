//
//  Feedback.swift
//  WaterMi
//
//  Created by Sascha on 27.10.20.
//

import UIKit
import MessageUI
import StoreKit

struct FeedbackManager {
    
    static func MakeReview(viewController:UIViewController) {
        print("Make Review")
        SKStoreReviewController.requestReview()
    }
    
    static func ShareApp(viewController:UIViewController) {
        // Setting description
            let firstActivityItem = "WaterMi - The Best App to keep track of your plant's health"

            // Setting url
            let secondActivityItem : NSURL = NSURL(string: "https://www.linkedin.com/in/sascha-kirch-3b282213b")!
            
            // If you want to use an image
            let image : UIImage = UIImage(named: "WaterMi")!
            let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [firstActivityItem, secondActivityItem, image], applicationActivities: nil)
            
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
            
            // Pre-configuring activity items
            activityViewController.activityItemsConfiguration = [
            UIActivity.ActivityType.message
            ] as? UIActivityItemsConfigurationReading
            
            // Anything you want to exclude
            activityViewController.excludedActivityTypes = [
                UIActivity.ActivityType.postToWeibo,
                UIActivity.ActivityType.print,
                UIActivity.ActivityType.assignToContact,
                UIActivity.ActivityType.saveToCameraRoll,
                UIActivity.ActivityType.addToReadingList,
                UIActivity.ActivityType.postToFlickr,
                UIActivity.ActivityType.postToVimeo,
                UIActivity.ActivityType.postToTencentWeibo
            ]
            
            activityViewController.isModalInPresentation = true
            viewController.present(activityViewController, animated: true, completion: nil)
    }
    
    static func ShareFacebook(viewController:UIViewController) {
        print("Share Facebook")
    }
    
    static func ContactDeveloper(viewController:UIViewController) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = viewController.self as? MFMailComposeViewControllerDelegate
            mail.setToRecipients(["susch130993@googlemail.com"])
            mail.setSubject("Feedback WaterMi")
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            
            viewController.present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    static func ShowGuide(viewController:UIViewController) {
        print("Show Guide")
    }
    
}
