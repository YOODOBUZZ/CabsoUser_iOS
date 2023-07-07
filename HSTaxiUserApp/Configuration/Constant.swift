//
//  Constant.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 09/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import Foundation
import UIKit

//MARK: Configure colors
let PRIMARY_COLOR = UIColor().hexValue(hex:"#42536b")
let TEXT_PRIMARY_COLOR = UIColor().hexValue(hex:"#292929")
let TEXT_SECONDARY_COLOR = UIColor().hexValue(hex:"#474747")
let TEXT_TERTIARY_COLOR = UIColor().hexValue(hex:"#9c9b9b")
let LINE_COLOR = UIColor().hexValue(hex:"#c9c9c9")
let GREEN_COLOR = UIColor().hexValue(hex:"#1fb545")
let RED_COLOR = UIColor().hexValue(hex:"#d22121")
let BLUE_COLOR = UIColor().hexValue(hex:"#136fcd")
let LIGHT_BLUE_COLOR = UIColor().hexValue(hex:"#e6eef5")
let NOTIFICATION_COLOR = UIColor().hexValue(hex:"#fe9352")
let DROP_LOCATION_COLOR = UIColor().hexValue(hex:"#2318f0")
let PICKUP_LOCATION_COLOR = UIColor().hexValue(hex:"#00d2ff")
let SEPARTOR_COLOR = UIColor.init(red: 170/255, green: 170/255, blue: 170/255, alpha: 0.5)
let WHITE_COLOR = UIColor.white
let TRASPARENT_WHITE_COLOR = UIColor.white.withAlphaComponent(0.3)
let CALL_ACCEPT_COLOR = UIColor.init(red: 72/255, green: 205/255, blue: 104/255, alpha: 1)
let CALL_DECLINE_COLOR = UIColor.init(red: 254/255, green: 6/255, blue: 59/255, alpha: 1)


//MARK: Configure Font
let APP_FONT_REGULAR = "QUESTRIAL-REGULAR"
//MARK: screen sizes
let FULL_WIDTH = UIScreen.main.bounds.size.width
let FULL_HEIGHT = UIScreen.main.bounds.size.height

//MARK: Device Models
let IS_IPHONE_X = UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436

//MARK:Validation
let ALPHA_PREDICT = "ABCDEFGHIJKLMONPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
let NUMERIC_PREDICT = "0123456789"
let COUNTRY_PREDICT = "+0123456789"

let EMPTY_STRING = ""
var isCallKitEnabled = false
var isRideComplete = true

//MARK:Invite URL
let APP_URL = NSURL.init(string: "https://itunes.apple.com/us/app/cabso/id1382103088?ls=1&mt=8")

// ADD_ONS
var BANNER_AD_ENABLED : Bool = false
var AD_UNIT_ID = "ca-app-pub-3940256099942544/2934735716"
var IS_AUDIOCALL_ENABLED = false


