//
//  HomeViewController.swift
//  SwiftDemo
//
//  Created by Mindbowser on 19/04/16.
//  Copyright © 2016 Mindbowser. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "loggedInOnce")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        self.title = "Smart Mirror"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "logout", name: "LogoutUser", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        setupNavigationBarButtons()
        
    }
    
    func setupNavigationBarButtons() {
        let profileBarButton = UIBarButtonItem(title: "Profile", style: .Plain, target: self, action: "profileBarButtonClicked")
        self.navigationItem.leftBarButtonItem = profileBarButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func profileBarButtonClicked() {
        self.performSegueWithIdentifier("profileScreenSegue", sender: self)
    }

    func logout() {
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: kSMServiceUserInfoAuthToken)
        NSUserDefaults.standardUserDefaults().synchronize()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

}
