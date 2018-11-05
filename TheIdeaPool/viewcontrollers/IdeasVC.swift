//
//  IdeasVC.swift
//  TheIdeaPool
//
//  Created by Dan Durbaca on 02/11/2018.
//  Copyright © 2018 Dan Durbaca. All rights reserved.
//

import Foundation
import UIKit

class IdeasVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var ideasTV: UITableView?
    
    @IBAction func logOut(sender: UIButton) {
        UserService.logoutRequest { (response) in
            NavigationService.showLogIn()
        }
    }
    
    @IBAction func createIdea(sender: UIButton) {
        NavigationService.showIdeaDetailsVC(data:nil)
    }

    var ideas:[[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.ideasTV?.estimatedRowHeight = 69
        self.ideasTV?.rowHeight = UITableViewAutomaticDimension
        //self.ideasTV?.contentInset = UIEdgeInsetsMake(12, 12, -120, 12);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        refreshData()
    }
    
    func refreshData() {
        IdeaService.getIdeasRequest(page: 0) { (response) in
            self.ideas = response
            if self.ideas.count > 0 {
                self.ideasTV?.isHidden = false
                self.ideasTV?.reloadData()
            } else {
                self.ideasTV?.isHidden = true
            }
        }
    }
    
    func deleteIdea(data:[String:Any]) {
        if let id = data["id"] as? String {
            IdeaService.deleteIdeaRequest(idea_id:id) { (response) in
                self.refreshData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ideas.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < ideas.count
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IdeaCell", for: indexPath)
                as! IdeaTVCell
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            formatter.roundingMode = .up
        
            let data = self.ideas[indexPath.row]
            if let content = data["content"] as? String {
                cell.content?.text = content
            }
            if let impact = data["impact"] as? NSNumber {
                cell.impactNo?.text = impact.stringValue
            }
            if let ease = data["ease"] as? NSNumber {
                cell.easeNo?.text = ease.stringValue
            }
            if let confidence = data["confidence"] as? NSNumber {
                cell.confidenceNo?.text = confidence.stringValue
            }
            if let average_score = data["average_score"] as? NSNumber {
                cell.averageNo?.text = String(format: "%d", average_score.intValue)
            }

            cell.onAction = {
                () -> Void in
                self.showActionSheet(data:data)
            }
            
            // corner radius
            cell.cView?.layer.cornerRadius = 10
        
            // border
            cell.cView?.layer.borderWidth = 1.0
            cell.cView?.layer.borderColor = UIColor.white.cgColor
        
            // shadow
            cell.cView?.layer.shadowColor = UIColor.black.cgColor
            cell.cView?.layer.shadowOffset = CGSize(width: 3, height: 3)
            cell.cView?.layer.shadowOpacity = 0.33
            cell.cView?.layer.shadowRadius = 4.0
            cell.cView?.clipsToBounds = false
            
            return cell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "FooterCell", for: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < ideas.count {
            return UITableViewAutomaticDimension
        } else {
            return 119
        }
    }
    
    func showActionSheet(data:[String:Any]) {
        let alert = UIAlertController(title: "Actions", message: nil, preferredStyle: .actionSheet)
        
        
        alert.addAction(UIAlertAction(title: "Edit", style: .default , handler:{ (UIAlertAction)in
            var dta:[String:Any] = [:]
            dta["impact"] = (data["impact"] as! NSNumber).stringValue
            dta["ease"] = (data["ease"] as! NSNumber).stringValue
            dta["confidence"] = (data["confidence"] as! NSNumber).stringValue
            dta["average_score"] = (data["average_score"] as! NSNumber).stringValue
            NavigationService.showIdeaDetailsVC(data: dta)
        }))
       
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
            self.askForDelete(data:data)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
        }))
        
        self.present(alert, animated: true, completion: {
        })
    }

    func askForDelete(data:[String:Any]) {
        let alert = UIAlertController(title: "Are you sure?", message: "The idea will be permanently deleted.", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.deleteIdea(data:data)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
        }
    
        // Add the actions
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: {
        })
    }
}
