//
//  ArtBookTableViewController.swift
//  All Packages
//
//  Created by Cengiz Baygın on 6.10.2019.
//  Copyright © 2019 Cengiz Baygın. All rights reserved.
//

import UIKit
import CoreData
class ArtBookTableViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {


// Objects
    @IBOutlet weak var artBookTableView: UITableView!
    // Variables & Arrays
    var nameDataArray = [String]()
    var idDataArray = [UUID]()
    var selectedName = String()
    var selectedId : UUID?
    override func viewDidLoad() {
        super.viewDidLoad()
      
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.camera, target: self, action: #selector(addButtonClicked))
        artBookTableView.dataSource = self
        artBookTableView.delegate = self
            getData()
       if idDataArray.count == 0 {
           self.performSegue(withIdentifier: "ArtBookAddPage", sender: nil)
       }
    }
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name.init("newArt"), object: nil)
    }

    @objc func addButtonClicked(){
        selectedName = ""
        self.performSegue(withIdentifier: "ArtBookAddPage", sender: nil)
    }
    
    @objc func getData(){
        nameDataArray.removeAll(keepingCapacity: false)
        idDataArray.removeAll(keepingCapacity: false)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appContext = appDelegate.persistentContainer.viewContext
        let appFetchResults = NSFetchRequest<NSFetchRequestResult>(entityName: "ArtBookDB")
        do {
           let fetchResults = try appContext.fetch(appFetchResults)
            if fetchResults.count > 0 {
                for fetchArray in fetchResults as! [NSManagedObject] {
                    if let nameData = fetchArray.value(forKey: "name") as? String{
                        nameDataArray.append(nameData)
                    }
                    if let idData = fetchArray.value(forKey: "id") as? UUID{
                        idDataArray.append(idData)
                        artBookTableView.reloadData()
                    }
                }
            }
        } catch  {
            print("Error!")
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let artBookTableViewCell = UITableViewCell()
        artBookTableViewCell.textLabel?.text = nameDataArray[indexPath.row]
        return artBookTableViewCell
    
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedName = nameDataArray[indexPath.row]
        selectedId = idDataArray[indexPath.row]
        self.performSegue(withIdentifier: "ArtBookAddPage", sender: nil)
    }
// ButtonFuncs
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ArtBookAddPage"{
            let destinationVC = segue.destination as! ArtBookAddPageViewController
            destinationVC.chosenName = selectedName
            destinationVC.chosenId = selectedId
        }
    }
    @IBAction func artBookButtonClicked(_ sender: Any) {
        selectedName = ""
        self.performSegue(withIdentifier: "ArtBookAddPage", sender: nil)
    }
    @IBAction func travelBookButtonClicked(_ sender: Any) {
        
    }
    @IBAction func gameButtonClicked(_ sender: Any) {
    }
    @IBAction func simpsonBookButtonClicked(_ sender: Any) {
    }
    
}
