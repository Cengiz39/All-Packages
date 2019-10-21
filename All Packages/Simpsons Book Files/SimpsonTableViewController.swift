//
//  SimpsonTableViewController.swift
//  All Packages
//
//  Created by Cengiz Baygın on 7.10.2019.
//  Copyright © 2019 Cengiz Baygın. All rights reserved.
//

import UIKit
class SimpsonTableViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    // Objects
    @IBOutlet weak var simpsonTableView: UITableView!
    // Variables & Arrays
    var simpsonClasses : Simpsons?
    var simpsonsArray = [Simpsons]()
    override func viewDidLoad() {
        super.viewDidLoad()
        simpsonTableView.dataSource = self
        simpsonTableView.delegate = self
        // Characters Define
        let Bart = Simpsons.init(simpsonNameInit: "Bart Simpson", simpsonJobInit: "Student", simpsonWhosInit: "Children", simpsonImageInit: UIImage.init(named: "bartt")!)
        let Lisa = Simpsons.init(simpsonNameInit: "Lisa Simpson", simpsonJobInit: "Student", simpsonWhosInit: "Children", simpsonImageInit: UIImage.init(named: "lisa")!)
        let Homer = Simpsons.init(simpsonNameInit: "Homer Simpson", simpsonJobInit: "Nuclear Safety", simpsonWhosInit: "Father", simpsonImageInit: UIImage.init(named: "homer")!)
        let Maggie = Simpsons.init(simpsonNameInit: "Maggie Simpson", simpsonJobInit: "Baby", simpsonWhosInit: "Children", simpsonImageInit: UIImage.init(named: "maggie")!)
        let Marge = Simpsons.init(simpsonNameInit: "Marge Simpson", simpsonJobInit: "House Wife", simpsonWhosInit: "Mom", simpsonImageInit: UIImage.init(named: "marge")!)
        simpsonsArray.append(Bart)
        simpsonsArray.append(Lisa)
        simpsonsArray.append(Homer)
        simpsonsArray.append(Maggie)
        simpsonsArray.append(Marge)
        // Characters Define endline
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return simpsonsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let simpsonTableViewCell = UITableViewCell()
        simpsonTableViewCell.textLabel?.text = simpsonsArray[indexPath.row].simpsonName
        return simpsonTableViewCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        simpsonClasses = simpsonsArray[indexPath.row]
        self.performSegue(withIdentifier: "SimpsonSelectedPage", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SimpsonSelectedPage"{
            let destinationVC = segue.destination as! SimpsonSelectedPageViewController
            destinationVC.chosenSimpson = simpsonClasses
        }
    }
    
}
