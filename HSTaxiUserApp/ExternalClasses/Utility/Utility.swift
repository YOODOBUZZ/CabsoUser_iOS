//
//  Utility.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 09/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
import SystemConfiguration

class Utility: NSObject {
    
    static let shared = Utility()
    static let language = Utility().getLanguage()
    
    //MARK: Configure app language
    func configureLanguage()  {
        if let path = Bundle.main.path(forResource:UserModel.shared.getAppLanguage(), ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                self.setDefaultLanguage(languageDict: jsonResult as! NSDictionary)
            } catch {
                // handle error
            }
        }
    }
    //MARK: Convert string to dict
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    //MARK: move to home page
    func goToHomePage()  {
        if #available(iOS 9.0, *) {
            let homeObj = menuContainerPage()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.setInitialViewController(initialView: homeObj)
        }
    }
    
    //MARK: move to offline
    func goToOffline()  {
        let offLineViewObj = OfflinePage()
        offLineViewObj.modalPresentationStyle = .fullScreen
        UIApplication.shared.keyWindow?.rootViewController?.present(offLineViewObj, animated: false, completion: nil)
    }
    
    //MARK: admin data sevice
    func fetchAdminData()  {
        let loginServiceObj = LoginWebServices()
        loginServiceObj.getAdminData(onSuccess: {response in
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
                UserModel.shared.setAdminData(adminDict: response)
            }
        })
    }
    
    //MARK: Show normal alertview
    func showAlert(msg:String, status: String)  {
        AJAlertController.initialization().showAlertWithOkButton(aStrMessage: msg, status: status, completion: { (index, title) in
        })
    }
    //regisert for push services
    func registerPushServices()  {
        let pushObj = UserServices()
        pushObj.registerForNotification(onSuccess: {response in
        })
    }
    //MARK: Network rechability
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        return ret
        
    }
    //get random number
    func random() -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< 10 {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        let userData = UserModel.shared.userID()
        return "\(userData as String? ?? "")\(randomString)"
    }
    //MARK: Check string is empty
    func checkEmptyWithString(value:String) -> Bool {
        if  (value == "") || (value == "NULL") || (value == "(null)") || (value == "<null>") || (value == "Json Error") || (value == "0") || (value.isEmpty) ||  value.trimmingCharacters(in: .whitespaces).isEmpty || value.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty  || value == nil{
            return true
        }
        return false
    }
    
    func setAppLanguage(languageStr: NSString){
        UserDefaults.standard.set(languageStr, forKey: "language")
    }
    func getAppLanguage() -> NSString? {
        return UserDefaults.standard.value(forKey: "language") as? NSString
    }
    
    
    //MARK:set App language
    func setDefaultLanguage(languageDict: NSDictionary){
        UserDefaults.standard.set(languageDict, forKey: "app_language")
    }
    func getLanguage() -> NSDictionary? {
        return UserDefaults.standard.value(forKey: "app_language") as? NSDictionary
    }
    //MARK: get currency
    func currency() -> NSString? {
        return UserDefaults.standard.value(forKey: "default_currency") as? NSString
    }
    //MARK: get police no
    func policeNo() -> NSString? {
        return UserDefaults.standard.value(forKey: "sos_policeNo") as? NSString
    }
    //MARK: date format
    func formattedDate(date:String) -> String {
        //iso format
        let format = ISO8601DateFormatter()
        var newDate = NSDate()
        let trimmedIsoString = date.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        newDate = format.date(from: trimmedIsoString)! as NSDate
        
        //new format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM d, yyyy, h:mm a"
        return dateFormatter.string(from:newDate as Date)
    }
    //MARK: Convert string to double
    func convertToDouble(string:String) -> Double {
        let doubleValue = Double()
        if let distance = Double(string) {
            print(distance)
            return distance
        } else {
            print("Not a valid string for conversion")
        }
        return doubleValue
    }
    //get current utc time
    func getUTCTime(dateStr:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let utcTimeZoneStr = formatter.string(from: dateStr)
        return utcTimeZoneStr
    }
    //convert timestamp to date
    func converTimeStamp(timeStamp:String) -> String {
        let timeInterval = TimeInterval(timeStamp)
        let date = Date.init(timeIntervalSince1970: timeInterval!)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "EEE, MMM d, yyyy, h:mm a" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    //combine date and time
    func getValidDate(date: Date) -> Date? {
        let calendar = NSCalendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour,.minute, .second], from: date)
        var mergedComponments = DateComponents()
        mergedComponments.year = dateComponents.year!
        mergedComponments.month = dateComponents.month!
        mergedComponments.day = dateComponents.day!
        mergedComponments.hour = dateComponents.hour!
        mergedComponments.minute = dateComponents.minute!
        mergedComponments.second = dateComponents.second!
        return calendar.date(from: mergedComponments)
    }
    //MARK: OS compatilbity Check
    func SYSTEM_VERSION_EQUAL_TO(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version,
                                                      options: NSString.CompareOptions.numeric) == ComparisonResult.orderedSame
    }
    
    func SYSTEM_VERSION_GREATER_THAN(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version,
                                                      options: NSString.CompareOptions.numeric) == ComparisonResult.orderedDescending
    }
    
    func SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version,
                                                      options: NSString.CompareOptions.numeric) != ComparisonResult.orderedAscending
    }
    
    func SYSTEM_VERSION_LESS_THAN(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version,
                                                      options: NSString.CompareOptions.numeric) == ComparisonResult.orderedAscending
    }
    
    func SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version,
                                                      options: NSString.CompareOptions.numeric) != ComparisonResult.orderedDescending
    }
    
    //MARK: Time ago
    func timeAgoSinceDate(_ date:Date, numericDates:Bool = false,type:NSString) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) min ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 min ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) sec ago"
        } else {
            return "Just now"
        }
        
        return ""
    }
    
    
    //draw dotted line from pickup to destination
    func drawDottedLine(start p0: CGPoint, end p1: CGPoint,label:UILabel) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = SEPARTOR_COLOR.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [7, 5] // 7 is the length of dash, 5 is length of the gap.
        shapeLayer.fillColor = UIColor.red.cgColor
        
        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        label.layer.addSublayer(shapeLayer)
        
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 1.5
        pathAnimation.fromValue = 0.0
        pathAnimation.toValue = 1.0
        pathAnimation.repeatCount = 1
        pathAnimation.autoreverses = false
        shapeLayer.add(pathAnimation, forKey: "strokeEnd")
        
        let fillColorAnimation = CABasicAnimation(keyPath: "fillColor")
        fillColorAnimation.duration = 1.5
        fillColorAnimation.fromValue =  UIColor.clear.cgColor
        fillColorAnimation.toValue =  UIColor.red.cgColor
        fillColorAnimation.repeatCount = 1
        fillColorAnimation.autoreverses = false
        shapeLayer.add(fillColorAnimation, forKey: "fillColor")
    }
    
    //convert timestamp with required format
    func timeStamp(stamp:Double,format:String) -> String {
        let dateNew = Date(timeIntervalSince1970:stamp)
        let dateFormat = DateFormatter()
        dateFormat.timeZone = TimeZone(abbreviation: "UTC") //Set timezone that you want
        if UserModel.shared.getAppLanguage() == "Arabic" {
            dateFormat.locale = NSLocale.init(localeIdentifier: "ar_DZ") as Locale
        }else{
            dateFormat.locale = NSLocale.current
        }
        dateFormat.dateFormat = format
        return dateFormat.string(from: dateNew)
    }
    
    func removeSuffic(_ getDistance: String, _ changeString: String) -> String{
        if getDistance.hasSuffix(changeString) {
            let name = getDistance.prefix(getDistance.count - changeString.count)
            print(name)
            return String(name)
        }
        return getDistance
    }
    
    func distanceString(for distance: Double) -> Double {
        let distanceMeters = Measurement(value: distance, unit: UnitLength.kilometers)
        let distanceMiles = distanceMeters.converted(to: UnitLength.miles)
        let miles = distanceMeters.converted(to: UnitLength.miles).value
        return miles
    }
}
extension Double {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
