//
//  SignInPage.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 10/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FBSDKCoreKit
import GoogleSignIn
//import AccountKit
import FirebaseUI
import PhoneNumberKit
import AuthenticationServices


class SignInPage: UIViewController,UITextFieldDelegate ,GIDSignInDelegate{
    
    @IBOutlet weak var applesignin: UIButton!
    @IBOutlet weak var facebookImageView: UIImageView!
    @IBOutlet weak var googleImgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var orLbl: UILabel!
    @IBOutlet weak var signinTitleLbl: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var fbBtn: UIButton!
    @IBOutlet var signInBtn: UIButton!
    @IBOutlet var emailTF: FloatLabelTextField!
    @IBOutlet var passwordTF: FloatLabelTextField!
    @IBOutlet var signUpBtn: UIButton!
    @IBOutlet var forgotBtn: UIButton!
    @IBOutlet var emailBorderLbl: UILabel!
    @IBOutlet var passwordBorderLbl: UILabel!
    
    let loginManager = LoginManager()
    var email = String()
    
    var country_code:String?
    var phone_no:String?
    //    var accountKit: AccountKitManager?
    let authUI = FUIAuth.defaultAuthUI()
    var emailAddress = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupInitialDetails()
        let providers: [FUIAuthProvider] = [
            FUIPhoneAuth(authUI:FUIAuth.defaultAuthUI()!),
        ]
        authUI?.delegate = self
        self.authUI?.providers = providers
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.changeToRTL()
    }
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.textAlignment = .right
            self.orLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.signinTitleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.signinTitleLbl.textAlignment = .right
            self.emailTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.emailTF.textAlignment = .right
            self.passwordTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.passwordTF.textAlignment = .right
            self.forgotBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.forgotBtn.contentHorizontalAlignment = .left
          
            self.googleBtn.semanticContentAttribute = .forceRightToLeft
            self.fbBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.fbBtn.semanticContentAttribute = .forceRightToLeft
            self.fbBtn.contentHorizontalAlignment = .left
           
            self.facebookImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
            
            
            self.googleBtn.titleLabel?.transform = CGAffineTransform(scaleX: -1, y: 1) //new
            /*
             //old
             self.googleBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
             self.googleBtn.contentHorizontalAlignment = .left
            self.googleImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
             */
            
        }
        else {
            self.view.transform = .identity
            self.titleLbl.transform = .identity
            self.titleLbl.textAlignment = .left
            self.orLbl.transform = .identity
            self.signinTitleLbl.transform = .identity
            self.signinTitleLbl.textAlignment = .left
            self.emailTF.transform = .identity
            self.emailTF.textAlignment = .left
            self.passwordTF.transform = .identity
            self.passwordTF.textAlignment = .left
            self.forgotBtn.transform = .identity
            self.forgotBtn.contentHorizontalAlignment = .right
          
            self.googleBtn.semanticContentAttribute = .forceLeftToRight
            self.fbBtn.transform = .identity
            self.fbBtn.semanticContentAttribute = .forceLeftToRight
            self.fbBtn.contentHorizontalAlignment = .right
          
            self.facebookImageView.transform = .identity
            /*
            // old
             self.googleBtn.contentHorizontalAlignment = .right
             self.googleBtn.transform = .identity
             self.googleImgView.transform = .identity
             */
            
        }
    }
    func firebaseLogin() {
        let phoneProvider = FUIAuth.defaultAuthUI()?.providers.first as! FUIPhoneAuth
        phoneProvider.signIn(withPresenting: self, phoneNumber: nil)
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        print("authuuuuu-\(authUI)")
    }
    
    //MARK: set up intial details
    func setupInitialDetails()  {
        self.emailTF.text = self.email
        //        self.accountKit = AccountKitManager.init(responseType: ResponseType.accessToken)
        GIDSignIn.sharedInstance().clientID = GOOGLE_CLIENT_ID //config google client id
        self.navigationView.elevationEffect()
        self.titleLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text: "signin")
        self.signinTitleLbl.config(color: TEXT_PRIMARY_COLOR, size: 14, align: .left, text: "signinusing")
        
        self.fbBtn.config(color: .white, size: 17, align: .right, title: "facebook")
        self.fbBtn.backgroundColor = BLUE_COLOR
        self.fbBtn.cornerMiniumRadius()
        self.fbBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 12)
        
        
        self.fbBtn.isHidden = true
        self.facebookImageView.isHidden = true
        
        self.applesignin.config(color: .white, size: 17, align: .center, title: "appleLogin")
        self.applesignin.backgroundColor = UIColor.black
//        self.applesignin.cornerMiniumRadius()
        self.applesignin.layer.cornerRadius = 5
//        self.clipsToBounds = true
        
        /*
         //old
        self.googleBtn.config(color: .white, size: 17, align: .center, title: "google")
        self.googleBtn.backgroundColor = RED_COLOR
        self.googleBtn.cornerMiniumRadius()
        self.googleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 12)
         */
        
        //new
        self.googleImgView.isHidden = true
        self.googleBtn.config(color: .white, size: 17, align: .center, title: "google")
        self.googleBtn.backgroundColor = RED_COLOR
        self.googleBtn.cornerMiniumRadius()
        let CartImg = #imageLiteral(resourceName: "google1").withRenderingMode(.alwaysTemplate)
        self.googleBtn.setImage(CartImg, for: .normal)
        self.googleBtn.tintColor = .white
        
        
        self.emailTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "email")
        self.passwordTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "password")
        
        self.signInBtn.config(color: .white, size: 17, align: .center, title: "signin")
        self.signInBtn.cornerMiniumRadius()
        self.signInBtn.backgroundColor = PRIMARY_COLOR
        self.signUpBtn.config(color: .black, size: 14, align: .center, title: "noaccount")
        let alreadyMemberStr = Utility.shared.getLanguage()?.value(forKey: "noaccount")as! NSString
        let signupStr = Utility.shared.getLanguage()?.value(forKey: "signup")as! NSString
        let range = alreadyMemberStr.range(of: signupStr as String)
        
        let attribute = NSMutableAttributedString.init(string: alreadyMemberStr as String)
        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: PRIMARY_COLOR , range: range)
        self.signUpBtn.titleLabel?.attributedText = attribute
        
        self.orLbl.config(color: PRIMARY_COLOR, size: 14, align: .center, text: "or")
        self.forgotBtn.config(color: RED_COLOR, size: 14, align: .center, title: "fogotpassword")
        if #available(iOS 13.0, *) {
        }else{
            self.applesignin.isHidden = true
        }
    }
    
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func fbBtnTapped(_ sender: Any){         //check OS compatibility
        if let accessToken = AccessToken.current {
            print(accessToken)
            self.getFBUserData()
        } else {
            let completion = {
                (result:LoginResult) in
                switch result {
                case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                    print("YES! \n--- GRANTED PERMISSIONS ---\n\(grantedPermissions) \n--- DECLINED PERMISSIONS ---\n\(declinedPermissions) \n--- ACCESS TOKEN ---\n\(accessToken)")
                    if(declinedPermissions.contains("email")){
                        let loginManager = LoginManager()
                        loginManager.logOut()
                        self.fbPermissionDeniedAlert()
                    }else{
                        self.getFBUserData()
                    }
                case .failed(let error):
                    print("No...\(error)")
                case .cancelled:
                    print("Cancelled.")
                }
            }
            loginManager.logIn(permissions: [.publicProfile,.email], viewController: self, completion: completion)
        }
    }
    //fb permission denied alert
    func fbPermissionDeniedAlert()  {
        let alert = UIAlertController(title: Utility.shared.getLanguage()?.value(forKey: "appname") as? String, message: Utility.shared.getLanguage()?.value(forKey: "fb_permission") as? String, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: Utility.shared.getLanguage()?.value(forKey: "okay") as? String, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Get facebook user details based on accesstoken
    func getFBUserData(){
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //    self.dict = result as! [String : AnyObject]
                    print("Facebook Details\(result!)")
                    let responseDict = result as! NSDictionary
                    self.emailTF.text = responseDict.value(forKey: "email") as? String
                }
            })
        }
    }
    
    @IBAction func googleBtnTapped(_ sender: Any) {
        //check OS compatiblity
        if Utility.shared.SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(version: "9.0"){
            Utility.shared.showAlert(msg: "os_compatibility", status: "")
        }else{
            GIDSignIn.sharedInstance().delegate=self
//            GIDSignIn.sharedInstance().uiDelegate=self
            GIDSignIn.sharedInstance().presentingViewController = self
            GIDSignIn.sharedInstance().signIn()
        }
    }
    
    //MARK:Google SignIn Delegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            self.emailTF.text = user.profile.email
        } else {
            print("\(error.localizedDescription)")
        }
    }
    @IBAction func appleLoginBtnTapped(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
            
        } else {
            // Fallback on earlier versions
            self.applesignin.isHidden = true
        }
        
    }
    //sign in validation and process
    @IBAction func signInBtnTapped(_ sender: Any) {

        if self.isValidationSuccess() {
            self.emailTF.resignFirstResponder()
            self.passwordTF.resignFirstResponder()
            self.signInService(type: "withoutphone")
        }
    }
    //not registered. move to signup page
    @IBAction func signUpBtnTapped(_ sender: Any) {
        let signUpObj = SignUpPage()
        self.navigationController?.pushViewController(signUpObj, animated: true)
    }
    //move to forgot page
    @IBAction func forgotBtnTapped(_ sender: Any) {
        let forgotObj  = ForgotPasswordPage()
        forgotObj.modalPresentationStyle = .fullScreen
        self.navigationController?.present(forgotObj, animated: true, completion: nil)
    }
    //MARK: Textfield delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateViewMoving(up: true, moveValue: 100)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(up: false, moveValue: 100)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.clearValidation()
        return true
    }
    
    //MARK: Check text field validation
    func isValidationSuccess() -> Bool {
        var status:Bool = false
        if self.emailTF.isEmptyValue() {
            self.emailBorderLbl.backgroundColor = RED_COLOR
            self.emailTF.setAsInvalidTF("enter_email", in: self.view)
        }else if !self.emailTF.isValidEmail(){
            self.emailBorderLbl.backgroundColor = RED_COLOR
            self.emailTF.setAsInvalidTF("enter_valid_email", in: self.view)
        }else if self.passwordTF.isEmptyValue(){
            self.passwordBorderLbl.backgroundColor = RED_COLOR
            self.passwordTF.setAsInvalidTF("enter_password", in: self.view)
        }else if (self.passwordTF.text?.count)!<6{
            self.passwordBorderLbl.backgroundColor = RED_COLOR
            self.passwordTF.setAsInvalidTF("password_limit", in: self.view)
        }else{
            self.clearValidation()
            status = true
        }
        return status
    }
    //MARK: Clear text field validation
    func clearValidation()  {
        self.emailTF.setAsValidTF()
        self.passwordTF.setAsValidTF()
        self.emailBorderLbl.backgroundColor = SEPARTOR_COLOR
        self.passwordBorderLbl.backgroundColor = SEPARTOR_COLOR
    }
    
    //    func _prepareLoginViewController(_ loginViewController: (UIViewController & AKFViewController)?) {
    //        loginViewController?.delegate = self
    //        // Optionally, you may set up backup verification methods.
    //        loginViewController?.isSendToFacebookEnabled = true
    //        loginViewController?.uiManager = SkinManager.init(skinType: .classic, primaryColor: PRIMARY_COLOR)
    //
    //    }
    //MARK: move to phone number verification page
    //    func verifyPhoneNo()  {
    //        let preFillPhoneNumber: PhoneNumber? = nil
    //        let inputState = UUID().uuidString
    //        weak var viewController: (UIViewController & AKFViewController)? = accountKit?.viewControllerForPhoneLogin(with: preFillPhoneNumber, state: inputState)
    //        _prepareLoginViewController(viewController)
    //        // see above
    //        // see above
    //        if let aController = viewController {
    //            present(aController, animated: true) {() -> Void in }
    //        }
    //    }
    
    //MARK: Phone number verification delegate
    //    func viewController(_ viewController: (UIViewController & AKFViewController), didCompleteLoginWith accessToken: AKFAccessToken, state: String) {
    //        let accountK = AccountKitManager(responseType: ResponseType.accessToken)
    //        accountK.requestAccount { (account, error) in
    //            if(error != nil){
    //                //error while fetching information
    //                print("error \(String(describing: error?.localizedDescription)) ")
    //            }else{
    //                self.phone_no = account?.phoneNumber?.phoneNumber
    //                self.country_code = account?.phoneNumber?.countryCode
    //                self.signInService(type: "withphone")
    //            }
    //        }
    //    }
    //    func viewController(_ viewController: (UIViewController & AKFViewController), didFailWithError error: Error) {
    //        print("failed \(error.localizedDescription) ")
    //    }
    
    
    //MARK: sign in web service call
    func signInService(type:String)  {
        HPLActivityHUD.showActivity(with: .withMask)
        let signinServiceObj = LoginWebServices()
        if self.phone_no == nil {
            self.phone_no = ""
            self.country_code = ""
        }
        signinServiceObj.signInService(email: self.emailTF.text!, password: self.passwordTF.text!,country_code:self.country_code!,phone_no: self.phone_no!,type:type, onSuccess: {response in
            HPLActivityHUD.dismiss()
            let status:NSString = response.value(forKey: "status") as! NSString
            
            if status.isEqual(to: STATUS_TRUE){
                if type == "withoutphone"{
                    self.firebaseLogin()
//                                        self.phone_no = "9597121763"
//                                        self.country_code = "+91"
//                                        self.signInService(type: "withphone")
                    
                }else{
                    UserModel.shared.removeEmergencyContact()
                    UserModel.shared.setUserInfo(userDict: response)
                    UserModel.shared.setProfilePic(URL: response.object(forKey: "user_image") as! NSString)
                    UserModel.shared.setWalletAmt(wallet_amt:response.value(forKey: "walletmoney") as! NSNumber)
                    Utility.shared.registerPushServices()
                    Utility.shared.goToHomePage()
                }
            }
            /*
            else if status == "error"{
                //  let message:NSString = response.value(forKey: "message") as! NSString
                //  if message = message.isEqual(to: Utility.shared.getLanguage()?.value(forKey: "account_deleted") as! String){
                // }
                
                let message = Utility.shared.getLanguage()?.value(forKey: "account_deleted") as! String
                UserModel.shared.logoutUser()
               
                let alertVC = CPAlertVC(title:APP_NAME, message: message)
                alertVC.animationType = .bounceUp
                alertVC.addAction(CPAlertAction(title: Utility().getLanguage()?.value(forKey: "ok") as! String, type: .normal, handler: {
                }))
                alertVC.show(into: self)
            }
            */
            else if status.isEqual(to: STATUS_FALSE){
                let message:NSString = response.value(forKey: "message") as! NSString
                if message.isEqual(to: Utility.shared.getLanguage()?.value(forKey: "password_auth") as! String){
                    self.passwordTF.text = EMPTY_STRING
                }
                print("solai\(message as String)")
                Utility.shared.showAlert(msg: message as String, status: "1")
            }
        }, onFailure: {errorResponse in
            HPLActivityHUD.dismiss()
        })
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.5
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
}
extension SignInPage: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        print(error?.localizedDescription ?? "")
        if error == nil {
            let phoneNumberKit = PhoneNumberKit()
            do {
                let phoneNumbers = try phoneNumberKit.parse(authDataResult?.user.phoneNumber ?? "")
                self.phone_no = "\(phoneNumbers.nationalNumber)"
                self.country_code = "\(phoneNumbers.countryCode)"
                self.signInService(type: "withphone")
            }
            catch {
                print("Generic parser error")
            }
        }
        else {
        }
    }
    
    func authUI(_ authUI: FUIAuth, didFinish operation: FUIAccountSettingsOperationType, error: Error?) {
        print(error?.localizedDescription ?? "")
    }
    
}
@available(iOS 13.0, *)
extension SignInPage: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))")
            if appleIDCredential.fullName?.familyName != nil{
                print("new signin")
                self.emailTF.text = appleIDCredential.email
                let dict: [String: String]!
                dict = ["givenName": "\(appleIDCredential.fullName?.givenName ?? "")", "familyName": "\(appleIDCredential.fullName?.familyName ?? "")","email": "\(appleIDCredential.email ?? "")"]
                UserModel.shared.setAppleIDWithMail(email: dict, userID: appleIDCredential.user)
            }else{
                print("already signin")
                if UserModel.shared.getAppleIDWithMail(userID: appleIDCredential.user) != nil {
                    let loginData = UserModel.shared.getAppleIDWithMail(userID: appleIDCredential.user)
                    self.emailTF.text = loginData?["email"]
                }
                
            }
        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}
