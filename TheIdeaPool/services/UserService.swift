//
//  UserService.swift
//  TheIdeaPool
//
//  Created by Dan Durbaca on 01/11/2018.
//  Copyright © 2018 Dan Durbaca. All rights reserved.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper

class UserService {
    static func isLoggedIn() -> Bool {
        
        if KeychainWrapper.standard.string(forKey: ConfigService.keychain_key+"_refresh_token") != nil {
            return true
        }
        return false
    }
    
    static func registerRequest(email:String, name:String, password:String, completion: (_ result: [String: String])->()) {
        
        NavigationService.showWait()
        
        let parameters = [
            "email": email,
            "name": name,
            "password": password
        ]
        
        Alamofire.request(ConfigService.endpoint+"users", method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            NavigationService.hideWait()
            switch response.result {
            case .success:
                if let json = response.result.value as? [String: Any] {
                    if let reason = json["reason"] as? String {
                        AlertService.showInfo(message: reason)
                    }
                }
                break
            case .failure(let error):
                AlertService.showInfo(message: error.localizedDescription)
            }
        }
    }
    
    static func loginRequest(email:String, password:String, completion: @escaping (_ result: [String: Any])->()) {
        
        NavigationService.showWait()
        
        let parameters = [
            "email": email,
            "password": password
        ]
        
        Alamofire.request(ConfigService.endpoint+"access-tokens", method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            NavigationService.hideWait()
            switch response.result {
            case .success:
                if let json = response.result.value as? [String: Any] {
                    if let reason = json["reason"] as? String {
                        AlertService.showInfo(message: reason)
                    } else {
                        if let jwt = json["jwt"] as? String {
                            KeychainWrapper.standard.set(jwt, forKey: ConfigService.keychain_key+"_jwt")
                        }
                        if let refresh_token = json["refresh_token"] as? String {
                            KeychainWrapper.standard.set(refresh_token, forKey: ConfigService.keychain_key+"_refresh_token")
                            KeychainWrapper.standard.set(Date().timeIntervalSince1970, forKey: ConfigService.keychain_key+"_refresh_token_ts")
                        }
                        completion(json)
                    }
                }
                break
            case .failure(let error):
                AlertService.showInfo(message: error.localizedDescription)
            }
        }
    }
    
    static func checkToken(compl: @escaping (_ result:Bool)->()) {
        if let token_ts = KeychainWrapper.standard.double(forKey: ConfigService.keychain_key+"_refresh_token_ts") {
            let delta_ts  = Date().timeIntervalSince(Date(timeIntervalSince1970: token_ts))
            let ti = NSInteger(delta_ts)
            let minutes = (ti / 60) % 60
            if minutes > 9 {
                UserService.refreshTokenRequest { (response) in
                    compl(true)
                }
            } else {
                compl(true)
            }
        } else {
            UserService.refreshTokenRequest { (response) in
                compl(true)
            }
        }
    }
    
    static func refreshTokenRequest(completion: @escaping (_ result: [String: Any])->()) {
        
        var a_token = ""
        if let aToken = KeychainWrapper.standard.string(forKey: ConfigService.keychain_key+"_refresh_token") {
            a_token = aToken
        }
        let parameters = [
            "refresh_token": a_token
        ]
        
        Alamofire.request(ConfigService.endpoint+"access-tokens/refresh", method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String: Any] {
                    if let reason = json["reason"] as? String {
                        AlertService.showInfo(message: reason)
                    }
                    if let jwt = json["jwt"] as? String {
                        KeychainWrapper.standard.set(jwt, forKey: ConfigService.keychain_key+"_jwt")
                        KeychainWrapper.standard.set(Date().timeIntervalSince1970, forKey: ConfigService.keychain_key+"_refresh_token_ts")
                        completion(json)
                    }
                }
                break
            case .failure(let error):
                AlertService.showInfo(message: error.localizedDescription)
            }
        }
    }
    
    static func logoutRequest(completion: @escaping (_ result: [String: Any])->()) {
        var a_token = ""
        if let aToken = KeychainWrapper.standard.string(forKey: ConfigService.keychain_key+"_refresh_token") {
            a_token = aToken
            KeychainWrapper.standard.removeObject(forKey: ConfigService.keychain_key+"_refresh_token")
        }
        let parameters = [
            "refresh_token": a_token
        ]
        
        var jwt = ""
        if let ajwt = KeychainWrapper.standard.string(forKey: ConfigService.keychain_key+"_jwt") {
            jwt = ajwt
            KeychainWrapper.standard.removeObject(forKey: ConfigService.keychain_key+"_jwt")
        }
        
        let headers: HTTPHeaders = [
            "X-Access-Token": jwt
        ]
        
        Alamofire.request(ConfigService.endpoint+"access-tokens", method: .delete, parameters: parameters,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                completion([:])
                if let json = response.result.value as? [String: Any] {
                    if let reason = json["reason"] as? String {
                        AlertService.showInfo(message: reason)
                    }
                }
                break
            case .failure(let error):
                AlertService.showInfo(message: error.localizedDescription)
            }
        }
    }
    
    static func getCurrentUserRequest(completion: (_ result: [String: String])->()) {
        
        UserService.checkToken { (response) in
            var jwt = ""
            if let ajwt = KeychainWrapper.standard.string(forKey: ConfigService.keychain_key+"_jwt") {
                jwt = ajwt
            }
        
            let headers: HTTPHeaders = [
                "X-Access-Token": jwt
            ]
        
            Alamofire.request(ConfigService.endpoint+"me", method: .get, parameters: nil,encoding: JSONEncoding.default, headers: headers).responseJSON {
                    response in
                    switch response.result {
                    case .success:
                    if let json = response.result.value as? [String: Any] {
                        if let reason = json["reason"] as? String {
                            AlertService.showInfo(message: reason)
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
