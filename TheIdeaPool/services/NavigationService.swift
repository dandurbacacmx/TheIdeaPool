//
//  NavigationService.swift
//  TheIdeaPool
//
//  Created by Dan Durbaca on 02/11/2018.
//  Copyright © 2018 Dan Durbaca. All rights reserved.
//

import Foundation
import UIKit

class NavigationService {
    
    static var logInVC:LoginVC?
    static var signUpVC:SignupVC?
    static var ideasVC:IdeasVC?
    static var ideaDetailsVC:IdeaDetailsVC?
    
    static var currentVC:BaseVC?
    
    static func showWait() {
        if let curVC = self.currentVC {
            curVC.showWait()
        }
    }
    
    static func hideWait() {
        if let curVC = self.currentVC {
            curVC.hideWait()
        }
    }
    
    static func showLogIn() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "LogInVC") as! LoginVC
        if let curVC = self.currentVC {
            curVC.present(newViewController, animated: true, completion: nil)
        }
    }
    
    static func showSignUp() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SignUpVC") as! SignupVC
        if let curVC = self.currentVC {
            curVC.present(newViewController, animated: true, completion: nil)
        }
    }

    static func showIdeasVC() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "IdeasVC") as! IdeasVC
        if let curVC = self.currentVC {
            curVC.present(newViewController, animated: true, completion: nil)
        }
    }

    static func showIdeasVCNavBack() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "IdeasVC") as! IdeasVC
        if let curVC = self.currentVC {
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            curVC.view.window!.layer.add(transition, forKey: kCATransition)
            curVC.present(newViewController, animated: false, completion: nil)
        }
    }

    static func showIdeaDetailsVC(data:[String:Any]?) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "IdeaDetailsVC") as! IdeaDetailsVC
        if let dta = data {
            newViewController.data = dta
        } else {
            newViewController.data = [:]
        }
        newViewController.fromNavigation = true
        if let curVC = self.currentVC {
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            curVC.view.window!.layer.add(transition, forKey: kCATransition)
            curVC.present(newViewController, animated: false, completion: nil)
        }
    }

    static func getTopController() -> UIViewController {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            return topController
        }
        
        return UIViewController()
    }
}
