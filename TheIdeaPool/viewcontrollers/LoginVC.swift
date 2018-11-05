//
//  LoginVC.swift
//  TheIdeaPool
//
//  Created by Dan Durbaca on 02/11/2018.
//  Copyright © 2018 Dan Durbaca. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

class LoginVC: BaseVC {

    @IBOutlet weak var emailTextfield: UITextField?
    @IBOutlet weak var passwordTextfield: UITextField?
    @IBOutlet weak var signupLabel: UIButton?
    
    @IBAction func signUp(sender: UIButton) {
        NavigationService.showSignUp()
    }
    
    @IBAction func logIn(sender: UIButton) {
        UserService.loginRequest(email: (emailTextfield?.text)!, password: (passwordTextfield?.text)!) { (response) in
            NavigationService.showIdeasVC()
        }
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
        let aString = NSMutableAttributedString(string: "Don't have an account? ")
        let gString = NSAttributedString(string: "Create an account", attributes: gAttribute)
        aString.append(gString)
        self.signupLabel?.setAttributedTitle(aString, for: .normal)
        
        if UserService.isLoggedIn() {
            NavigationService.showIdeasVC()
        } else {
            if KeychainWrapper.standard.string(forKey: ConfigService.keychain_key+"_first_time") == nil {
                KeychainWrapper.standard.set("YES", forKey: ConfigService.keychain_key+"_first_time")
                NavigationService.showSignUp()
            }
        }
    }
}
