//
//  BaseVC.swift
//  TheIdeaPool
//
//  Created by Dan Durbaca on 02/11/2018.
//  Copyright © 2018 Dan Durbaca. All rights reserved.
//

import Foundation
import UIKit

class BaseVC: UIViewController {
    
    var spinner:UIActivityIndicatorView = UIActivityIndicatorView()
    
    func showWait() {
        spinner.startAnimating()
        self.view.addSubview(spinner)
    }
    
    func hideWait() {
        spinner.stopAnimating()
        spinner.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NavigationService.currentVC = self
    }
}
