//
//  IdeaDetailsVC.swift
//  TheIdeaPool
//
//  Created by Dan Durbaca on 02/11/2018.
//  Copyright © 2018 Dan Durbaca. All rights reserved.
//

import Foundation
import UIKit

class IdeaDetailsVC: BaseVC, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var detailTV: UITableView?
    
    @IBAction func back(sender: UIButton) {
        NavigationService.showIdeasVCNavBack()
    }

    var data:[String:Any] = [:]
    var fromNavigation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.detailTV?.estimatedRowHeight = 69
        self.detailTV?.rowHeight = UITableViewAutomaticDimension
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
        
        if self.data["content"] == nil {
            self.data["content"] = ""
            self.data["impact"] = "10"
            self.data["ease"] = "10"
            self.data["confidence"] = "10"
            self.data["average_score"] = "10"
        }
        
        self.detailTV?.reloadData()
    }
    
    func saveData() {
        if let id = self.data["id"] as? String {
            let content = self.data["content"] as! String
            let impactStr = self.data["impact"] as! String
            let easeStr = self.data["ease"] as! String
            let confidenceStr = self.data["confidence"] as! String
            IdeaService.updateIdeaRequest(idea_id:id, content: content, impact: Int(impactStr)!, ease: Int(easeStr)!, confidence: Int(confidenceStr)!) { (response) in
                NavigationService.showIdeasVCNavBack()
            }
        } else {
            let content = self.data["content"] as! String
            let impactStr = self.data["impact"] as! String
            let easeStr = self.data["ease"] as! String
            let confidenceStr = self.data["confidence"] as! String
            IdeaService.createIdeaRequest(content: content, impact: Int(impactStr)!, ease: Int(easeStr)!, confidence: Int(confidenceStr)!) { (response) in
                NavigationService.showIdeasVCNavBack()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentDetail", for: indexPath)
                as! ContentDetailTVCell
            cell.content?.text = self.data["content"] as? String
            if self.fromNavigation {
                self.fromNavigation = false
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    cell.content?.becomeFirstResponder()
                }
            }
            return cell
        } else if indexPath.row < 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ValueDetail", for: indexPath)
                as! ValueDetailTVCell
            if indexPath.row == 1 {
                cell.titleLabel?.text = "Impact"
                cell.valueLabel?.text = self.data["impact"] as? String
                cell.onAction = {
                    () -> Void in
                    self.showActionSheet(defaultValue: Int((cell.valueLabel?.text)!)!, key: "impact")
                }
            } else if indexPath.row == 2 {
                cell.titleLabel?.text = "Ease"
                cell.valueLabel?.text = self.data["ease"] as? String
                cell.onAction = {
                    () -> Void in
                    self.showActionSheet(defaultValue: Int((cell.valueLabel?.text)!)!, key: "ease")
                }
            } else if indexPath.row == 3 {
                cell.titleLabel?.text = "Confidence"
                cell.valueLabel?.text = self.data["confidence"] as? String
                cell.onAction = {
                    () -> Void in
                    self.showActionSheet(defaultValue: Int((cell.valueLabel?.text)!)!, key: "confidence")
                }
            } else if indexPath.row == 4 {
                cell.titleLabel?.text = "Avg."
                cell.valueLabel?.text = self.data["average_score"] as? String
                cell.ddChevron?.isHidden = true
                cell.ddButton?.isHidden = true
            }

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonDetail", for: indexPath)
                as! ButtonDetailTVCell
            if indexPath.row == 5 {
                cell.button?.setTitle("SAVE", for: .normal)
                cell.button?.backgroundColor = UIColor(red: 0, green: 0.66, blue: 0.26, alpha: 1)
                cell.onAction = {
                    () -> Void in
                    self.saveData()
                }
            } else if indexPath.row == 6 {
                cell.button?.setTitle("CANCEL", for: .normal)
                cell.button?.backgroundColor = UIColor(red: 0.81, green: 0.81, blue: 0.81, alpha: 1)
                cell.onAction = {
                    () -> Void in
                    NavigationService.showIdeasVC()
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return UITableViewAutomaticDimension
        } else if indexPath.row < 5 {
            return 69
        } else if indexPath.row == 5 {
            return 69
        } else if indexPath.row == 6 {
            return 54
        }
        
        return UITableViewAutomaticDimension
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.data["content"] = textView.text
        self.detailTV?.beginUpdates()
        self.detailTV?.endUpdates()
    }
    
    func showActionSheet(defaultValue:Int, key:String) {
        let alert = UIAlertController(title: key, message: "Please Select an Option", preferredStyle: .actionSheet)
        
        for i in (1...10).reversed() {
            let iN = i as NSNumber
            let title = iN.stringValue
            alert.addAction(UIAlertAction(title: title, style: .default , handler:{ (UIAlertAction)in
                self.data[key] = title
                let impact = Int((self.data["impact"] as? String)!)!
                let ease = Int((self.data["ease"] as? String)!)!
                let confidence = Int((self.data["confidence"] as? String)!)!
                let avg_score = Int((impact+ease+confidence)/3)
                let avg_scoreN = avg_score as NSNumber
                self.data["average_score"] = avg_scoreN.stringValue
                self.refreshData()
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
        }))
        
        self.present(alert, animated: true, completion: {
        })
    }
}
