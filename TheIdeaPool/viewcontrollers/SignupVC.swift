//
//  SignupVC.swift
//  TheIdeaPool
//
//  Created by Dan Durbaca on 02/11/2018.
//  Copyright © 2018 Dan Durbaca. All rights reserved.
//

import Foundation
import UIKit

class SignupVC: BaseVC {
    
    @IBOutlet weak var nameTextfield: UITextField?
    @IBOutlet weak var emailTextfield: UITextField?
    @IBOutlet weak var passwordTextfield: UITextField?
    @IBOutlet weak var loginLabel: UIButton?

    @IBAction func logIn(sender: UIButton) {
        NavigationService.showLogIn()
    }

    @IBAction func signUp(sender: UIButton) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        passwordTextfield?.isSecureTextEntry = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let gAttribute = [ NSAttributedStringKey.foregroundColor: UIColor(red:0.00, green:0.66, blue:0.26, alpha:1.0) ]
        let aString = NSMutableAttributedString(string: "Already have an account? ")
        let gString = NSAttributedString(string: "Log in", attributes: gAttribute)
        aString.append(gString)
        self.loginLabel?.setAttributedTitle(aString, for: .normal)

    }
    
}
