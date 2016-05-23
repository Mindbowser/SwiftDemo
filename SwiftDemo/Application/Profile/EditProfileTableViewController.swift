//
//  EditProfileTableViewController.swift
//  SwiftDemo
//
//  Created by Mindbowser on 20/04/16.
//  Copyright © 2016 Mindbowser. All rights reserved.
//

import UIKit

class EditProfileTableViewController: UITableViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Edit Profile"
        
        //FIXME: Should have enum for gender
        let gender = SMAppUser.sharedInstance.gender
        if gender == "Male" {
            genderSegmentedControl.selectedSegmentIndex = 0
        } else if gender == "Female" {
            genderSegmentedControl.selectedSegmentIndex = 1
        } else {
            genderSegmentedControl.selectedSegmentIndex = 2
        }
        
        self.nameTextField.text = SMAppUser.sharedInstance.name
        self.nameTextField.placeholder = SMAppUser.sharedInstance.name
        self.nameTextField.clearButtonMode = .WhileEditing
        
        setupNavigationBarButtons()
    }
    
    func setupNavigationBarButtons() {
        let saveBarButton = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "saveBarButtonClicked")
        self.navigationItem.rightBarButtonItem = saveBarButton
    }
    
    override func viewDidAppear(animated: Bool) {
        self.nameTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveBarButtonClicked() {
        let name = self.nameTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if name == "" {
            AlertManager.sharedInstance.showErrorMessage("Please enter your name")
        } else {
            
            var gender = ""
            switch self.genderSegmentedControl.selectedSegmentIndex {
            case 0 :
                gender = "Male"
            case 1 :
                gender = "Female"
            case 2 :
                gender = "Not To Show"
            default :
                gender = ""
            }
            
            // Do not hit the server if there is no change
            if SMAppUser.sharedInstance.name != name || SMAppUser.sharedInstance.gender != gender {
            
                self.nameTextField.resignFirstResponder()
            
                let userInfo:[String:AnyObject] = [kSMServiceRegisterRequestParameterName:name!,
                    kSMServiceRegisterRequestParameterGender:gender]
                
                let progressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                progressHUD.dimBackground = true
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    let success = SMServiceManager().serverEditProfile(userInfo)
                    dispatch_async(dispatch_get_main_queue()) {
                        progressHUD.removeFromSuperview()
                        if success {
                            SMAppUser.sharedInstance.name = name!
                            SMAppUser.sharedInstance.gender = gender
                            
                            AlertManager.sharedInstance.showMessage("", message: "Your changes saved successfully")
                        }
                    }
                }
            }
        }

    }

    // MARK: - UIText Field delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField == nameTextField {
            if let text = textField.text {
                let aText = text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                let newLength = aText.utf8.count + string.utf8.count - range.length
                let validLimit = newLength > 50 ? false : true
                
                var validString = true
                let blockedCharacters = NSCharacterSet.letterCharacterSet().invertedSet
                if string.rangeOfCharacterFromSet(blockedCharacters) != nil {
                    validString = false
                }
                
                if string == " " {
                    validString = true
                }
                
                if !validString || !validLimit {
                    return false
                }
            }
        }
        
        return true
    }

}
