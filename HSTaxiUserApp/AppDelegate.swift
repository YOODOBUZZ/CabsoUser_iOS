
//
//  AppDelegate.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 09/03/18.
//  Copyright © 2018 APPLE. All rights reserved.

import UIKit
import GoogleMaps
import GooglePlaces
import FBSDKLoginKit
import GoogleSignIn
import IQKeyboardManagerSwift
import Firebase
import UserNotifications
import Braintree
import FirebaseUI
import Messages
//import CallKit
import PushKit
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate {
    
    // Call Integration
    var callStarted = Bool()
    var baseUUId = UUID()
    var callStatus : String!
//    var callController = CXCallController()
//    var provider: CXProvider!
//    /// The app's provider configuration, representing its CallKit capabilities.
//    static let providerConfiguration: CXProviderConfiguration = {
//        let localizedName = NSLocalizedString("Calling From", comment: "Howzu")
//        let providerConfiguration = CXProviderConfiguration(localizedName: localizedName)
//        providerConfiguration.maximumCallsPerCallGroup = 1
//
//        providerConfiguration.supportsVideo = true
//        providerConfiguration.supportedHandleTypes = [.phoneNumber]
//        return providerConfiguration
//    }()
    var callKitPopup = false
    var deviceTokenString = ""
    var isAlreadyInCall = false
    var callNotifyDict: JSON!
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UserDefaults.standard.set(APP_RTC_URL, forKey: "web_rtc_web")
        
//        self.enableCallKit()
        
        // Override point for customization after application launch.
        self.setUpinitialDetails()
        
        //config firebase for push notification
        FirebaseApp.configure()
        self.registerForPushNotification(application)
        Messaging.messaging().delegate = self
        
        return ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: Call back open URL for facebook, google
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
          return true
        }
        if (ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)) {
            return true
        }
        else if (GIDSignIn.sharedInstance()?.handle(url as URL))!
        {
            return true
        }
        else if url.scheme?.localizedCaseInsensitiveCompare(BRAIN_TREE_URL_SCHEMES) == .orderedSame {
            return BTAppSwitch.handleOpen(url, sourceApplication: sourceApplication)
        }
        
        return false
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(userInfo) {
            print("UserInfo\(userInfo)")
            completionHandler(UIBackgroundFetchResult.noData)
            return
        }
        // This notification is not auth related, developer should handle it.
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        print("Device token-----\(deviceToken)")
        Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.sandbox)
    
    }
    //MARK:configure Initial Details
    func setUpinitialDetails()  {
        if UserModel.shared.getAppLanguage() != nil {
        }
        else {
            UserModel.shared.setAppLanguage(Language: DEFAULT_LANGUAGE)
        }
        UserModel.shared.enableLocationEdit(status: "false")
        Utility.shared.configureLanguage()
        //config goole api
        GMSServices.provideAPIKey(GOOGLE_API_KEY)
        GMSPlacesClient.provideAPIKey(GOOGLE_API_KEY)
        //config braintree
        BTAppSwitch.setReturnURLScheme(BRAIN_TREE_URL_SCHEMES)

        //fetch admin data
        Utility.shared.fetchAdminData()
        //keyborad manager
        IQKeyboardManager.shared.enable = true
        //set initial view
        self.checkUserLoggedStatus()
    }

    //MARK: check user status
    func checkUserLoggedStatus()  {
        if(UserModel.shared.userID() == nil) {
            self.setInitialViewController(initialView: WelcomePage())
        }else{
          
            self.setInitialViewController(initialView: menuContainerPage())
        }
//        self.setInitialViewController(initialView: menuContainerPage())

    }
    // MARK:set initial view controller
    func setInitialViewController(initialView: UIViewController)  {
        window = UIWindow(frame: UIScreen.main.bounds)
        let homeViewController = initialView
        let nav = UINavigationController(rootViewController: homeViewController)
        window!.rootViewController = nav
        window!.makeKeyAndVisible()
    }
    
    //MARK: Register for push notification
    func registerForPushNotification(_ application: UIApplication)  {
        Messaging.messaging().shouldEstablishDirectChannel = true
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            }
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        //let fcmTokenChange = fcmToken.hexString
        print("Firebase Token: \(fcmToken)")
        UserModel.shared.setFCMToken(fcm_token: fcmToken as NSString)
        // register token for pushnotification
        if UserModel.shared.getFCMToken() != nil && UserModel.shared.userID() != nil && UserModel.shared.getVOIPToken() != nil{
            Utility.shared.registerPushServices()
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Notiiiiiffff\(notification.request.content.userInfo)")
        print("NOTIIFY \(notification)")
        completionHandler([.alert,.badge,.sound])
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(" NOTIFICATION \(userInfo)")
    }
   
}
/*
extension AppDelegate: CXProviderDelegate, PKPushRegistryDelegate {

    func enableCallKit() {
        provider = CXProvider(configuration: type(of: self).providerConfiguration)
        self.isAlreadyInCall = false
        // REGISTER VOIP NOTIFICATION
        let voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
        voipRegistry.desiredPushTypes = Set([PKPushType.voIP])
        voipRegistry.delegate = self

    }
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("pushRegistry didInvalidatePushTokenFor \(type)")
    }

    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {

        let deviceTokenString = pushCredentials.token.hexString
        print("PUSH KIT TOKEN \(deviceTokenString)")
        UserModel.shared.setVOIPToken(voip_token: deviceTokenString as NSString)
       // register token for pushnotification
        if UserModel.shared.getFCMToken() != nil && UserModel.shared.userID() != nil && UserModel.shared.getVOIPToken() != nil{
            Utility.shared.registerPushServices()
        }
    }

    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
        print("PUSHKIT NOTIFICATION \(payload.dictionaryPayload)")
        let jsonDict = JSON(payload.dictionaryPayload)
        self.callNotifyDict = jsonDict
        if jsonDict["type"].stringValue == "call" {
            if !isAlreadyInCall {
                isAlreadyInCall = true
                self.baseUUId = UUID()
                self.provider.setDelegate(self, queue: nil)
                let update = CXCallUpdate()
                let username = jsonDict["aps","alert","user_name"].stringValue
                update.remoteHandle = CXHandle(type: .generic, value: username)
                if jsonDict["aps","type"].stringValue == "video" {
                    update.hasVideo = true
                }
                else {
                    update.hasVideo = false
                }
                self.provider.configuration.maximumCallsPerCallGroup = 1
                self.provider.reportNewIncomingCall(with: self.baseUUId, update: update, completion: { error in })
                self.callKitPopup = true
            }
        }
        else if jsonDict["type"].stringValue == "bye" {
            self.endCall()
            if (window?.rootViewController?.isKind(of: AudioCallViewController.self))! {
                window?.rootViewController?.dismiss(animated: true, completion: nil)
            }
            else {
                let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                print("hello")
                if var topController = keyWindow?.rootViewController {
                    while let presentedViewController = topController.presentedViewController {
                        topController = presentedViewController
                        if topController.isKind(of: AudioCallViewController.self) {
                            window?.rootViewController?.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    func endCall(){
        self.isAlreadyInCall = false
        // Print("end call uuid \(baseUUId)")
        let endCallAction = CXEndCallAction(call:baseUUId)
        let transaction = CXTransaction(action: endCallAction)
        callController.request(transaction) { error in
            if error == nil {
                // Print("EndCallAction transaction request failed: \(error.localizedDescription).")
                self.provider.reportCall(with: self.baseUUId, endedAt: Date(), reason: .remoteEnded)
                return
            }
            else {
            }
            // Print("EndCallAction transaction request successful")
        }
        self.automaticDisconnect()
        self.callStarted = false
        callKitPopup = false
    }
    @objc func automaticDisconnect()
    {
        if (callStatus == "incoming")
        {
            let endCallAction = CXEndCallAction(call:baseUUId)
            let transaction = CXTransaction(action: endCallAction)
            callController.request(transaction) { error in
                if let error = error {
                    return
                }
            }
            let time = NSDate().timeIntervalSince1970
            callKitPopup = false
        }
        self.callStarted = false
    }
    func providerDidReset(_ provider: CXProvider) {

    }
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        action.fulfill()
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        let pageobj = AudioCallViewController()
        pageobj.receiverId =  self.callNotifyDict["sender_id"].stringValue
        pageobj.room_id = self.callNotifyDict["room_id"].stringValue
        pageobj.senderFlag = false
        pageobj.viewType = "2"
        pageobj.call_type = "audio"
        pageobj.modalPresentationStyle = .fullScreen
        self.window!.makeKeyAndVisible()
        UIApplication.topViewController()?.present(pageobj, animated: true, completion: nil)
    }
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        action.fulfill()
        if self.isAlreadyInCall {
            self.isAlreadyInCall = false
            let rideObj = RideServices()
            rideObj.endCall(sender_id: (UserModel.shared.userID() as String? ?? ""), receiver_id: self.callNotifyDict["sender_id"].stringValue, room_id: self.callNotifyDict["room_id"].stringValue) { (result) in
                self.window?.rootViewController?.view.makeToast("Call declined")
            }
        }
    }
}
*/
extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
