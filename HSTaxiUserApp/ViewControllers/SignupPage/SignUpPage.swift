//
//  SignUpPage.swift
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
import SafariServices
import AuthenticationServices

class SignUpPage: UIViewController,UITextFieldDelegate,GIDSignInDelegate {
    
    @IBOutlet weak var appleButton: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var orLbl: UILabel!
    @IBOutlet weak var signinTitleLbl: UILabel!
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var fbBtn: UIButton!
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet var fullnameTF: FloatLabelTextField!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var emailTF: FloatLabelTextField!
    @IBOutlet var passwordTF: FloatLabelTextField!
    @IBOutlet var rePasswordTF: FloatLabelTextField!
    @IBOutlet var signInBtn: UIButton!
    @IBOutlet var nameBorderLbl: UILabel!
    @IBOutlet var emailBorderLbl: UILabel!
    @IBOutlet var passwordBorderLbl: UILabel!
    @IBOutlet var repasswordBorderLbl: UILabel!
    
    @IBOutlet weak var facebookImageView: UIImageView!
    @IBOutlet weak var googleImgView: UIImageView!

    let loginManager = LoginManager()
//    var accountKit: AccountKitManager?
    var country_code:String?
    var phone_no:String?
    var imageUrl = String()
    var signuptype = String()
    let authUI = FUIAuth.defaultAuthUI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let providers: [FUIAuthProvider] = [
            FUIPhoneAuth(authUI:FUIAuth.defaultAuthUI()!),
            ]
        authUI?.delegate = self
        self.authUI?.providers = providers

        // Do any additional setup after loading the view.
        self.setupInitialDetails()
    }
    
    @IBAction func appleButtonTapped(_ sender: UIButton) {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
            
        } else {
            // Fallback on earlier versions
            self.appleButton.isHidden = true
        }
        
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
            self.fullnameTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.fullnameTF.textAlignment = .right
            self.emailTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.emailTF.textAlignment = .right
            self.passwordTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.passwordTF.textAlignment = .right
            self.repasswordBorderLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.repasswordBorderLbl.textAlignment = .right
            
            self.googleBtn.titleLabel?.transform = CGAffineTransform(scaleX: -1, y: 1) //new
            
        }
        else {
            self.view.transform = .identity
            self.titleLbl.transform = .identity
            self.titleLbl.textAlignment = .left
            self.orLbl.transform = .identity
            self.signinTitleLbl.transform = .identity
            self.signinTitleLbl.textAlignment = .left
            self.fullnameTF.transform = .identity
            self.fullnameTF.textAlignment = .left
            self.emailTF.transform = .identity
            self.emailTF.textAlignment = .left
            self.passwordTF.transform = .identity
            self.passwordTF.textAlignment = .left
            self.repasswordBorderLbl.transform = .identity
            self.repasswordBorderLbl.textAlignment = .left

        }
    }
    func firebaseLogin() {
        let phoneProvider = FUIAuth.defaultAuthUI()?.providers.first as! FUIPhoneAuth
        phoneProvider.signIn(withPresenting: self, phoneNumber: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    
    //MARK: set up intial details
    func setupInitialDetails()  {
        self.configGoogleFbDetails()
        self.navigationView.elevationEffect()
        scrollView.contentSize = CGSize.init(width:0 , height: 880)
        self.titleLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text: "signup")
        self.signinTitleLbl.config(color: TEXT_PRIMARY_COLOR, size: 14, align: .left, text: "signinusing")
        
        self.fbBtn.config(color: .white, size: 17, align: .right, title: "facebook")
        self.fbBtn.backgroundColor = BLUE_COLOR
        self.fbBtn.cornerMiniumRadius()
        self.fbBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12)
        
        self.fbBtn.isHidden = true
        self.facebookImageView.isHidden = true
        
        self.appleButton.config(color: .white, size: 17, align: .center, title: "appleLogin")
        self.appleButton.backgroundColor = UIColor.black
        self.appleButton.layer.cornerRadius = 5

        /*
         //old
        self.googleBtn.config(color: .white, size: 17, align: .center, title: "google")
        self.googleBtn.backgroundColor = RED_COLOR
        self.googleBtn.cornerMiniumRadius()
        self.googleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12)
         */
        
        //new
        self.googleImgView.isHidden = true
        self.googleBtn.config(color: .white, size: 17, align: .center, title: "google")
        self.googleBtn.backgroundColor = RED_COLOR
        self.googleBtn.cornerMiniumRadius()
        let CartImg = #imageLiteral(resourceName: "google1").withRenderingMode(.alwaysTemplate)
        self.googleBtn.setImage(CartImg, for: .normal)
        self.googleBtn.tintColor = .white
        
        
        self.fullnameTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "name")
        self.emailTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "email")
        self.passwordTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "password")
        self.rePasswordTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "repassword")

        self.nextBtn.config(color: .white, size: 17, align: .center, title: "next")
        self.nextBtn.cornerMiniumRadius()
        self.nextBtn.backgroundColor = PRIMARY_COLOR
        
        self.signInBtn.config(color: .black, size: 14, align: .center, title: "haveaccount")

        let alreadyMemberStr = Utility.shared.getLanguage()?.value(forKey: "haveaccount")as! NSString
        let signupStr = Utility.shared.getLanguage()?.value(forKey: "signin")as! NSString
        let range = alreadyMemberStr.range(of: signupStr as String)
        
        let attribute = NSMutableAttributedString.init(string: alreadyMemberStr as String)
        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: PRIMARY_COLOR , range: range)
        self.signInBtn.titleLabel?.attributedText = attribute
        self.orLbl.config(color: PRIMARY_COLOR, size: 14, align: .center, text: "or")
        if #available(iOS 13.0, *) {
              }else{
                  self.appleButton.isHidden = true
              }
    }
    func configGoogleFbDetails()  {
        GIDSignIn.sharedInstance().clientID = GOOGLE_CLIENT_ID //config google client id
//        self.accountKit = AccountKitManager.init(responseType: ResponseType.accessToken)
    }
    
//    func _prepareLoginViewController(_ loginViewController: (UIViewController & AKFViewController)?) {
//        loginViewController?.delegate = self
//        // Optionally, you may set up backup verification methods.
//        loginViewController?.isSendToFacebookEnabled = true
//        loginViewController?.uiManager = SkinManager.init(skinType: .classic, primaryColor: PRIMARY_COLOR)
//    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func fbBtnTapped(_ sender: Any) {
        //check OS compatibility
        if let accessToken = AccessToken.current {
            print(accessToken)
            self.getFBUserData()
        } else {
            let completion = {
                (result:LoginResult) in
                switch result {
                case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                    print("YES! \n--- GRANTED PERMISSIONS ---\n\(grantedPermissions) \n--- DECLINED PERMISSIONS ---\n\(declinedPermissions) \n--- ACCESS TOKEN ---\n\(accessToken)")
                    print("check\(declinedPermissions.description)")
                    if(declinedPermissions.contains("email")){
                        print("correct\(declinedPermissions.description)")
                        DispatchQueue.main.async {
                            self.fbPermissionDeniedAlert()
                            let loginManager = LoginManager()
                            loginManager.logOut()
                        }
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
//            loginManager.logIn(readPermissions: [.publicProfile,.email], viewController: self, completion: completion)
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
                    self.fullnameTF.text = responseDict.value(forKey: "name") as? String
                    self.emailTF.text = responseDict.value(forKey: "email") as? String
                    let facebookID = responseDict.value(forKey: "id") as! NSString
                    let escapedString = ("https://graph.facebook.com/\(facebookID)/picture?width=9999") as NSString
                    self.imageUrl = escapedString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
                    self.signuptype = "social"
                }
            })
        }
    }
    @IBAction func googleBtnTapped(_ sender: Any) {
        //check OS compatiblity
        if Utility.shared.SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(version: "9.0"){
            Utility.shared.showAlert(msg: "os_compatibility", status: "1")
        }else{
            GIDSignIn.sharedInstance().delegate=self
            GIDSignIn.sharedInstance().presentingViewController = self
            GIDSignIn.sharedInstance().signIn()
        }
    }
    
    
    //MARK:Google SignIn Delegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            self.fullnameTF.text = user.profile.name
            self.emailTF.text = user.profile.email
            self.imageUrl = "\(user.profile.imageURL(withDimension: 400)!)"
            self.signuptype = "social"
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        if self.isValidationSuccess() {
            self.emailTF.resignFirstResponder()
            self.passwordTF.resignFirstResponder()
            self.fullnameTF.resignFirstResponder()
            self.rePasswordTF.resignFirstResponder()
            HPLActivityHUD.showActivity(with: .withMask)
            self.signUpWebService()
        }
    }
    
    //MARK: move to phone number verification page
//    func verifyPhoneNo()  {
//        let preFillPhoneNumber: PhoneNumber? = nil
//        let inputState = UUID().uuidString
//        weak var viewController: (UIViewController & AKFViewController)? = accountKit?.viewControllerForPhoneLogin(with: preFillPhoneNumber, state: inputState)
//        _prepareLoginViewController(viewController)
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
//                HPLActivityHUD.showActivity(with: .withMask)
//                self.signInService()
//            }
//        }
//    }
    
//    func viewController(_ viewController: (UIViewController & AKFViewController), didFailWithError error: Error) {
//        print("failed \(error.localizedDescription) ")
//    }
//    func viewControllerDidCancel(_ viewController: (UIViewController & AKFViewController)) {
//        self.fullnameTF.text = EMPTY_STRING
//        self.emailTF.text = EMPTY_STRING
//        self.passwordTF.text = EMPTY_STRING
//        self.rePasswordTF.text = EMPTY_STRING
//        self.view.makeToast(Utility.shared.getLanguage()?.value(forKey: "account_created") as? String)
//
//    }
    
    @IBAction func signInBtnTapped(_ sender: Any) {
        let signInObj = SignInPage()
        self.navigationController?.pushViewController(signInObj, animated: true)
    }
    
    //MARK: Check text field validation
    func isValidationSuccess() -> Bool {
        var status:Bool = false
        if self.fullnameTF.isEmptyValue(){
            self.nameBorderLbl.backgroundColor = RED_COLOR
            self.fullnameTF.setAsInvalidTF("enter_name", in: self.scrollView)
        }else if (self.fullnameTF.text?.count)!<3{
            self.nameBorderLbl.backgroundColor = RED_COLOR
            self.fullnameTF.setAsInvalidTF("name_limit", in: self.view)
        }else if self.emailTF.isEmptyValue() {
            self.emailBorderLbl.backgroundColor = RED_COLOR
            self.emailTF.setAsInvalidTF("enter_email", in: self.scrollView)
        }else if !self.emailTF.isValidEmail(){
            self.emailBorderLbl.backgroundColor = RED_COLOR
            self.emailTF.setAsInvalidTF("enter_valid_email", in: self.scrollView)
        }else if self.passwordTF.isEmptyValue(){
            self.passwordBorderLbl.backgroundColor = RED_COLOR
            self.passwordTF.setAsInvalidTF("enter_password", in: self.scrollView)
        }else if (self.passwordTF.text?.count)!<6{
            self.passwordBorderLbl.backgroundColor = RED_COLOR
            self.passwordTF.setAsInvalidTF("password_limit", in: self.view)
        }else if self.rePasswordTF.isEmptyValue(){
            self.repasswordBorderLbl.backgroundColor = RED_COLOR
            self.rePasswordTF.setAsInvalidTF("enter_repassword", in: self.scrollView)
        }else if self.passwordTF.text != self.rePasswordTF.text{
            self.rePasswordTF.text = EMPTY_STRING
            self.repasswordBorderLbl.backgroundColor = RED_COLOR
            self.rePasswordTF.setAsInvalidTF("password_not_match", in: self.scrollView)
        }else{
            status = true
            self.clearValidation()
        }
        return status
    }
    //MARK: Clear text field validation
    func clearValidation(){
        self.emailTF.setAsValidTF()
        self.passwordTF.setAsValidTF()
        self.fullnameTF.setAsValidTF()
        self.rePasswordTF.setAsValidTF()
        
        self.emailBorderLbl.backgroundColor = SEPARTOR_COLOR
        self.passwordBorderLbl.backgroundColor = SEPARTOR_COLOR
        self.nameBorderLbl.backgroundColor = SEPARTOR_COLOR
        self.repasswordBorderLbl.backgroundColor = SEPARTOR_COLOR
    }
    
    //MARK: Textfield delegate

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.clearValidation()
        let full_string = textField.text!+string
        if textField.tag == 1 {
            let set = NSCharacterSet.init(charactersIn:ALPHA_PREDICT)
            let characterSet = CharacterSet(charactersIn: string)
            if full_string.count>30{
                return false
            }
            return true //set.isSuperset(of: characterSet)
        }else if textField.tag == 5{
            let set = NSCharacterSet.init(charactersIn:COUNTRY_PREDICT)
            let characterSet = CharacterSet(charactersIn: string)
            return set.isSuperset(of: characterSet)
        }else if textField.tag == 6{
            let set = NSCharacterSet.init(charactersIn:NUMERIC_PREDICT)
            let characterSet = CharacterSet(charactersIn: string)
            return set.isSuperset(of: characterSet)
        }
        return true
    }
 
    //MARK: sign up Web service
    func signUpWebService()  {
        let loginObj = LoginWebServices()
        loginObj.signUpService(full_name: self.fullnameTF.text!, email: self.emailTF.text!, password: self.passwordTF.text!,imageurl:self.imageUrl,type:self.signuptype,  onSuccess: {response in
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
                    HPLActivityHUD.dismiss()
                    //self.verifyPhoneNo()
                self.firebaseLogin()
            }else{
                HPLActivityHUD.dismiss()
                Utility.shared.showAlert(msg: response.value(forKey: "message") as! String, status: "1")
            }
        }, onFailure: {errorResponse in
        })
    }
    //MARK: sign in Web service
    func signInService()  {
        let signinServiceObj = LoginWebServices()
        signinServiceObj.signInService(email: self.emailTF.text!, password: self.passwordTF.text!,country_code:self.country_code!,phone_no: self.phone_no!,type:"withphone", onSuccess: {response in
            HPLActivityHUD.dismiss()
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
                UserModel.shared.removeEmergencyContact()
                UserModel.shared.setUserInfo(userDict: response)
                UserModel.shared.setProfilePic(URL: response.object(forKey: "user_image") as! NSString)
                UserModel.shared.setWalletAmt(wallet_amt:response.value(forKey: "walletmoney") as! NSNumber)
                Utility.shared.registerPushServices()
                Utility.shared.goToHomePage()
            }else{
            }
        }, onFailure: {errorResponse in
            HPLActivityHUD.dismiss()
        })
    }
    
}
extension SignUpPage: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        print(error?.localizedDescription ?? "")
        if error == nil {
            let phoneNumberKit = PhoneNumberKit()
            do {
                let phoneNumbers = try phoneNumberKit.parse(authDataResult?.user.phoneNumber ?? "")
                self.phone_no = "\(phoneNumbers.nationalNumber)"
                self.country_code = "\(phoneNumbers.countryCode)"
                HPLActivityHUD.showActivity(with: .withMask)
                self.signInService()
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
extension SFSafariViewController {
    override open var modalPresentationStyle: UIModalPresentationStyle {
        get { return .fullScreen}
        set { super.modalPresentationStyle = newValue }
    }
}
@available(iOS 13.0, *)
extension SignUpPage: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))")
            if appleIDCredential.fullName?.familyName != nil{
                print("new signin")
                self.fullnameTF.text = "\(appleIDCredential.fullName?.givenName ?? "")" + " \(appleIDCredential.fullName?.familyName ?? "")"
                self.emailTF.text = appleIDCredential.email
                self.imageUrl = ""
                self.signuptype = ""
                let dict: [String: String]!
                dict = ["givenName": "\(appleIDCredential.fullName?.givenName ?? "")", "familyName": "\(appleIDCredential.fullName?.familyName ?? "")","email": "\(appleIDCredential.email ?? "")"]
                UserModel.shared.setAppleIDWithMail(email: dict, userID: appleIDCredential.user)
            }else{
                print("already signin")
                if UserModel.shared.getAppleIDWithMail(userID: appleIDCredential.user) != nil {
                    let loginData = UserModel.shared.getAppleIDWithMail(userID: appleIDCredential.user)
                    self.fullnameTF.text = (loginData?["givenName"] ?? "") + (loginData?["familyName"] ?? "")
                    self.emailTF.text = loginData?["email"]
                    self.imageUrl = ""
                    self.signuptype = ""
                }
                
            }

        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}
