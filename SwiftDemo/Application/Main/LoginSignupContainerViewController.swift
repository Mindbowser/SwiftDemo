//
//  LoginSignupContainerViewController.swift
//  SwiftDemo
//
//  Created by Mindbowser on 19/04/16.
//  Copyright © 2016 Mindbowser. All rights reserved.
//

import UIKit

class LoginSignupContainerViewController: UIViewController, LoginViewControllerDelegate {

    var signUpViewController = RegistrationTableViewController()
    var loginViewController  = LoginTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpViewController = self.storyboard?.instantiateViewControllerWithIdentifier("RegistrationTableViewController") as! RegistrationTableViewController
        signUpViewController.delegate = self
        
        loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginTableViewController") as! LoginTableViewController
        loginViewController.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = true
        
        // If user has loggin in once from this device, show login view controller
        let hasLoggedInOnce: Bool? = NSUserDefaults.standardUserDefaults().objectForKey("loggedInOnce") as? Bool
        if  hasLoggedInOnce == true {
            activeViewController = loginViewController
        } else {
            activeViewController = signUpViewController
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    private var activeViewController: UIViewController? {
        didSet {
            removeInactiveViewController(oldValue)
            updateActiveViewController()
        }
    }
    
    private func removeInactiveViewController(inactiveViewController: UIViewController?) {
        if let inActiveVC = inactiveViewController {
            // call before removing child view controller's view from hierarchy
            inActiveVC.willMoveToParentViewController(nil)
            
            inActiveVC.view.removeFromSuperview()
            
            // call after removing child view controller's view from hierarchy
            inActiveVC.removeFromParentViewController()
        }
    }
    
    private func updateActiveViewController() {
        if let activeVC = activeViewController {
            // call before adding child view controller's view as subview
            addChildViewController(activeVC)
            
            activeVC.view.frame = self.view.bounds
            activeVC.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            activeVC.view.translatesAutoresizingMaskIntoConstraints = true

            self.view.addSubview(activeVC.view)
            
            // call before adding child view controller's view as subview
            activeVC.didMoveToParentViewController(self)
        }
    }
    
    //MARK: Login View Controller Delegate
    
    func userDidLogin() {
        self.performSegueWithIdentifier("HomeViewControllerSegue", sender: self)
    }
    
    func shouldShowLoginScreen() {
        activeViewController = loginViewController
    }
    
    func shouldShowSignUpScreen() {
        activeViewController = signUpViewController
    }
    
}
