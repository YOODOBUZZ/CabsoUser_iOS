//
//  GoogleLocationService.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 19/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class GoogleLocationService: BaseWebService {

    
    public func getlocationFromAddress(address:String, onSuccess success: @escaping (NSDictionary) -> Void) {
        let urlString:String = "https://maps.google.com/maps/api/geocode/json?sensor=false&address=\(address)&key=\(GOOGLE_API_KEY)"
        let finalURL =  urlString.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)
        let GetBaseUrl = URL(string: finalURL!)!

        print("BASE URL : \(String(describing: GetBaseUrl))")
        if Utility().isConnectedToNetwork(){
            //webservice call
            Alamofire.request(GetBaseUrl, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).responseJSON(completionHandler: {response in
                let JSON = response.result.value as? NSDictionary
                
                switch response.result {
                case .success:
                    print("RESPONSE SUCCESS: \(JSON!)")
                    success(JSON!)
                    break
                case .failure(let error):
                    print("FAILURE RESPONSE: \(error.localizedDescription)")
                    HPLActivityHUD.dismiss()
                    if error._code == NSURLErrorTimedOut{
                        Utility.shared.showAlert(msg: "timed_out", status: "")
                    }else if error._code == NSURLErrorNotConnectedToInternet{
                        Utility.shared.goToOffline()
                    }else{
                        Utility.shared.showAlert(msg: "timed_out", status: "")
                    }
                }
            })
        }else{
            HPLActivityHUD.dismiss()
            Utility.shared.goToOffline()
        }
    }
    
    public func getlocationFromCordination(coordinate:CLLocationCoordinate2D, onSuccess success: @escaping (NSDictionary) -> Void) {
//        https://maps.googleapis.com/maps/api/geocode/json?latlng=9.935620789542181,78.13100181519985&sensor=true&key=AIzaSyDx9DJvD5sAl0yrxidafpOM9H0breh2dbw
//        https://maps.googleapis.com/maps/api/geocode/json?latlng=9.935699388494497,78.13103802502155&sensor=false&key=AIzaSyDx9DJvD5sAl0yrxidafpOM9H0breh2dbw
        let urlString:String = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(coordinate.latitude),\(coordinate.longitude)&sensor=true&key=\(GOOGLE_API_KEY)"
        
        let finalURL =  urlString.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)
        let GetBaseUrl = URL(string: finalURL!)!
        
        print("BASE URL : \(String(describing: GetBaseUrl))")
        if Utility().isConnectedToNetwork(){
            //webservice call
            Alamofire.request(GetBaseUrl, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).responseJSON(completionHandler: {response in
                let JSON = response.result.value as? NSDictionary
                
                switch response.result {
                case .success:
                    print("RESPONSE SUCCESS: \(JSON!)")
                    success(JSON!)
                    break
                case .failure(let error):
                    print("FAILURE RESPONSE: \(error.localizedDescription)")
                    HPLActivityHUD.dismiss()
                    if error._code == NSURLErrorTimedOut{
                        Utility.shared.showAlert(msg: "timed_out", status: "")
                    }else if error._code == NSURLErrorNotConnectedToInternet{
                        Utility.shared.goToOffline()
                    }else{
                        Utility.shared.showAlert(msg: "server_alert", status: "")
                    }
                }
            })
        }else{
            HPLActivityHUD.dismiss()
            Utility.shared.goToOffline()
        }
    }

    public func getLocation(destinationCoordination:CLLocationCoordinate2D,pickupCoordination:CLLocationCoordinate2D, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        
        let GetBaseUrl = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(pickupCoordination.latitude),\(pickupCoordination.longitude)&destination=\(destinationCoordination.latitude),\(destinationCoordination.longitude)&sensor=false&key=\(GOOGLE_API_KEY)&mode=driving")!

        print("BASE URL : \(String(describing: GetBaseUrl))")
        
        if Utility().isConnectedToNetwork(){
            //webservice call
            Alamofire.request(GetBaseUrl, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).responseJSON(completionHandler: {response in
                let JSON = response.result.value as? NSDictionary
             
                switch response.result {
                case .success:
                    print("RESPONSE SUCCESS: \(JSON!)")
                    success(JSON!)
                    break
                case .failure(let error):
                    print("FAILURE RESPONSE: \(error.localizedDescription)")
                    HPLActivityHUD.dismiss()
                    if error._code == NSURLErrorTimedOut{
                        Utility.shared.showAlert(msg: "timed_out", status: "")
                    }else if error._code == NSURLErrorNotConnectedToInternet{
                        Utility.shared.goToOffline()
                    }else{
                        Utility.shared.showAlert(msg: "server_alert", status: "")
                    }
                }
            })
        }else{
            HPLActivityHUD.dismiss()
            Utility.shared.goToOffline()
        }
        
    }
    
    //get distance from pickup and drop
    public func getDistance(drop:CLLocationCoordinate2D,pickup:CLLocationCoordinate2D, onSuccess success: @escaping (NSDictionary) -> Void) {
        let GetBaseUrl = URL(string: "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(pickup.latitude),\(pickup.longitude)&destinations=\(drop.latitude),\(drop.longitude)&sensor=false&key=\(GOOGLE_API_KEY)&mode=driving")!
        print("BASE URL : \(String(describing: GetBaseUrl))")
        if Utility().isConnectedToNetwork(){
            //webservice call
            Alamofire.request(GetBaseUrl, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).responseJSON(completionHandler: {response in
                let JSON = response.result.value as? NSDictionary
                switch response.result {
                case .success:
                    print("RESPONSE SUCCESS: \(JSON!)")
                    success(JSON!)
                    break
                case .failure(let error):
                    print("FAILURE RESPONSE: \(error.localizedDescription)")
                    HPLActivityHUD.dismiss()
                    if error._code == NSURLErrorTimedOut{
                        Utility.shared.showAlert(msg: "timed_out", status: "")
                    }else if error._code == NSURLErrorNotConnectedToInternet{
                        Utility.shared.goToOffline()
                    }else{
                        Utility.shared.showAlert(msg: "server_alert", status: "")
                    }
                }
            })
        }else{
            HPLActivityHUD.dismiss()
            Utility.shared.goToOffline()
        }
        
    }
}
