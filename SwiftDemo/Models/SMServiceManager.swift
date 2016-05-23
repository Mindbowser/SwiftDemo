//
//  SMServiceManager.swift
//  SwiftDemo
//
//  Created by Mindbowser on 18/04/16.
//  Copyright © 2016 Mindbowser. All rights reserved.
//

import UIKit

class SMServiceManager: NSObject {
    
    func serverRegisterUser(userInfo: [String:AnyObject]) -> Bool {
        let responseInfo: AnyObject? = SMServiceFetcher().registerUser(userInfo)
        return verifyAndSaveSuccessResponse(responseInfo)
    }
    
    func serverLoginUser(userInfo: [String:AnyObject]) -> Bool {
        let responseInfo: AnyObject? = SMServiceFetcher().loginUser(userInfo)
        return verifyAndSaveSuccessResponse(responseInfo)
    }
    
    func serverEditProfile(userInfo: [String:AnyObject]) -> Bool {
        let responseInfo: AnyObject? = SMServiceFetcher().editProfile(userInfo)
        return verifySuccessResponse(responseInfo)
    }
    
    func verifyAndSaveSuccessResponse(responseInfo:AnyObject?) -> Bool {
        if let info = responseInfo as? [String:AnyObject] {
            if let errorInfo:[String:AnyObject] = info[kSMServiceResponseObjectError] as? [String:AnyObject] {
                let message = JSONString(errorInfo[kSMServiceResponseParameterMessage])!
                if message != "Invalid User Token." {
                    AlertManager.sharedInstance.showErrorMessage(message)
                }
                
                return false
            } else {
                // Save user's object
                if let userInfo = JSONDictionary(info[kSMServiceResponseObjectUserInfo]) {
                    let sharedAppUser = SMAppUser.sharedInstance
                    sharedAppUser.name = JSONString(userInfo[kSMServiceRegisterRequestParameterName])!
                    sharedAppUser.emailAddress = JSONString(userInfo[kSMServiceRegisterRequestParameterEmailId])!
                    sharedAppUser.gender = JSONString(userInfo[kSMServiceRegisterRequestParameterGender])!
                    sharedAppUser.save()
                    
                    // Save auth token in NSUserDefaults
                    let authToken = JSONString(userInfo[kSMServiceUserInfoAuthToken])
                    NSUserDefaults.standardUserDefaults().setObject(authToken, forKey: kSMServiceUserInfoAuthToken)
                    NSUserDefaults.standardUserDefaults().synchronize()
                }
            }
        }
        return true
    }
    
    func verifySuccessResponse(responseInfo:AnyObject?) -> Bool {
        if let info = responseInfo as? [String:AnyObject] {
            if let errorInfo:[String:AnyObject] = info[kSMServiceResponseObjectError] as? [String:AnyObject] {
                let message = JSONString(errorInfo[kSMServiceResponseParameterMessage])!
                if message != "Invalid User Token." {
                    AlertManager.sharedInstance.showErrorMessage(message)
                }
                return false
            } else {
                return true
            }
        }
        return true
    }
    
    
    // Eliminate JSON Type Checking using these functions
    func JSONString(object: AnyObject?) -> String? {
        return object as? String
    }
    
    func JSONInt(object: AnyObject?) -> Int? {
        return object as? Int
    }
    
    func JSONDictionary(object: AnyObject?) -> [String:AnyObject]? {
        return object as? [String:AnyObject]
    }
    
    func JSONArray(object: AnyObject?) -> NSArray? {
        return object as? NSArray
    }
    
    func JSONBool(object: AnyObject?) -> Bool? {
        return object as? Bool
    }
    
}
