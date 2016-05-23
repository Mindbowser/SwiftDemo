//
//  SMAppUser.swift
//  SwiftDemo
//
//  Created by Mindbowser on 19/04/16.
//  Copyright © 2016 Mindbowser. All rights reserved.
//

import UIKit

class SMAppUser: NSObject {
    
    class var sharedInstance : SMAppUser {
        struct Singleton {
            static let instance = SMAppUser()
        }
        return Singleton.instance
    }
    
    var name = ""
    var emailAddress = ""
    var gender = ""
    
    func setupAppUser() {
        
        //TODO: Implement encoder and decoder methods
        
//        let userData = NSUserDefaults.standardUserDefaults().objectForKey("AppUser")
//        if let userData = userData {
//            let user = NSKeyedUnarchiver.unarchiveObjectWithData(userData as! NSData)
//            if let user = user {
        if let name = NSUserDefaults.standardUserDefaults().objectForKey(kSMServiceRegisterRequestParameterName) as? String {
            self.name = name
        }
        
        if let emailId = NSUserDefaults.standardUserDefaults().objectForKey(kSMServiceRegisterRequestParameterEmailId) as? String {
            self.emailAddress = emailId
        }
        
        if let gender = NSUserDefaults.standardUserDefaults().objectForKey(kSMServiceRegisterRequestParameterGender) as? String {
                self.gender = gender
        }
//            }
//        }
    }
    
    func save() {
//        NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(self), forKey: "AppUser")
//        NSUserDefaults.standardUserDefaults().synchronize()
        
        NSUserDefaults.standardUserDefaults().setObject(name, forKey: kSMServiceRegisterRequestParameterName)
        NSUserDefaults.standardUserDefaults().setObject(emailAddress, forKey: kSMServiceRegisterRequestParameterEmailId)
        NSUserDefaults.standardUserDefaults().setObject(gender, forKey: kSMServiceRegisterRequestParameterGender)
    }
    
    
//    func encodeWithCoder(aCoder: NSCoder) {
//        aCoder.encodeObject(name, forKey: kSMServiceRegisterRequestParameterName)
//        aCoder.encodeObject(gender, forKey: kSMServiceRegisterRequestParameterGender)
//        aCoder.encodeObject(emailAddress, forKey: kSMServiceRegisterRequestParameterEmailId)
//    }
//    
//    required convenience init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.name = aDecoder.decodeObjectForKey("name") as! String
//        
//    }
}
