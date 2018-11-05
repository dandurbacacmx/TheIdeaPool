//
//  ButtonDetailTVCell.swift
//  TheIdeaPool
//
//  Created by Dan Durbaca on 02/11/2018.
//  Copyright © 2018 Dan Durbaca. All rights reserved.
//

import Foundation
import UIKit

class ButtonDetailTVCell: UITableViewCell {
    @IBOutlet weak var button: UIButton?
    
    @IBAction func doAction(sender: UIButton) {
        onAction()
    }

    var onAction: ()->Void = {}
}
