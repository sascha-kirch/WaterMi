//
//  AddPlantViewController.swift
//  WaterMi
//
//  Created by Sascha on 21.10.20.
//

import UIKit

final class AddPlantViewController: UIViewController , UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var inEditMode = false
    var selectedPlant: String?
    var selectedPlantImage: UIImage?
    var callingViewController : PlantsTableViewController?
    var imagePickerController : UIImagePickerController = UIImagePickerController()
    let intervallData = ["Dayly","Weekly","Monthly"]
    
    let plantDatabaseManger = PlantDatabaseManager()
    
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var plantNameTextField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var intervallPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Used to dissmiss keyboard, once touched otside the textfield
        self.hideKeyboardWhenTappedAround()
        self.plantNameTextField.delegate = self
        self.imagePickerController.delegate = self
        intervallPickerView.delegate = self
        intervallPickerView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if inEditMode {
            self.plantNameTextField.text = selectedPlant
            self.plantImageView.image = selectedPlantImage
        }
        
        // crate round image View!!
        plantImageView.layer.borderWidth = 1
        plantImageView.layer.masksToBounds = false
        plantImageView.layer.borderColor = UIColor.black.cgColor
        plantImageView.layer.cornerRadius = plantImageView.frame.size.width/2
        plantImageView.clipsToBounds = true
        
        self.imagePickerController.allowsEditing = true
    }
    
    //MARK: - Buttons
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        if let viewController = callingViewController {
            
            let newPlant = plantDatabaseManger.addNewPlantToContext(plantName: plantNameTextField.text, plantImage: plantImageView.image)
            viewController.Plants.append(newPlant)
            callingViewController?.tableView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - UITextFieldDelegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //MARK: - Camera Functions
    @IBAction func changePhotoButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add new photo", message: "", preferredStyle: .alert)
        
        let cameraAction = UIAlertAction(title: "Take photo", style: .default) { (action) in
            // What will happen once, user clicks the add Item button in the alert!
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        
        let libraryAction = UIAlertAction(title: "Take from library", style: .default) { (action) in
            // What will happen once, user clicks the add Item button in the alert!
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // What will happen once, user clicks the add Item button in the alert! 
        }
        
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        plantImageView.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - PickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch(pickerView){
        case intervallPickerView:
            return intervallData.count
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch(pickerView){
        case intervallPickerView:
            return intervallData[row]
        default: return nil
        }
    }
}

//MARK: - Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI

extension AddPlantViewController: UIViewControllerRepresentable {
    
  func makeUIViewController(context: Context) -> AddPlantViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
      guard let viewController =  storyboard.instantiateViewController(
                identifier: WMConstant.StoryBoardID.AddPlantViewController) as? AddPlantViewController else {
          fatalError("Cannot load from storyboard")
      }
      // Configure the view controller here
      return viewController
  }

  func updateUIViewController(_ uiViewController: AddPlantViewController,
    context: Context) {
  }
}

struct AddPlantViewControllerPreviews: PreviewProvider {
  static var previews: some View {
    AddPlantViewController()
        .environment(\.colorScheme, .light)
        .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
        .previewDisplayName("iPhone 11")
    
    AddPlantViewController()
        .environment(\.colorScheme, .light)
        .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (2nd generation)"))
        .previewDisplayName("iPad Pro (11-inch) (2nd generation)")
    
    AddPlantViewController()
        .environment(\.colorScheme, .dark)
        .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
        .previewDisplayName("iPhone SE")
  }
}
#endif
