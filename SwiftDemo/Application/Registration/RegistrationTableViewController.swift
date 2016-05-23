//
//  RegistrationTableViewController.swift
//  SwiftDemo
//
//  Created by Mindbowser on 18/04/16.
//  Copyright © 2016 Mindbowser. All rights reserved.
//

import UIKit

class RegistrationTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailIDTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!

    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    weak var delegate: LoginViewControllerDelegate?

    var genderPickerView = UIPickerView()
    let genderDataSource = ["Male","Female","Not To Show"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDesign()
        setupPickerView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupDesign() {
        
        createButton.backgroundColor = UIColor(red: 0, green: 180/255, blue: 100/255, alpha: 1)

        //TODO: For 3.5 inch screens : Decrease all control's font, reduce "Create" button's height
        
    }
    
    @IBAction func createButtonClicked(sender: AnyObject) {
        let name = self.nameTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if name == "" {
            AlertManager.sharedInstance.showErrorMessage("Please enter your name")
        } else if !self.emailIDTextField.text!.isValidEmail() {
            AlertManager.sharedInstance.showErrorMessage("Please enter valid email address")
        } else if self.emailIDTextField.text == "" {
            AlertManager.sharedInstance.showErrorMessage("Email address should not be empty")
        } else if self.passwordTextField.text == "" {
            AlertManager.sharedInstance.showErrorMessage("Please enter valid password")
        } else if self.passwordTextField.text!.utf16.count < 4 {
            AlertManager.sharedInstance.showErrorMessage("The password you entered is too short. Please try again.")
        } else if self.confirmPasswordTextField.text != self.passwordTextField.text {
            AlertManager.sharedInstance.showErrorMessage("The passwords you entered do not match")
        } else {
            let userInfo:[String:AnyObject] = [kSMServiceRegisterRequestParameterEmailId:self.emailIDTextField.text!.lowercaseString,
                kSMServiceRegisterRequestParameterPassword:self.passwordTextField.text!,
                kSMServiceRegisterRequestParameterName:name!,
                kSMServiceRegisterRequestParameterGender:self.genderTextField.text!]

            let progressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            progressHUD.dimBackground = true
            
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                let success = SMServiceManager().serverRegisterUser(userInfo)
                dispatch_async(dispatch_get_main_queue()) {
                    progressHUD.removeFromSuperview()
                    if success {
                        self.delegate?.userDidLogin()
                        self.clearAllFields()
                    }
                }
            }
        }
    }
    
    @IBAction func loginButtonClicked(sender: AnyObject) {
        self.delegate?.shouldShowLoginScreen()
    }
    
    func clearAllFields() {
        nameTextField.text = ""
        emailIDTextField.text = ""
        genderTextField.text = ""
        passwordTextField.text = ""
        confirmPasswordTextField.text = ""
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
            // -20 is a workaround. If you add UITableViewController as a child view controller it takes 20 frop top.
            return ((tableView.frame.size.height - (cellsHeightContainingTextFields * 5))/2)
        } else if indexPath.row == 6 {
            return (tableView.frame.size.height - (cellsHeightContainingTextFields * 5))/2
        } else {
            return cellsHeightContainingTextFields
        }
    }
    
    // MARK: - UIText Field delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        // Give the control to the next text field, for last text field dismiss keyboard.
        var tag = textField.tag;
        if tag == 4 {
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
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        textField.inputAccessoryView = nil
        if textField.tag == 2 {
            textField.inputAccessoryView = inputToolbar
        }
        
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
        } else if textField == passwordTextField || textField == confirmPasswordTextField {
            if let text = textField.text {
                let newLength = text.utf8.count + string.utf8.count - range.length
                return newLength > 20 ? false : true
            }
        }
        
        return true
    }
    
    // MARK: Picker View
    
    func setupPickerView() {
        genderPickerView = UIPickerView()
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        
        self.genderTextField.inputView = self.genderPickerView
    }
    
    lazy var inputToolbar: UIToolbar = {
        var toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Bordered, target: self, action: "inputToolbarDonePressed")
        var spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([spaceButton, doneButton], animated: false)
        toolbar.userInteractionEnabled = true
        
        return toolbar
    }()
    
    func inputToolbarDonePressed() {
        self.passwordTextField.becomeFirstResponder()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderDataSource.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderDataSource[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.genderTextField.text = genderDataSource[row]
    }
}
