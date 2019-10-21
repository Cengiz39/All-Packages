//
//  ViewController.swift
//  All Packages
//
//  Created by Cengiz Baygın on 6.10.2019.
//  Copyright © 2019 Cengiz Baygın. All rights reserved.
//

import UIKit
import LocalAuthentication
class ViewController: UIViewController , UINavigationControllerDelegate , UITableViewDelegate , UITableViewDataSource {
    // Objects
    
    @IBOutlet weak var artBookButton: UIBarButtonItem!
    @IBOutlet weak var travelBookButton: UIBarButtonItem!
    @IBOutlet weak var SimpsonsBookButton: UIBarButtonItem!
    @IBOutlet weak var gameButton: UIBarButtonItem!
    // Variables & Arrays
    var menuArrays = ["Travel Book" , "Art Book" , "Simpsons Book" , "Catch the Kenny Game"]
    var selectedApp = String()
    @IBOutlet weak var mainPageTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Face  ID // Touch ID  ??
        let authContext = LAContext()
        var error: NSError?
        if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To check if it's really you!", reply: { (success, error) in
                
                if success {
                   print("Success!")
                } else {
                    print("Error!")
                }
                
                
            })
        }
        //
        
        
        
        func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            let userInterFaceStyle = traitCollection.userInterfaceStyle
            if userInterFaceStyle == .dark{
                darkMode()
            }else{
                lightMode()
            }
        }
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        mainPageTableView.delegate = self
        mainPageTableView.dataSource = self
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        let userInterFaceStyle = traitCollection.userInterfaceStyle
        if userInterFaceStyle == .dark{
            darkMode()
        }else{
            lightMode()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.hidesBarsOnSwipe = true
        let userInterFaceStyle = traitCollection.userInterfaceStyle
        if userInterFaceStyle == .dark{
            darkMode()
        }else{
            lightMode()
        }
    }
    func lightMode(){
        artBookButton.tintColor = UIColor.black
        gameButton.tintColor = UIColor.black
        travelBookButton.tintColor = UIColor.black
        SimpsonsBookButton.tintColor = UIColor.black
    }
    func darkMode(){
        artBookButton.tintColor = UIColor.white
        gameButton.tintColor = UIColor.white
        travelBookButton.tintColor = UIColor.white
        SimpsonsBookButton.tintColor = UIColor.white
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnSwipe = false
    }
    
    @objc func addButtonClicked () {
        
    }
    // Table View Funcs
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuArrays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mainTableViewCells = UITableViewCell()
        mainTableViewCells.textLabel?.text = menuArrays[indexPath.row]
        return mainTableViewCells
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedApp = menuArrays[indexPath.row]
        switch  selectedApp {
        case "Art Book":
            performSegue(withIdentifier: "ArtBookTableView", sender: nil)
        case "Travel Book":
            performSegue(withIdentifier: "TravelBookTableView", sender: nil)
            print("travel book")
        case "Simpsons Book":
            performSegue(withIdentifier: "SimpsonsBookTableView", sender: nil)
            print("Simpsons Book")
        case "Catch the Kenny Game":
            performSegue(withIdentifier: "GameMainPage", sender: nil)
            print("Catch the Kenny Game")
        default:
            print("Default")
        }
        // "Travel Book" , "Art Book" , "Simpsons Book" , "Catch the Kenny Game"
    }
    // Segue
    // Button Variables
    @IBAction func artBookClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "ArtBookTableView", sender: nil)
    }
    @IBAction func travelBookClicked(_ sender: Any) {
    }
    @IBAction func simpsonsBookClicked(_ sender: Any) {
    }
    @IBAction func gameButtonClicked(_ sender: Any) {
    }
    
}

