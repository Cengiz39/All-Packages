//
//  GameMainPageViewController.swift
//  All Packages
//
//  Created by Cengiz Baygın on 12.10.2019.
//  Copyright © 2019 Cengiz Baygın. All rights reserved.
//

import UIKit
import CoreData
class GameMainPageViewController: UIViewController {
    // Objects
    @IBOutlet weak var letsPlayButton: UIButton!
    @IBOutlet weak var lastScoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    // Variables & Arrays
    var lastScoreArrayNon = [Int]()
    var highScoresArrayNon = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getHighScore()
        getLastScore()
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getHighScore), name: NSNotification.Name.init("newHighScore"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getLastScore), name:
            NSNotification.Name.init("newLastScore"), object: nil)

    }
    // ScoreFuncs
    @objc func getLastScore(){
        highScoresArrayNon.removeAll(keepingCapacity: false)
        lastScoreArrayNon.removeAll(keepingCapacity: false)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
              let appContext = appDelegate.persistentContainer.viewContext
              let appFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameScoreDB")
              appFetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchResultsArray = try appContext.fetch(appFetchRequest)
            if fetchResultsArray.count > 0 {
                for lastScoreArray in fetchResultsArray as! [NSManagedObject]{
                    if let lastScore = lastScoreArray.value(forKey: "score") as? Int{
                        lastScoreArrayNon.append(lastScore)
                        let lastScoreVar = lastScoreArrayNon.last
                        lastScoreLabel.text = "Last Score:\(lastScoreVar!)"
                    }
                }
            }
        } catch  {
            print("Error!")
        }
    }
    @objc func getHighScore(){
        highScoresArrayNon.removeAll(keepingCapacity: false)
          lastScoreArrayNon.removeAll(keepingCapacity: false)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appContext = appDelegate.persistentContainer.viewContext
        let appFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameScoreDB")
        appFetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchResultsArray = try appContext.fetch(appFetchRequest)
            if fetchResultsArray.count > 0 {
                for highScoreArray in fetchResultsArray as! [NSManagedObject] {
                    if let highScore = highScoreArray.value(forKey: "score") as? Int{
                        highScoresArrayNon.append(highScore)
                        highScoresArrayNon.sort()
                        print(highScore)
                        let highScoreVar = highScoresArrayNon.last
                        highScoreLabel.text = "High Score:\(highScoreVar!)"
                    }
                }
            }
        } catch  {
            print("Error!")
        }
        
        
    }
    @IBAction func letsPlayButtonClicked(_ sender: Any) {
    }
    
    /*
     // MARK: - Navigation
     */
    
}
