//
//  LoginTableViewController.swift
//  SwiftDemo
//
//  Created by Mindbowser on 19/04/16.
//  Copyright © 2016 Mindbowser. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate: class {
    func userDidLogin()
    func shouldShowLoginScreen()
    func shouldShowSignUpScreen()
}

class LoginTableViewController: UITableViewController {

    @IBOutlet weak var emailIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgetPasswordButton: UIButton!
    
    weak var delegate: LoginViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDesign()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupDesign() {
        
        continueButton.backgroundColor = UIColor(red: 0, green: 181/255, blue: 108/255, alpha: 1)
    
    }
    
    @IBAction func continueButtonClicked(sender: AnyObject) {
        if !self.emailIDTextField.text!.isValidEmail() {
            AlertManager.sharedInstance.showErrorMessage("Please enter valid email address")
        } else if self.emailIDTextField.text == "" {
            AlertManager.sharedInstance.showErrorMessage("Email address should not be empty")
        } else if self.passwordTextField.text == "" {
            AlertManager.sharedInstance.showErrorMessage("Please enter valid password")
        } else {
            
            let userInfo:[String:AnyObject] = [kSMServiceRegisterRequestParameterEmailId:self.emailIDTextField.text!.lowercaseString,
                kSMServiceRegisterRequestParameterPassword:self.passwordTextField.text!]
            
            let progressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            progressHUD.dimBackground = true
            
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                let success = SMServiceManager().serverLoginUser(userInfo)
                dispatch_async(dispatch_get_main_queue()) {
                    progressHUD.removeFromSuperview()
                    if success {
                        self.delegate?.userDidLogin()
                        self.passwordTextField.text = ""
                    }
                }
            }
        }
    }
    
    @IBAction func signUpButtonClicked(sender: AnyObject) {
        self.delegate?.shouldShowSignUpScreen()
    }
    
    // MARK: - Table view delegate
    
    // Override to return customised height for cells.
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // Reduce table view cell height for smaller display iPhones
        var cellsHeightContainingTextFields: CGFloat = 60
        if UIScreen.mainScreen().bounds.size.height == 568 {        // For 4 inch iPhones
            cellsHeightContainingTextFields = 54
        } else if UIScreen.mainScreen().bounds.size.height == 480 { // For 3.5 inch iPhones
            cellsHeightContainingTextFields = 44
        }
        
        if indexPath.row == 0 {
            return (tableView.frame.size.height - (cellsHeightContainingTextFields * 5))/2
        } else if indexPath.row == 3 {
            return ((tableView.frame.size.height - (cellsHeightContainingTextFields * 5))/2) + 20
        } else {
            return cellsHeightContainingTextFields
        }
    }
    
    // MARK: - UIText Field delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        // Give the control to the next text field, for last text field dismiss keyboard.
        var tag = textField.tag;
        if tag == 1 {
            textField.resignFirstResponder()
        } else {
            tag = tag + 1
            let nextTextField = tableView.viewWithTag(tag)
            if let nextTextField = nextTextField where nextTextField.isKindOfClass(UITextField) {
                nextTextField.becomeFirstResponder()
            }
        }
        
        return true
    }

}
