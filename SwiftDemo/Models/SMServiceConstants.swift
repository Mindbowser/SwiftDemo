//
//  SMServiceConstants.swift
//  SwiftDemo
//
//  Created by Mindbowser on 18/04/16.
//  Copyright © 2016 Mindbowser. All rights reserved.
//

import UIKit

let kSMServiceStagingURL = "http://testapi.mangomirror.com"

let kSMServicePathSignUp = "/user/signUp/"
let kSMServicePathLogin = "/user/logIn/"
let kSMServicePathEditProfile = "/user/editProfile/"

let kSMServicePathLogout = "/auth/log-out"
let kSMServicePathForgotPassword = "/auth/forgot-password/"



//MARK: SM Service Response Parameters

let kSMServiceUserInfoAuthToken = "authToken"

let kSMServiceResponseObjectError = "error"
let kSMServiceResponseParameterMessage = "message"
let kSMServiceResponseParameterStatus = "status"
let kSMServiceResponseObjectUserInfo = "object"

let kSMServiceResponseBeaconList = "beaconsList"
let kSMServiceResponseDeviceList = "deviceList"


let kSMServiceResponseParameterStatusFail = "FAIL"
let kSMServiceResponseParameterStatusSuccess = "SUCCESS"


//MARK: SM Service Register Parameters

//Request parameters
let kSMServiceRegisterRequestParameterEmailId = "emailId"
let kSMServiceRegisterRequestParameterPassword = "password"
let kSMServiceRegisterRequestParameterName = "name"
let kSMServiceRegisterRequestParameterGender = "gender"

//Response parameters
let kSMServiceRegisterResponseParameterUserInfo = "object"
let kSMServiceRegisterResponseParameterUserInfoToken = "token"
