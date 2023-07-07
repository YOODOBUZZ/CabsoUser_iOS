//
//  LoginWebServices.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 22/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
import Alamofire

class LoginWebServices: BaseWebService {

    //MARK: Signup web service
    public func signUpService(full_name:String,email:String,password:String,imageurl:String,type:String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        let requestDict = NSMutableDictionary.init()
            requestDict.setValue(full_name, forKey: "full_name")
            requestDict.setValue(email, forKey: "email")
            requestDict.setValue(password, forKey: "password")
        if type == "social" {
            requestDict.setValue(imageurl, forKey: "imageurl")
        }
        self.baseService(subURl: SIGN_UP_API, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //MARK: Signin web service
    public func signInService(email:String,password:String,country_code:String,phone_no:String,type:String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(email, forKey: "email")
        requestDict.setValue(password, forKey: "password")
        if type == "withphone" {
            requestDict.setValue(country_code, forKey: "country_code")
            requestDict.setValue(phone_no, forKey: "phone_number")
        }
        self.baseService(subURl: SIGN_IN_API, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //MARK: Terms of service
    public func getHelpDetails(onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        self.getBaseService(subURl:HELP_API , onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    //MARK: admin data
    public func getAdminData(onSuccess success: @escaping (NSDictionary) -> Void) {
        self.getBaseService(subURl:ADMINDATA_API , onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    
}
