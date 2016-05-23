//
//  AlertManager.swift
//  LuggBug
//
//  Created by Mindbowser on 05/03/15.
//  Copyright (c) 2015 Mindbowser Infosolutions. All rights reserved.
//

import UIKit

class AlertManager: NSObject {
    
    typealias AlertCompletionHandler = (clickedButtonTitle:String, success:Bool?) -> Void
    var completionHandler: AlertCompletionHandler?
    
    class var sharedInstance :AlertManager {
        struct Singleton {
            static let instance = AlertManager()
        }
        return Singleton.instance
    }
    
    func showMessage(title: String, message: String) {
        dispatch_async(dispatch_get_main_queue(), {
            if #available(iOS 8.0, *) {
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
                
                let okAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                alertController.addAction(okAction)
                
                var viewController = UIApplication.sharedApplication().delegate?.window??.rootViewController
                while ((viewController?.presentedViewController) != nil) {
                    viewController = viewController?.presentedViewController;
                }
                
                viewController?.presentViewController(alertController, animated: true, completion: nil)
            } else {
                // Fallback on earlier versions
                
                let alertView = UIAlertView()
                alertView.title = title
                alertView.message = message
                alertView.addButtonWithTitle("OK")
                alertView.alertViewStyle = .Default
                alertView.show()
            }
        })
    }
    
    func showErrorMessage(message:String) {
        showMessage("Error", message: message)
    }
    
    func showAlert(title: String, message: String, buttonTitles: [String], viewController: UIViewController, completionHandler: AlertCompletionHandler) {
        
        self.completionHandler = completionHandler
        
        if #available(iOS 8.0, *) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            
            var buttonIndex = 0
            for buttonTitle in buttonTitles {
                let cancelAction = UIAlertAction(title: buttonTitle, style: .Default) { (action) in
                    self.completionHandler!(clickedButtonTitle: buttonTitle, success: true)
                }
                alertController.addAction(cancelAction)
                buttonIndex++
            }
            
            viewController.presentViewController(alertController, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
            let alertView = UIAlertView()
            alertView.title = title
            alertView.message = message
            
            for buttonTitle in buttonTitles {
                alertView.addButtonWithTitle(buttonTitle)
            }
            
            alertView.alertViewStyle = .Default
            alertView.delegate = self
            alertView.show()
        }
    }
    
    // MARK: UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        let buttonTitle = alertView.buttonTitleAtIndex(buttonIndex)
        self.completionHandler!(clickedButtonTitle: buttonTitle!, success: true)
    }
}
