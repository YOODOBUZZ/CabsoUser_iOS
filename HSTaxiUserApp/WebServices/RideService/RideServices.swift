//
//  RideServices.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 10/04/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
import CoreLocation

class RideServices: BaseWebService {
    
    // grab rides
    public func grabRides(pickup_location:String,pickup_coordinate:CLLocationCoordinate2D,drop_location:String,drop_coordinate:CLLocationCoordinate2D,km:String, onSuccess success: @escaping (NSDictionary) -> Void) {
        
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(pickup_location, forKey: "pickup_location")
        requestDict.setValue(drop_location, forKey: "drop_location")
        requestDict.setValue(pickup_coordinate.latitude, forKey: "pickup_lat")
        requestDict.setValue(pickup_coordinate.longitude, forKey: "pickup_lng")
        requestDict.setValue(drop_coordinate.latitude, forKey: "drop_lat")
        requestDict.setValue(drop_coordinate.longitude, forKey: "drop_lng")
        requestDict.setValue(km, forKey: "distance")
        
//        requestDict.setValue("64a2c2a085004ee13ddc89d9", forKey: "user_id")
//        requestDict.setValue("6599+Q47", forKey: "pickup_location")
//        requestDict.setValue("Chennai International Airport", forKey: "drop_location")
//        requestDict.setValue(Double(11.21939991678199), forKey: "pickup_lat")
//        requestDict.setValue(Double(78.16780004650354", forKey: "pickup_lng")
//        requestDict.setValue("80.1708668", forKey: "drop_lat")
//        requestDict.setValue("12.994112", forKey: "drop_lng")
//        requestDict.setValue("348 km", forKey: "distance")
        
        self.baseService(subURl: GRAP_RIDES_API, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    
    // confirmride abt driver
    public func requestForRide(category_id:String,payment_type:String,type:String,schedule_time:String,pickup_location:String,drop_location:String,pickup_coordinate:CLLocationCoordinate2D,drop_coordinate:CLLocationCoordinate2D,baseprice:String,shedule_utc_time:String, onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(category_id, forKey: "category_id")
        requestDict.setValue(payment_type, forKey: "payment_type")
        requestDict.setValue(type, forKey: "type")
        requestDict.setValue(baseprice, forKey: "baseprice")
        requestDict.setValue(schedule_time, forKey: "schedule_time")
        requestDict.setValue(shedule_utc_time, forKey: "schedule_utc_time")
        
        requestDict.setValue(pickup_location, forKey: "pickup_location")
        requestDict.setValue(pickup_coordinate.latitude, forKey: "pickup_lat")
        requestDict.setValue(pickup_coordinate.longitude, forKey: "pickup_lng")
        requestDict.setValue(drop_location, forKey: "drop_location")
        requestDict.setValue(drop_coordinate.latitude, forKey: "drop_lat")
        requestDict.setValue(drop_coordinate.longitude, forKey: "drop_lng")
        self.baseService(subURl: REQUEST_RIDE_API, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    
    // Ride now
    public func confirmRide(onride_id:String,isNotify:String,carmake:String,carmodel:String,carcolor:String, onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(onride_id, forKey: "onride_id")
        requestDict.setValue(isNotify, forKey: "is_notify")
        requestDict.setValue(carmake, forKey: "make")
        requestDict.setValue(carmodel, forKey: "model")
        requestDict.setValue(carcolor, forKey: "color")
        self.baseService(subURl: CONFIRM_RIDE_API, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    
    // get ride details
    public func getRideDetails(onride_id:String,type:String, onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(onride_id, forKey: "onride_id")
        requestDict.setValue(type, forKey: "type")
        self.baseService(subURl: RIDE_DETAILS_API, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    
    // No one accept
    public func noOneAccept(onride_id:String,onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(onride_id, forKey: "onride_id")
        self.baseService(subURl: NO_ONE_ACCEPT_API, params: requestDict as! Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    // cancel ride
    public func cancelRide(onride_id:String,onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(onride_id, forKey: "onride_id")
        self.baseService(subURl: CANCEL_RIDE_API, params: requestDict as! Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    
    // completed ride details
    public func getCompletedRideDetails(onride_id:String,onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(onride_id, forKey: "onride_id")
        self.baseService(subURl: COMPLETE_RIDE_API, params: requestDict as! Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    
    
    // Ride review abt driver
    public func rideReview(onride_id:String,review_message:String,rating:String, onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(onride_id, forKey: "onride_id")
        requestDict.setValue(review_message, forKey: "review_message")
        requestDict.setValue(rating, forKey: "rating")
        self.baseService(subURl: RIDE_REVIEW_API, params: requestDict as! Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    
    // ride history
    public func rideHistory(type:String,onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(type, forKey: "type")
        self.baseService(subURl: RIDE_HISTORY_API, params: requestDict as! Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    
    // MakeCall
    public func makeCall(sender_id:String,receiver_id:String,room_id:String, onSuccess success: @escaping (NSDictionary) -> Void) {
        let time = NSDate().timeIntervalSince1970
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(sender_id, forKey: "sender_id")
        requestDict.setValue(receiver_id, forKey: "receiver_id")
        requestDict.setValue("user", forKey: "user_type")
        requestDict.setValue(room_id, forKey: "room_id")
        requestDict.setValue("ios", forKey: "platform")
        requestDict.setValue("call", forKey: "type")

        requestDict.setValue("\(time)", forKey: "timestamp")
        self.baseService(subURl: MAKE_CALL_API, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    public func endCall(sender_id:String,receiver_id:String,room_id:String, onSuccess success: @escaping (NSDictionary) -> Void) {
        //        Param: sender_id, receiver_id, room_id, platform, timestamp, user_type
        let time = NSDate().timeIntervalSince1970
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(sender_id, forKey: "sender_id")
        requestDict.setValue(receiver_id, forKey: "receiver_id")
        requestDict.setValue("user", forKey: "user_type")
        requestDict.setValue(room_id, forKey: "room_id")
        requestDict.setValue("ios", forKey: "platform")
        requestDict.setValue("bye", forKey: "type")
        requestDict.setValue("\(time.rounded().clean)", forKey: "timestamp")
        self.baseService(subURl: END_CALL_API, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
}
