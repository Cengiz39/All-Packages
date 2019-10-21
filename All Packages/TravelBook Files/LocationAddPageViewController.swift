//
//  LocationAddPageViewController.swift
//  All Packages
//
//  Created by Cengiz Baygın on 8.10.2019.
//  Copyright © 2019 Cengiz Baygın. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation
class LocationAddPageViewController: UIViewController , UINavigationControllerDelegate , MKMapViewDelegate , CLLocationManagerDelegate {
    // Objects
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var locationNameTextField: UITextField!
    @IBOutlet weak var locationTitleTextField: UITextField!
    @IBOutlet weak var locationCommentTextField: UITextField!
    // Variables & Arrays
    let LocationManager = CLLocationManager()
    var userTitle = String()
    var userSubtitle = String()
    var userNameText = String()
    var userLongitude = Double()
    var userLatitude = Double()
    var pinCounter = Int()
    // getValue Variables
    var chosenName = String()
    var chosenId : UUID?
    override func viewDidLoad() {
        super.viewDidLoad()
        let hideKeyboardGesture = UITapGestureRecognizer.init(target: self, action: #selector(hideKeyboardFunc))
        view.addGestureRecognizer(hideKeyboardGesture)
        mapView.delegate = self
        LocationManager.delegate = self
        LocationManager.desiredAccuracy = kCLLocationAccuracyBest
        LocationManager.requestWhenInUseAuthorization()
        LocationManager.startUpdatingLocation()
        mapView.isUserInteractionEnabled = true
        let setAnnotationGesture = UILongPressGestureRecognizer.init(target: self, action: #selector(setPinFunc(gestureRecognizer:)))
        setAnnotationGesture.minimumPressDuration = 1.5
        mapView.addGestureRecognizer(setAnnotationGesture)
        if chosenName != "" {
         getValuesFunc()
            allOBjectsClose()
        }else {
            allOBjectsOpen()
        }
    }
    @objc func hideKeyboardFunc () {
           view.endEditing(true)
       }
    @objc func getValuesFunc(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appContext = appDelegate.persistentContainer.viewContext
        let appFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LocationsDB")
        var idString = chosenId?.uuidString
        appFetchRequest.predicate = NSPredicate.init(format: "id = %@", idString!)
        appFetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchResults = try appContext.fetch(appFetchRequest)
            if fetchResults.count > 0 {
                for ResultsArray in fetchResults as! [NSManagedObject]{
                    if let dataLongitude = ResultsArray.value(forKey: "longitude") as? Double{
                        if let dataLatitude = ResultsArray.value(forKey: "latitude") as? Double{
                            if let dataTitle = ResultsArray.value(forKey: "title")as? String{
                                if let dataSubTitle = ResultsArray.value(forKey: "subtitle") as? String{
                                    let dataPointAnnotation = MKPointAnnotation()
                                    locationNameTextField.text = chosenName
                                    locationTitleTextField.text = dataTitle
                                    locationCommentTextField.text = dataSubTitle
                                    dataPointAnnotation.title = dataTitle
                                    dataPointAnnotation.subtitle = dataSubTitle
                                    dataPointAnnotation.coordinate.longitude = dataLongitude
                                    dataPointAnnotation.coordinate.latitude = dataLatitude
                                    let coordinate = CLLocationCoordinate2D(latitude: dataLatitude, longitude: dataLongitude)
                                    dataPointAnnotation.coordinate = coordinate
                                    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                    let region = MKCoordinateRegion(center: coordinate, span: span)
                                    mapView.setRegion(region, animated: true)
                                    mapView.addAnnotation(dataPointAnnotation)
                                    LocationManager.stopUpdatingLocation()
                                }// data subtitle endline
                            }// datatitle endline
                        }// latitude endline
                    }// longitude endline
                }// for loop endline
            }
        } catch  {
            
        }
    } // Getvalues Endline
    // Map Annotation Func
    @objc func setPinFunc(gestureRecognizer : UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began {
            if locationNameTextField.text != "" && locationCommentTextField.text != "" && locationTitleTextField.text != "" && pinCounter == 0 {
                let mapAnnotation = MKPointAnnotation()
                let touchedPoint = gestureRecognizer.location(in: mapView)
                let touchedCoordinate = mapView.convert(touchedPoint, toCoordinateFrom: mapView)
                userTitle = locationTitleTextField.text!
                userSubtitle = locationCommentTextField.text!
                userNameText = locationNameTextField.text!
                mapAnnotation.title = userTitle
                mapAnnotation.subtitle = userSubtitle
                mapAnnotation.coordinate = touchedCoordinate
                userLongitude = touchedCoordinate.longitude
                userLatitude = touchedCoordinate.latitude
                mapView.addAnnotation(mapAnnotation)
                pinCounter = pinCounter + 1
            }else{
                let alertMessage = UIAlertController.init(title: "Empty Fields!", message:"Fill Field And Try Again !", preferredStyle: UIAlertController.Style.alert)
                let alertMessageOkButton = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alertMessage.addAction(alertMessageOkButton)
                self.present(alertMessage, animated: true, completion: nil)
            }
        }
    }
    // Update Locations Func
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let UserLocation = CLLocationCoordinate2D.init(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let mapSpan = MKCoordinateSpan.init(latitudeDelta: 0.003, longitudeDelta: 0.003)
        let mapRegion = MKCoordinateRegion.init(center: UserLocation, span: mapSpan)
        mapView.setRegion(mapRegion, animated: true)
    }
    @IBAction func saveButtonClicked(_ sender: Any) {
        if locationTitleTextField.text != "" && locationCommentTextField.text != "" && locationNameTextField.text != "" && pinCounter > 0 {
            saveData()
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "newLocation"), object: self)
            navigationController?.popViewController(animated: true)
        }else{
            let failSaveMessage = UIAlertController.init(title: "Empty Fields!", message:"Fill Field And Try Again !", preferredStyle: UIAlertController.Style.alert)
            let alertMessageOkButton = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            failSaveMessage.addAction(alertMessageOkButton)
            self.present(failSaveMessage, animated: true, completion: nil)
        }
    }
    func saveData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appContext = appDelegate.persistentContainer.viewContext
        let newLocation = NSEntityDescription.insertNewObject(forEntityName: "LocationsDB", into: appContext)
        newLocation.setValue(locationNameTextField.text, forKey: "name")
        newLocation.setValue(locationTitleTextField.text, forKey: "title")
        newLocation.setValue(locationCommentTextField.text, forKey: "subtitle")
        newLocation.setValue(userLongitude, forKey: "longitude")
        newLocation.setValue(userLatitude, forKey: "latitude")
        newLocation.setValue(UUID(), forKey: "id")
        do {
            try appContext.save()
        } catch  {
            print("Error!")
        }
        
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "myAnnotation"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.tintColor = UIColor.black
            
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            
        } else {
            pinView?.annotation = annotation
        }
        
        
        
        return pinView
    }
    // Driving
    
    // GPS
    func allOBjectsClose(){
        saveButton.isEnabled = false
        locationCommentTextField.isEnabled = false
        locationTitleTextField.isEnabled = false
        locationNameTextField.isEnabled = false
        pinCounter = pinCounter + 1
    }
    func allOBjectsOpen(){
        saveButton.isEnabled = true
        locationCommentTextField.isEnabled = true
        locationTitleTextField.isEnabled = true
        locationNameTextField.isEnabled = true
        pinCounter = 0
    }
}
