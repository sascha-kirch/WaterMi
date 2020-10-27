//
//  MoreViewController.swift
//  WaterMi
//
//  Created by Sascha on 23.10.20.
//

import UIKit
import GoogleMobileAds

class MoreViewController: UIViewController , GADUnifiedNativeAdLoaderDelegate {

    var adLoader: GADAdLoader!
    /// The native ad view that is being presented.
     var nativeAdView: GADUnifiedNativeAdView!
    
    @IBOutlet weak var nativeAdViewPlaceholder: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let multipleAdsOptions = GADMultipleAdsAdLoaderOptions()
            multipleAdsOptions.numberOfAds = 5

            adLoader = GADAdLoader(adUnitID: "ca-app-pub-3940256099942544/3986624511", rootViewController: self,
                                   adTypes: [GADAdLoaderAdType.unifiedNative],
                options: [multipleAdsOptions])
            adLoader.delegate = self
            adLoader.load(GADRequest())
    }
    
    //MARK: - Feedback Related Methods
    
    
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

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: .none))

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
                    1:["Tell your friends about WaterMi"]
                ]
                destinationVC.rowActions = [
                    0:[FeedbackManager.MakeReview, FeedbackManager.ContactDeveloper],
                    1:[FeedbackManager.ShareApp]
                ]
                destinationVC.rowImages = [
                    0:["star","envelope"],
                    1:["square.and.arrow.up"]
                ]
                destinationVC.feedbackIndicator = .happy
            
            case .confused:
                destinationVC.sectionHeaderTitles = ["Section 1"]
                destinationVC.rowLabels = [
                    0:["Getting Started Guide","Contact the WaterMi Team"]
                ]
                destinationVC.rowActions = [
                    0:[FeedbackManager.ShowGuide, FeedbackManager.ContactDeveloper]
                ]
                destinationVC.rowImages = [
                    0:["person.fill.questionmark","envelope"]
                ]
                destinationVC.feedbackIndicator = .confused
            
            case .unhappy:
                destinationVC.sectionHeaderTitles = ["Section 1"]
                destinationVC.rowLabels = [
                    0:["Contact the WaterMi Team"]
                ]
                destinationVC.rowActions = [
                    0:[FeedbackManager.ContactDeveloper]
                ]
                destinationVC.rowImages = [
                    0:["envelope"]
                ]
                destinationVC.feedbackIndicator = .unhappy
            
            default:
                print("default")
            }
        }
    }
    
    //MARK: - Add Loader (Google Adds Functions)

    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
      print("Received unified native ad: \(nativeAd)")
      //refreshAdButton.isEnabled = true
      // Create and place ad in view hierarchy.
      let nibView = Bundle.main.loadNibNamed("UnifiedNativeAdView", owner: nil, options: nil)?.first
      guard let nativeAdView = nibView as? GADUnifiedNativeAdView else {
        return
      }
      setAdView(nativeAdView)

      // Set the mediaContent on the GADMediaView to populate it with available
      // video/image asset.
      nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent

      // Populate the native ad view with the native ad assets.
      // The headline is guaranteed to be present in every native ad.
      (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline

      // These assets are not guaranteed to be present. Check that they are before
      // showing or hiding them.
      (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
      nativeAdView.bodyView?.isHidden = nativeAd.body == nil

      (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
      nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil

      (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
      nativeAdView.iconView?.isHidden = nativeAd.icon == nil

      

      (nativeAdView.storeView as? UILabel)?.text = nativeAd.store
      nativeAdView.storeView?.isHidden = nativeAd.store == nil

      (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
      nativeAdView.priceView?.isHidden = nativeAd.price == nil

      (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
      nativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil

      // In order for the SDK to process touch events properly, user interaction
      // should be disabled.
      nativeAdView.callToActionView?.isUserInteractionEnabled = false

      // Associate the native ad view with the native ad object. This is
      // required to make the ad clickable.
      // Note: this should always be done after populating the ad views.
      nativeAdView.nativeAd = nativeAd
    }

      func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
          // The adLoader has finished loading ads, and a new request can be sent.
        print("AddLoader has finished Loading")
      }
    
    public func adLoader(_ adLoader: GADAdLoader,
                         didFailToReceiveAdWithError error: GADRequestError){
        //Handling failed requests
        print("Addloader Failed to recieve!")
    }
    
    func setAdView(_ view: GADUnifiedNativeAdView) {
        // Remove the previous ad view.
        nativeAdView = view
        nativeAdViewPlaceholder.addSubview(nativeAdView)
        nativeAdView.translatesAutoresizingMaskIntoConstraints = false

        // Layout constraints for positioning the native ad view to stretch the entire width and height
        // of the nativeAdPlaceholder.
        let viewDictionary = ["_nativeAdView": nativeAdView!]
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[_nativeAdView]|",
                                                                options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[_nativeAdView]|",
                                                                options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
      }
    
    
    //MARK: - Native Adds (Google Adds Functions)
    
    func nativeAdDidRecordClick(_ nativeAd: GADUnifiedNativeAd) {
       print("\(#function) called")
     }

     func nativeAdDidRecordImpression(_ nativeAd: GADUnifiedNativeAd) {
       print("\(#function) called")
     }

     func nativeAdWillPresentScreen(_ nativeAd: GADUnifiedNativeAd) {
       print("\(#function) called")
     }

     func nativeAdWillDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
       print("\(#function) called")
     }

     func nativeAdDidDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
       print("\(#function) called")
     }

     func nativeAdWillLeaveApplication(_ nativeAd: GADUnifiedNativeAd) {
       print("\(#function) called")
     }
}


