//
//  SettingViewController.swift
//  WaterMi
//
//  Created by Sascha on 21.10.20.
//

import UIKit

final class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }


}

//MARK: - Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI

extension SettingViewController: UIViewControllerRepresentable {
    
  func makeUIViewController(context: Context) -> SettingViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
      guard let viewController =  storyboard.instantiateViewController(
                identifier: WMConstant.StoryBoardID.SettingViewController) as? SettingViewController else {
          fatalError("Cannot load from storyboard")
      }
      // Configure the view controller here
      return viewController
  }

  func updateUIViewController(_ uiViewController: SettingViewController,
    context: Context) {
  }
}

struct SettingViewControllerPreviews: PreviewProvider {
  static var previews: some View {
    SettingViewController()
        .environment(\.colorScheme, .light)
        .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
        .previewDisplayName("iPhone 11")
    
    SettingViewController()
        .environment(\.colorScheme, .light)
        .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (2nd generation)"))
        .previewDisplayName("iPad Pro (11-inch) (2nd generation)")
    
    SettingViewController()
        .environment(\.colorScheme, .dark)
        .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
        .previewDisplayName("iPhone SE")
  }
}
#endif
