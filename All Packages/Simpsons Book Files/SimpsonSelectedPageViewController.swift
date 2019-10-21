//
//  SimpsonSelectedPageViewController.swift
//  All Packages
//
//  Created by Cengiz Baygın on 7.10.2019.
//  Copyright © 2019 Cengiz Baygın. All rights reserved.
//

import UIKit

class SimpsonSelectedPageViewController: UIViewController {

    @IBOutlet weak var simpsonJobTextField: UITextField!
    @IBOutlet weak var whoSimpsonTextField: UITextField!
    @IBOutlet weak var simpsonNameTextField: UITextField!
    @IBOutlet weak var simpsonImageView: UIImageView!
    var chosenSimpson : Simpsons?
    override func viewDidLoad() {
        super.viewDidLoad()
        simpsonNameTextField.text = chosenSimpson?.simpsonName
        simpsonJobTextField.text = chosenSimpson?.simpsonJob
        whoSimpsonTextField.text = chosenSimpson?.simpsonWhos
        simpsonImageView.image = chosenSimpson?.simpsonImage
        whoSimpsonTextField.isEnabled = false
        simpsonJobTextField.isEnabled = false
        simpsonNameTextField.isEnabled = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
