//
//  SimpsonClassFile.swift
//  All Packages
//
//  Created by Cengiz Baygın on 7.10.2019.
//  Copyright © 2019 Cengiz Baygın. All rights reserved.
//

import Foundation
import UIKit
class Simpsons {
    var simpsonName : String
    var simpsonJob : String
    var simpsonWhos : String
    var simpsonImage : UIImage
    init(simpsonNameInit : String , simpsonJobInit : String , simpsonWhosInit : String , simpsonImageInit : UIImage) {
        simpsonName = simpsonNameInit
        simpsonJob = simpsonJobInit
        simpsonWhos = simpsonWhosInit
        simpsonImage = simpsonImageInit
    }
}
