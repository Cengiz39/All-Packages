//
//  GamePlayGroundViewController.swift
//  All Packages
//
//  Created by Cengiz Baygın on 12.10.2019.
//  Copyright © 2019 Cengiz Baygın. All rights reserved.
//

import UIKit
import CoreData
class GamePlayGroundViewController: UIViewController , UINavigationControllerDelegate {
    // OBjects
    @IBOutlet weak var kennyImageView5: UIImageView!
    @IBOutlet weak var kennyImageView1: UIImageView!
    @IBOutlet weak var kennyImageView4: UIImageView!
    @IBOutlet weak var kennyImageView3: UIImageView!
    @IBOutlet weak var kennyImageView2: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    var lastScoreArray = [Int]()
    var highScoreArray = [Int]()
    var scoreBoard : Int?
    var timer = Timer()
    var timerCounter = Int()
    var kennyTimer = Timer()
    var scoreCounter = Int()
    var kennyArrays = [UIImageView]()
    var storedScore = Int()
    var highScore = Int()
    var scoreArray = [NSManagedObject]()
    // Variables & Arrays
    override func viewDidLoad() {
        super.viewDidLoad()
        allCharacterOpen()
        scoreCounter = 0
        timerCounter = 11
        // UserInterActions on / off
        allCharacterUserInterActionOff()
        // Gestures
        let kenny1 = UITapGestureRecognizer.init(target: self, action: #selector(tapTheKenny))
        let kenny2 = UITapGestureRecognizer.init(target: self, action: #selector(tapTheKenny))
        let kenny3 = UITapGestureRecognizer.init(target: self, action: #selector(tapTheKenny))
        let kenny4 = UITapGestureRecognizer.init(target: self, action: #selector(tapTheKenny))
        let kenny5 = UITapGestureRecognizer.init(target: self, action: #selector(tapTheKenny))
        // Add Gesture
        kennyImageView1.addGestureRecognizer(kenny1)
        kennyImageView2.addGestureRecognizer(kenny2)
        kennyImageView3.addGestureRecognizer(kenny3)
        kennyImageView4.addGestureRecognizer(kenny4)
        kennyImageView5.addGestureRecognizer(kenny5)
        // Add Array
        kennyArrays.append(kennyImageView1!)
        kennyArrays.append(kennyImageView2!)
        kennyArrays.append(kennyImageView3!)
        kennyArrays.append(kennyImageView4!)
        kennyArrays.append(kennyImageView5!)
        print(kennyArrays.count)
    }
    // Funcs
    @objc func TimerFunction(){
        print("Times Start!")
        timerCounter = timerCounter - 1
        timerLabel.text = "Timer: \(timerCounter)"
        if timerCounter == 0 {
            print("Times Up!")
            timer.invalidate()
            kennyTimer.invalidate()
            storedScore = scoreCounter
            if storedScore > 0 {
                saveScore()
            }
            print(storedScore)
            timerLabel.tintColor = UIColor.red
            timerLabel.text = "Time's Up!"
            scoreCounter = 0
            timerCounter = 10
            allCharacterUserInterActionOff()
            allCharacterOpen()
        }
    }
    @objc func tapTheKenny(){
        if timerCounter != 0 {
            scoreCounter = scoreCounter + 1
            scoreLabel.text = "Score:\(scoreCounter)"
        }else{
            scoreCounter = 0
        }
    }
    func allCharactersClose(){
        kennyImageView1.isHidden = true
        kennyImageView2.isHidden = true
        kennyImageView3.isHidden = true
        kennyImageView4.isHidden = true
        kennyImageView5.isHidden = true
    }
    func allCharacterOpen(){
        kennyImageView1.isHidden = false
        kennyImageView2.isHidden = false
        kennyImageView3.isHidden = false
        kennyImageView4.isHidden = false
        kennyImageView5.isHidden = false
    }
    func allCharacterUserInterActionOn(){
        kennyImageView1.isUserInteractionEnabled = true
        kennyImageView2.isUserInteractionEnabled = true
        kennyImageView3.isUserInteractionEnabled = true
        kennyImageView4.isUserInteractionEnabled = true
        kennyImageView5.isUserInteractionEnabled = true
    }
    func allCharacterUserInterActionOff(){
        kennyImageView1.isUserInteractionEnabled = false
        kennyImageView2.isUserInteractionEnabled = false
        kennyImageView3.isUserInteractionEnabled = false
        kennyImageView4.isUserInteractionEnabled = false
        kennyImageView5.isUserInteractionEnabled = false
    }
    @IBAction func playButtonClicked(_ sender: Any) {
        allCharacterUserInterActionOn()
        allCharactersClose()
        timer.invalidate()
        kennyTimer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimerFunction), userInfo: nil, repeats: true)
        kennyTimer = Timer.scheduledTimer(timeInterval: 1.1, target: self, selector: #selector(hideKenny), userInfo: nil, repeats: true)
    }
    @objc func hideKenny (){
        for selectedKenny in kennyArrays {
            selectedKenny.isHidden = true
        }
        let random = Int(arc4random_uniform(UInt32(kennyArrays.count - 1)))
        kennyArrays[random].isHidden = false
    }
    // CoreData Funcs
    @objc func saveScore(){
        // saveScore
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appContext = appDelegate.persistentContainer.viewContext
        let newScore = NSEntityDescription.insertNewObject(forEntityName: "GameScoreDB", into: appContext)
        newScore.setValue(storedScore, forKey: "score")
        newScore.setValue(UUID(), forKey: "id")
        do {
            try appContext.save()
            print("Save is Successfull!")
        } catch  {
            print("Error!")
        }
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "newLastScore"), object: nil)
         NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "newHighScore"), object: nil)
    }
}
