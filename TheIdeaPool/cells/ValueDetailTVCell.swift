//
//  ValueDetailTVCell.swift
//  TheIdeaPool
//
//  Created by Dan Durbaca on 02/11/2018.
//  Copyright © 2018 Dan Durbaca. All rights reserved.
//

import Foundation
import UIKit

class ValueDetailTVCell: UITableViewCell {
    
    @IBAction func showAction(sender: UIButton) {
        onAction()
    }
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var valueLabel: UILabel?
    @IBOutlet weak var ddChevron: UIButton?
    @IBOutlet weak var ddButton: UIButton?
    
    var onAction: ()->Void = {}
}
