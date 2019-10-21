//
//  LocationTableViewController.swift
//  All Packages
//
//  Created by Cengiz Baygın on 8.10.2019.
//  Copyright © 2019 Cengiz Baygın. All rights reserved.
//

import UIKit
import CoreData
class LocationTableViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , UINavigationControllerDelegate {
    
    // Objects
    @IBOutlet weak var locationTableView: UITableView!
    // Variables & Arrays
    var locationNameArray = [String]()
    var idArray = [UUID]()
    var selectedName = String()
    var selectedId : UUID?
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTableView.delegate = self
        locationTableView.dataSource = self
        getData()
        if locationNameArray.count <= 0 {
            performSegue(withIdentifier: "LocationAddPage", sender: nil)
        }else {
            print("Test")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self,selector:#selector(getData),name: NSNotification.Name.init("newLocation"), object: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationNameArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let locationTableViewCell = UITableViewCell()
        locationTableViewCell.textLabel?.text = locationNameArray[indexPath.row]
        return locationTableViewCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedName = locationNameArray[indexPath.row]
        selectedId = idArray[indexPath.row]
        performSegue(withIdentifier: "LocationAddPage", sender: nil)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let appContext = appDelegate.persistentContainer.viewContext
            let appFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LocationsDB")
            var idString = idArray[indexPath.row].uuidString
            appFetchRequest.predicate = NSPredicate.init(format: "id = %@", idString)
            appFetchRequest.returnsObjectsAsFaults = false
            do {// Delete docatch
                let fetchResults = try appContext.fetch(appFetchRequest)
                if fetchResults.count > 0 {
                    for ResultsArray in fetchResults as! [NSManagedObject]{
                        if let dataId = ResultsArray.value(forKey: "id") as? UUID{
                            if dataId == idArray[indexPath.row] {
                                appContext.delete(ResultsArray)
                                locationNameArray.remove(at: indexPath.row)
                                idArray.remove(at: indexPath.row)
                                self.locationTableView.reloadData()
                                do {
                                    try appContext.save()
                                } catch  {
                                    print("Error!")
                                }
                                break
                            }
                            
                        }
                    }
                }
            } catch  {
                
            }
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LocationAddPage"{
            let destinationVC = segue.destination as! LocationAddPageViewController
            destinationVC.chosenName = selectedName
            destinationVC.chosenId = selectedId
        }
    }
    @objc func getData(){
        idArray.removeAll(keepingCapacity: false)
        locationNameArray.removeAll(keepingCapacity: false)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appContext = appDelegate.persistentContainer.viewContext
        let appFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LocationsDB")
        do {
            let fetchResults = try appContext.fetch(appFetchRequest)
            if fetchResults.count > 0 {
                for resultsArray in fetchResults as! [NSManagedObject]{
                    if let dataName = resultsArray.value(forKey: "name") as? String{
                        locationNameArray.append(dataName)
                    }
                    if let dataId = resultsArray.value(forKey: "id") as? UUID{
                        idArray.append(dataId)
                        locationTableView.reloadData()
                    }
                }
            }
        } catch  {
            print("Error!")
        }
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        selectedName = ""
        performSegue(withIdentifier: "LocationAddPage", sender: nil)
    }
    
}
