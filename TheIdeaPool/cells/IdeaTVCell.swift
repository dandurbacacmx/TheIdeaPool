//
//  IdeaTVCell.swift
//  TheIdeaPool
//
//  Created by Dan Durbaca on 02/11/2018.
//  Copyright © 2018 Dan Durbaca. All rights reserved.
//

import Foundation
import UIKit

class IdeaTVCell: UITableViewCell {
    
    @IBAction func options(sender: UIButton) {
        onAction()
    }
    
    @IBOutlet weak var content: UILabel?
    @IBOutlet weak var impactNo: UILabel?
    @IBOutlet weak var easeNo: UILabel?
    @IBOutlet weak var confidenceNo: UILabel?
    @IBOutlet weak var averageNo: UILabel?
    @IBOutlet weak var cView: UIView?

    var onAction: ()->Void = {}
}
