//
//  ProfileTableViewController.swift
//  SwiftDemo
//
//  Created by Mindbowser on 20/04/16.
//  Copyright © 2016 Mindbowser. All rights reserved.
//

import UIKit

protocol ProfileTableViewControllerDelegate: class {
    func profileViewControllerDidClickLogout()
    func profileViewControllerDidClickHome()
}

class ProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailIdLabel: UILabel!

    weak var delegate: ProfileTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarButtons()
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.nameLabel.text = SMAppUser.sharedInstance.name
        self.emailIdLabel.text = SMAppUser.sharedInstance.emailAddress
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupNavigationBarButtons() {
        self.title = "Profile"
        
        let profileBarButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logoutBarButtonClicked")
        self.navigationItem.leftBarButtonItem = profileBarButton
        
        let homeBarButton = UIBarButtonItem(title: "Home", style: .Plain, target: self, action: "homeBarButtonClicked")
        self.navigationItem.rightBarButtonItem = homeBarButton
    }
    
    func logoutBarButtonClicked() {
        // Take user to the login screen
        self.dismissViewControllerAnimated(true) { () -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName("LogoutUser", object: nil)
        }
    }
    
    func homeBarButtonClicked() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UITableView Delegates
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
