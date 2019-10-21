//
//  ArtBookAddPageViewController.swift
//  All Packages
//
//  Created by Cengiz Baygın on 6.10.2019.
//  Copyright © 2019 Cengiz Baygın. All rights reserved.
//

import UIKit
import CoreData
class ArtBookAddPageViewController: UIViewController, UINavigationControllerDelegate , UIImagePickerControllerDelegate{
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var artBookImageView: UIImageView!
    // Variables
    var nameText = String()
    var commentText = String()
    var locationText = String()
    var imagePicker = UIImage()
    var chosenName = String()
    var chosenId : UUID?
    //    var idString = String()
    override func viewDidLoad() {
        super.viewDidLoad()
     
        artBookImageView.isUserInteractionEnabled = true
        let imagePickerGesture = UITapGestureRecognizer.init(target: self, action: #selector(imagePickerFunc))
        artBookImageView.addGestureRecognizer(imagePickerGesture)
        let hideKeyboard = UITapGestureRecognizer.init(target: self, action: #selector(hideKeyboardFunc))
        view.addGestureRecognizer(hideKeyboard)
        if chosenName != "" {
            allObjectsClose()
            getValues()
            print("Veri çekiliyor")
        }else{
            allObjectsOpen()
            print("Veri çekilemiyor.")
        }
    }
    // hide Keyboard Funcs
    @objc func hideKeyboardFunc () {
        view.endEditing(true)
    }
    // imagePicker Funcs
    @objc func imagePickerFunc(){
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        artBookImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    // Objects Funcs & Objects
    func getValues(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appContext = appDelegate.persistentContainer.viewContext
        let appFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ArtBookDB")
        let idString = chosenId?.uuidString
        appFetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
        appFetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchResults = try appContext.fetch(appFetchRequest)
            if fetchResults.count > 0 {
                for fetchResultsArray in fetchResults as! [NSManagedObject]{
                    if let nameData = fetchResultsArray.value(forKey: "name") as? String{
                        if let commentData = fetchResultsArray.value(forKey: "comment") as? String {
                            if let locationData = fetchResultsArray.value(forKey: "location") as? String{
                                if let imageData = fetchResultsArray.value(forKey: "image") as? Data{
                                    commentTextField.text = commentData
                                    nameTextField.text = nameData
                                    locationTextField.text = locationData
                                    artBookImageView.image = UIImage.init(data: imageData)
                                }// image endline
                            } // location endline
                        }// comment endline
                    }// namedata endline
                }// for loop endline
            }
        } catch  {
            print("Error!")
        }
    }
    @IBAction func saveButtonClicked(_ sender: Any) {
        if commentTextField.text != "" && locationTextField.text != "" && nameTextField.text != "" {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let appContext = appDelegate.persistentContainer.viewContext
            let newArt = NSEntityDescription.insertNewObject(forEntityName: "ArtBookDB", into: appContext)
            newArt.setValue(nameTextField.text, forKey: "name")
            newArt.setValue(commentTextField.text, forKey: "comment")
            newArt.setValue(locationTextField.text, forKey: "location")
            newArt.setValue(UUID(), forKey: "id")
            let imageData = artBookImageView.image?.jpegData(compressionQuality: 0.5)
            newArt.setValue(imageData, forKey: "image")
            do {
                try appContext.save()
            } catch  {
                print("Error!")
            }
            NotificationCenter.default.post(name: NSNotification.Name.init("newArt"), object: nil)
            navigationController?.popViewController(animated: true)
            // bitis
        }else{
            let alertMessage = UIAlertController.init(title: "Empty Fields!", message:"Fill Field And Try Again !", preferredStyle: UIAlertController.Style.alert)
            let alertMessageOkButton = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alertMessage.addAction(alertMessageOkButton)
            self.present(alertMessage, animated: true, completion: nil)
        }
    }
    @IBAction func artBookClickedButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func travelBookButtonClicked(_ sender: Any) {
    }
    @IBAction func simpsonBookButtonClicked(_ sender: Any) {
    }
    @IBAction func gameButtonClicked(_ sender: Any) {
    }
    func allObjectsOpen(){
        locationTextField.isEnabled = true
        nameTextField.isEnabled = true
        commentTextField.isEnabled = true
        artBookImageView.isUserInteractionEnabled = true
        saveButton.isHidden = false
    }
    func allObjectsClose(){
        locationTextField.isEnabled = false
        nameTextField.isEnabled = false
        commentTextField.isEnabled = false
        artBookImageView.isUserInteractionEnabled = false
        saveButton.isHidden = true
    }
}
