//
//  UserServices.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 24/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
import Alamofire

class UserServices: BaseWebService {
    //MARK: notification service
    public func getProfileInfo(onSuccess success: @escaping (NSDictionary) -> Void) {
        self.getBaseService(subURl: ("\(PROFILE_API)/\(UserModel.shared.userID()!)"), onSuccess: {response in
            success(response)
        },onFailure: {errorResponse in
        })
    }
    //MARK: notification service
    public func getNotifications(onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        self.getBaseService(subURl: ("\(NOTIFICATION_API)/\(UserModel.shared.userID()!)"), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    //MARK: edit phone number service
    public func updatePhoneNumber(country_code:String,phone_no:String, onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(country_code, forKey: "country_code")
        requestDict.setValue(phone_no, forKey: "phone_number")
        self.baseService(subURl: UPDATE_PROFILE_API, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    
    //MARK: update name service
    public func updateName(name:String, onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(name, forKey: "full_name")
        self.baseService(subURl: UPDATE_PROFILE_API, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }

    //Saved placed service
    public func savedPlaces(onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        self.baseService(subURl: SAVED_PLACES_API, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    
    public func addPlace(firstAdd:String,fullAdd:String,lat:String,lng:String,place_type:String,place_id:String, onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(firstAdd, forKey: "place_name")
        requestDict.setValue(fullAdd, forKey: "place_full_address")
        requestDict.setValue(lat, forKey: "place_latitude")
        requestDict.setValue(lng, forKey: "place_longitude")
        requestDict.setValue(place_type, forKey: "place_type")
        requestDict.setValue("add", forKey: "type")
        requestDict.setValue(place_id, forKey: "google_place_id")

        self.baseService(subURl: ADD_PLACES_API, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    
    public func removePlace(place_id:String, onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue("remove", forKey: "type")
        requestDict.setValue(place_id, forKey: "google_place_id")
        self.baseService(subURl: ADD_PLACES_API, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    //change password service
    public func changePassword(new_password:String, onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(new_password, forKey: "newpassword")
        self.baseService(subURl: CHANGE_PASSWORD_API, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    //RESET password service
    public func resetPassword(email:String, onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(email, forKey: "email")
        self.baseService(subURl: RESET_PASSWORD_API, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    // ADD,EDIT,DELETE emergency contact
    public func updateEmergecyContact(emergencyContact:NSArray, onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(self.json(from: emergencyContact), forKey: "emergency_contact")
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        self.baseService(subURl: UPDATE_PROFILE_API, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    // Contact submit querty
    public func contactUs(name:String,email:String,subject:String,message:String, onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(name, forKey: "name")
        requestDict.setValue(subject, forKey: "subject")
        requestDict.setValue(message, forKey: "message")
        requestDict.setValue(email, forKey: "email")
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        self.baseService(subURl: CONTACT_API, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    
    //register for push services
    public func registerForNotification(onSuccess success: @escaping (NSDictionary) -> Void) {
        // Prepare params
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UIDevice.current.identifierForVendor!.uuidString, forKey: "device_id")
        requestDict.setValue(DEVICE_MODE, forKey: "device_mode")
        requestDict.setValue("0", forKey: "device_type")
        requestDict.setValue(UserModel.shared.getFCMToken()! as String, forKey: "device_token")
        requestDict.setValue(UserModel.shared.getVOIPToken() as String? ?? "", forKey: "voip_token")
        //requestDict.setValue(UserModel.shared.getAccessToken() as String? ?? "", forKey: "user_accessToken")
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(UserModel.shared.LANGUAGE_CODE, forKey: "lang_type")

        print("user id\(UserModel.shared.userID() ?? EMPTY_STRING as NSString)")
        //make base method call
        self.baseService(subURl: PUSH_SIGNIN_API, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    
    //unregister for notification
    public func pushSignoutService(onSuccess success: @escaping (NSDictionary) -> Void) {
        // Prepare params
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UIDevice.current.identifierForVendor!.uuidString, forKey: "device_id")
        //make base method call
        self.deleteMethod(subURl: PUSH_SIGNOUT_API, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            
        })
    }
    
    public func deleteAccountService(onSuccess success: @escaping (NSDictionary) -> Void) {
        // Prepare params
        
        
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        
        self.baseService(subURl: ACCOUNT_DELETE_API, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
          
        })
        
        

    }
    
    
    //get formatted json from array
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
}
