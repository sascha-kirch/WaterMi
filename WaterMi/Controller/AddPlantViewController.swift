//
//  AddPlantViewController.swift
//  WaterMi
//
//  Created by Sascha on 21.10.20.
//

import UIKit

class AddPlantViewController: UIViewController , UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var inEditMode = false
    var selectedPlant: String?
    var selectedPlantImage: UIImage?
    var callingViewController : PlantsTableViewController?
    var imagePickerController : UIImagePickerController = UIImagePickerController()
    
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var plantNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Used to dissmiss keyboard, once touched otside the textfield
        self.hideKeyboardWhenTappedAround()
        self.plantNameTextField.delegate = self
        self.imagePickerController.delegate = self
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
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        if let viewController = callingViewController {
            viewController.Plants.append(Plant(name: plantNameTextField.text ?? "EMPTY NAME TEXTFIELD" , image:plantImageView.image!))
            viewController.tableView.reloadData()
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
}



