//
//  IdeaService.swift
//  TheIdeaPool
//
//  Created by Dan Durbaca on 01/11/2018.
//  Copyright © 2018 Dan Durbaca. All rights reserved.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper

class IdeaService {
    
    static func createIdeaRequest(content:String, impact:Int, ease:Int, confidence:Int, completion: @escaping (_ result: [String: Any])->()) {
        
        UserService.checkToken { (response) in
            var jwt = ""
            if let ajwt = KeychainWrapper.standard.string(forKey: ConfigService.keychain_key+"_jwt") {
                jwt = ajwt
            }
        
            let headers: HTTPHeaders = [
                "X-Access-Token": jwt
            ]
        
            let parameters = [
                "content": content.prefix(255),
                "impact": min(max(0, impact),10),
                "ease": min(max(0, ease),10),
                "confidence": min(max(0, confidence),10),
                ] as [String : Any]
        
            Alamofire.request(ConfigService.endpoint+"ideas", method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: headers).responseJSON {
                response in
                switch response.result {
                case .success:
                    if let json = response.result.value as? [String: Any] {
                        if let reason = json["reason"] as? String {
                            AlertService.showInfo(message: reason)
                        } else {
                            completion(json)
                        }
                    }
                    break
                case .failure(let error):
                    AlertService.showInfo(message: error.localizedDescription)
                }
            }
        }
    }

    static func updateIdeaRequest(idea_id:String, content:String, impact:Int, ease:Int, confidence:Int, completion: @escaping (_ result: [String: Any])->()) {
        
        UserService.checkToken { (response) in
            var jwt = ""
            if let ajwt = KeychainWrapper.standard.string(forKey: ConfigService.keychain_key+"_jwt") {
                jwt = ajwt
            }
            
            let headers: HTTPHeaders = [
                "X-Access-Token": jwt
            ]
            
            let parameters = [
                "content": content.prefix(255),
                "impact": min(max(0, impact),10),
                "ease": min(max(0, ease),10),
                "confidence": min(max(0, confidence),10),
                ] as [String : Any]
            
            Alamofire.request(ConfigService.endpoint+"ideas/"+idea_id, method: .put, parameters: parameters,encoding: JSONEncoding.default, headers: headers).responseJSON {
                response in
                switch response.result {
                case .success:
                    if let json = response.result.value as? [String: Any] {
                        if let reason = json["reason"] as? String {
                            AlertService.showInfo(message: reason)
                        } else {
                            completion(json)
                        }
                    }
                    break
                case .failure(let error):
                    AlertService.showInfo(message: error.localizedDescription)
                }
            }
        }
    }

    static func deleteIdeaRequest(idea_id:String, completion: @escaping (_ result: [String: Any])->()) {
        
        UserService.checkToken { (response) in
            var jwt = ""
            if let ajwt = KeychainWrapper.standard.string(forKey: ConfigService.keychain_key+"_jwt") {
                jwt = ajwt
            }
            
            let headers: HTTPHeaders = [
                "X-Access-Token": jwt
            ]
            
            Alamofire.request(ConfigService.endpoint+"ideas/"+idea_id, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON {
                response in
                switch response.result {
                case .success:
                    completion([:])
                    break
                case .failure(let error):
                    AlertService.showInfo(message: error.localizedDescription)
                }
            }
        }
    }

    static func getIdeasRequest(page:Int, completion: @escaping (_ result: [[String: Any]])->()) {
        
        UserService.checkToken { (response) in
            var jwt = ""
            if let ajwt = KeychainWrapper.standard.string(forKey: ConfigService.keychain_key+"_jwt") {
                jwt = ajwt
            }
        
            let headers: HTTPHeaders = [
                "X-Access-Token": jwt
            ]
        
            let parameters = [
                "page": min(1,page)
            ]
        
            Alamofire.request(ConfigService.endpoint+"ideas", method: .get, parameters: nil,encoding: JSONEncoding.default, headers: headers).responseJSON {
                response in
                switch response.result {
                case .success:
                    if let json = response.result.value as? [[String: Any]] {
                        completion(json)
                    } else {
                        if let jsone = response.result.value as? [String: Any] {
                            if let reason = jsone["reason"] as? String {
                                AlertService.showInfo(message: reason)
                            }
                        }
                    }
                    break
                case .failure(let error):
                    AlertService.showInfo(message: error.localizedDescription)
                }
            }
        }
    }
}
