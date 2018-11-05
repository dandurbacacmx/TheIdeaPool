//
//  AlertService.swift
//  TheIdeaPool
//
//  Created by Dan Durbaca on 01/11/2018.
//  Copyright © 2018 Dan Durbaca. All rights reserved.
//

import Foundation
import UIKit

class AlertService {
    
    static func showInfo(message:String) {
        let alert = UIAlertController(title: "Info", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            topController.present(alert, animated: true, completion: nil)
        }
    }
}
