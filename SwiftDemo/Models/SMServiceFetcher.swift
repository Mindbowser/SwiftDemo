//
//  SMServiceFetcher.swift
//  SwiftDemo
//
//  Created by Mindbowser on 18/04/16.
//  Copyright © 2016 Mindbowser. All rights reserved.
//

import UIKit

class SMServiceFetcher: NSObject {
    let kHTTPMethodGet  = "GET"
    let kHTTPMethodPost = "POST"
    let kHTTPMethodPut  = "PUT"
    let kHTTPMethodDelete  = "DELETE"
    
    func registerUser(userInfo: [String:AnyObject]) -> AnyObject? {
        return executeService(kSMServicePathSignUp, requestInfo: userInfo, httpMethod: kHTTPMethodPost)
    }
    
    func loginUser(userInfo: [String:AnyObject]) -> AnyObject? {
        return executeService(kSMServicePathLogin, requestInfo: userInfo, httpMethod: kHTTPMethodPut)
    }
    
    func editProfile(userInfo: [String:AnyObject]) -> AnyObject? {
        return executeService(kSMServicePathEditProfile, requestInfo: userInfo, httpMethod: kHTTPMethodPost)
    }
    
    private func executeService(servicePath: String, requestInfo: AnyObject?, httpMethod: String) -> AnyObject? {
        
        let urlAsString : String = kSMServiceStagingURL + servicePath
        print("Service Path : \(urlAsString)")
        let url: NSURL = NSURL(string: urlAsString)!
        
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest()
        urlRequest.URL = url
        urlRequest.HTTPMethod = httpMethod
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("en", forHTTPHeaderField: "Accept-Language")
        urlRequest.timeoutInterval = 30
        
        if servicePath != kSMServicePathLogin || servicePath != kSMServicePathSignUp {
            let authToken: String? = NSUserDefaults.standardUserDefaults().objectForKey(kSMServiceUserInfoAuthToken) as? String
            if let authToken = authToken {
                print("authToken \(authToken)")
                urlRequest.setValue(authToken, forHTTPHeaderField: "authToken")
            } else {
                print("No authToken found")
            }
        }
        
        print("requestInfo \(requestInfo)")
        
        var error: NSError?
        if urlRequest.HTTPMethod == kHTTPMethodPost || urlRequest.HTTPMethod == kHTTPMethodPut  {
            var requestData: NSData!
            do {
                requestData = try NSJSONSerialization.dataWithJSONObject(requestInfo!, options: NSJSONWritingOptions.PrettyPrinted) as NSData!
                print("requestData \(requestData)")
                urlRequest.HTTPBody = requestData
            } catch {
                print("Fetch failed: \((error as NSError).localizedDescription)")
            }
            print("Sent Data : \(requestInfo)")
        }
        
        var response: NSURLResponse?
        var responseInfo: AnyObject?
        
        //TODO: NSURLSession is recommanded from iOS 7
        //        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(responseData, response, error) in
        //            println(NSString(data: responseData, encoding: NSUTF8StringEncoding))
        //            let jsonObject : AnyObject! = NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableContainers, error: nil)
        //            println("\n\n")
        //            println("jsonObject: %@", jsonObject)
        //        }
        //        task.resume()
        
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return nil
        }
        
        if reachability.isReachable() {
            let rd: NSData?
            do {
                rd = try NSURLConnection.sendSynchronousRequest(urlRequest, returningResponse: &response)
            } catch let error1 as NSError {
                error = error1
                rd = nil
            }
            
            if let responseData = rd {
                let datastring = NSString(data: responseData, encoding: NSUTF8StringEncoding)
                print(datastring)
                responseInfo = try? NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableContainers)
                if let responseInfo: AnyObject = responseInfo {
                    print("jsonObject: \(responseInfo)")
                    
                    if responseInfo["error"] != nil {
                        let massageInfo : AnyObject? = responseInfo["error"]
                        if let errorMessage:String = massageInfo?["message"] as? String {
//                            if errorMessage == kInvalidUser {
//                                NSUserDefaults.standardUserDefaults().setBool(true, forKey: kSMServiceUserInvalid)
//                                NSUserDefaults.standardUserDefaults().synchronize()
//                                self.clearData()
//                            }
                            print(errorMessage)
                        }
                    }
                    return responseInfo
                }
            } else {
                print("Something went wrong. Request count not be sent to server.")
                print(error)
                let errorMessageInfo = [kSMServiceResponseParameterMessage:error!.localizedDescription]
                
                let responseInfo:[String:AnyObject] = [kSMServiceResponseObjectError:errorMessageInfo,kSMServiceResponseParameterStatus:kSMServiceResponseParameterStatusFail]
                return responseInfo
            }
        } else  {
            let errorMessageInfo = [kSMServiceResponseParameterMessage:kSMMessageNoInternetConnection]
            let responseInfo:[String:AnyObject] = [kSMServiceResponseObjectError:errorMessageInfo,kSMServiceResponseParameterStatus:kSMServiceResponseParameterStatusFail]
            return responseInfo
        }
        
        return nil
    }
}
