//
//  UserViewController.swift
//  WaterMi
//
//  Created by Sascha on 21.10.20.
//

import UIKit

final class StatisticsCollectionViewController: UICollectionViewController {

    @IBOutlet var statisticCollectionView: UICollectionView!
    var statistic:[StatisticFormat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statisticCollectionView.dataSource = self
        statisticCollectionView.delegate = self

        //register custom cell design!
        collectionView.register(UINib.init(nibName: WMConstant.CustomCell.statisticCellNibName, bundle: nil), forCellWithReuseIdentifier: WMConstant.CustomCell.statisticCellIdentifier)
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        statistic = DatabaseManager.getStatistics(statisticTypes: [.timesWatered, .numberOfPlants])
        //statistic.append(contentsOf: DatabaseManager.getStatistics(for: testPlant, statisticTypes: [.timesWatered]))
        collectionView.reloadData()
    }
    
    fileprivate func configure() {
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
    }
    
    //MARK: - Collectionview Data Source
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WMConstant.CustomCell.statisticCellIdentifier, for: indexPath) as! StatisticCell
        cell.statisticImageView.image = UIImage(systemName: "leaf")
        cell.statisticDescription.text = statistic[indexPath.row].name
        cell.statisticContent.text = String(statistic[indexPath.row].value)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statistic.count
    }
    

    
}

//MARK: - Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI

extension StatisticsCollectionViewController: UIViewControllerRepresentable {
    
  func makeUIViewController(context: Context) -> StatisticsCollectionViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
      guard let viewController =  storyboard.instantiateViewController(
                identifier: WMConstant.StoryBoardID.StatisticsCollectionViewController) as? StatisticsCollectionViewController else {
          fatalError("Cannot load from storyboard")
      }
      // Configure the view controller here
      return viewController
  }

  func updateUIViewController(_ uiViewController: StatisticsCollectionViewController,
    context: Context) {
  }
}

struct StatisticCollectionViewPreviews: PreviewProvider {
  static var previews: some View {
    StatisticsCollectionViewController()
        .environment(\.colorScheme, .light)
        .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
        .previewDisplayName("iPhone 11")
    
    StatisticsCollectionViewController()
        .environment(\.colorScheme, .light)
        .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (2nd generation)"))
        .previewDisplayName("iPad Pro (11-inch) (2nd generation)")
    
    StatisticsCollectionViewController()
        .environment(\.colorScheme, .dark)
        .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
        .previewDisplayName("iPhone SE")
  }
}
#endif
