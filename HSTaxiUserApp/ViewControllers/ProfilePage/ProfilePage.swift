//
//  ProfilePage.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 24/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
//import AccountKit
import AVFoundation
import FirebaseUI
import PhoneNumberKit
import GoogleMobileAds

class ProfilePage: UIViewController,editViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var editIcon: UIImageView!
    @IBOutlet weak var emergencyIcon: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var languageTextField: FloatLabelTextField!
    @IBOutlet var profileImgView: UIImageView!
    @IBOutlet var emailTF: FloatLabelTextField!
    @IBOutlet var nameTF: FloatLabelTextField!
    @IBOutlet var passwordTF: FloatLabelTextField!
    @IBOutlet var phoneTF: FloatLabelTextField!
    @IBOutlet var emergencyTF: FloatLabelTextField!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var logoutBtn: UIButton!
    @IBOutlet var changeBtn: UIButton!
    
    @IBOutlet var deleteAccountBtn: UIButton!
    
    @IBOutlet var editView: UIView!
    
    var country_code = String()
    var phone_no    = String()
    //    var accountKit: AccountKitManager?
    let userServiceObj  = UserServices()
    let imagePicker = UIImagePickerController()
    let authUI = FUIAuth.defaultAuthUI()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if UIDevice.current.hasNotch {
          
            scrollView.contentSize = CGSize.init(width:0 , height: 800)
        }else{
         
            scrollView.contentSize = CGSize.init(width:0 , height: 800)
        }
        
        
        self.setupInitialDetails()
        HPLActivityHUD.showActivity(with: .withMask)
        self.getProfileDetails()
        let providers: [FUIAuthProvider] = [
            FUIPhoneAuth(authUI:FUIAuth.defaultAuthUI()!),
        ]
        authUI?.delegate = self
        self.authUI?.providers = providers
        let language = UserModel.shared.getAppLanguage()
    
        self.languageTextField.text = Utility.shared.getLanguage()?.value(forKey: language ?? "") as? String ?? ""
    }
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.textAlignment = .right
            self.languageTextField.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.languageTextField.textAlignment = .right
            self.emailTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.emailTF.textAlignment = .right
            self.nameTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.nameTF.textAlignment = .right
            self.passwordTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.passwordTF.textAlignment = .right
            self.phoneTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.phoneTF.textAlignment = .right
            self.emergencyTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.emergencyTF.textAlignment = .right
            self.emergencyIcon.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.profileImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.editIcon.transform = CGAffineTransform(scaleX: -1, y: 1)

        }
        else {
            self.view.transform = .identity
            self.titleLbl.transform = .identity
            self.titleLbl.textAlignment = .left
            self.languageTextField.transform = .identity
            self.languageTextField.textAlignment = .left
            self.emailTF.transform = .identity
            self.emailTF.textAlignment = .left
            self.nameTF.transform = .identity
            self.nameTF.textAlignment = .left
            self.passwordTF.transform = .identity
            self.passwordTF.textAlignment = .left
            self.phoneTF.transform = .identity
            self.phoneTF.textAlignment = .left
            self.emergencyTF.transform = .identity
            self.emergencyTF.textAlignment = .left
            self.emergencyIcon.transform = .identity
            self.profileImgView.transform = .identity
            self.editIcon.transform = .identity

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
    override func viewWillAppear(_ animated: Bool) {
        print("called view will appear")
        self.changeToRTL()
    }
    
    //MARK:initial setup
    func setupInitialDetails()   {
        //phone num verification
        //        self.accountKit = AccountKitManager.init(responseType: ResponseType.accessToken)
        self.imagePicker.delegate = self
        self.navigationView.elevationEffect()
        self.titleLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text: "profile")
        self.nameTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "name")
        self.emailTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "email")
        self.languageTextField.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "language_title")
        
        self.passwordTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "password")
        self.phoneTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "phonenumber")
        self.emergencyTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "sos_alert")
        self.changeBtn.config(color: TEXT_PRIMARY_COLOR, size: 12, align: .right, title: "change")
        self.editView.cornerViewRadius()
        self.editView.elevationEffect()
        
        self.profileImgView.makeItRound()
        self.logoutBtn.cornerMiniumRadius()
        self.logoutBtn.layer.borderWidth = 1
        self.logoutBtn.layer.borderColor = PRIMARY_COLOR.cgColor
        self.logoutBtn.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .center, title: "logout")
        self.logoutBtn.newEffect()
        
        self.deleteAccountBtn.cornerMiniumRadius()
        self.deleteAccountBtn.layer.borderWidth = 1
        self.deleteAccountBtn.layer.borderColor = PRIMARY_COLOR.cgColor
        self.deleteAccountBtn.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .center, title: "delete_account")
        self.deleteAccountBtn.newEffect()
        
        self.setProfileDetails()
        // Banner Ads
//        self.bannerAds()
    }
    func setProfileDetails()  {
        self.emergencyTF.text = Utility.shared.getLanguage()?.value(forKey: "emergency_contact") as? String
        self.nameTF.text = UserModel.shared.getUserDetails().value(forKey: "full_name") as? String
        self.emailTF.text = UserModel.shared.getUserDetails().value(forKey: "email") as? String
        self.passwordTF.text = UserModel.shared.getPassword()! as String
        let phoneNumber = UserModel.shared.getUserDetails().value(forKey: "phone_number") as? String ?? "\(UserModel.shared.getUserDetails().value(forKey: "phone_number") as? NSNumber ?? 0)"
        
        //        let phoneNumber:NSString = UserModel.shared.getUserDetails().value(forKey: "phone_number") as! NSString
        let countryCode:NSNumber = UserModel.shared.getUserDetails().value(forKey: "country_code") as! NSNumber
        self.phoneTF.text = ("+\(countryCode) \(phoneNumber)")
        if (UserModel.shared.getProfilePic() != nil) {
            profileImgView.sd_setImage(with: URL(string: UserModel.shared.getProfilePic()! as String), placeholderImage: #imageLiteral(resourceName: "placeholder_image"))
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func changePasswordBtnTapped(_ sender: Any) {
        let editObj = EditView()
        editObj.modalPresentationStyle = .fullScreen
//        editObj.modalTransitionStyle = .crossDissolve
        editObj.viewType = "password"
        editObj.delegate = self
        addChildViewController(editObj)
        editObj.view.frame = self.view.bounds
        view.addSubview(editObj.view)
        editObj.didMove(toParentViewController: self)

//        self.present(editObj, animated: true, completion: nil)
    }
    
    @IBAction func changeNameBtnTapped(_ sender: Any) {
        let editObj = EditView()
//        editObj.modalPresentationStyle = .overCurrentContext
//        editObj.modalTransitionStyle = .crossDissolve
        editObj.viewType = "name"
        editObj.delegate = self
        editObj.fullName = self.nameTF.text!
        addChildViewController(editObj)
        editObj.view.frame = self.view.bounds
        view.addSubview(editObj.view)
        editObj.didMove(toParentViewController: self)

//        self.present(editObj, animated: true, completion: nil)
    }
    
    @IBAction func emergencyBtnTapped(_ sender: Any) {
        let emergencyObj = EmergecnyContactPage()
        emergencyObj.modalPresentationStyle = .fullScreen
        self.present(emergencyObj, animated: true, completion: nil)
    }
    
    @IBAction func changeBtnTapped(_ sender: Any) {
        self.firebaseLogin()
    }
    
    @IBAction func logoutBtnTapped(_ sender: Any) {
        self.logoutAlert()
    }
    
    @IBAction func deleteAccountBtnTapped(_ sender: Any) {
        

        AJAlertController.initialization().showAlert(aStrMessage: "want_to_delete_user", aCancelBtnTitle: "cancel", aOtherBtnTitle: "okay", status: "1", completion: { (index, title) in
            print(index,title)
            if index == 1{
                self.delete()
            }
        })
        
        
    }
    
    
    func delete()  {
     //   if Utility.shared.isConnectedToNetwork() {
                if UserModel.shared.userID() != nil {
                    
                    let Obj = UserServices()
                    Obj.deleteAccountService(onSuccess: {response in
                        
                        let status:NSString = response.value(forKey: "status") as! NSString
                       
                        if status.isEqual(to: STATUS_TRUE){
                            
                            UserModel.shared.DeleteUser()
                            var message = "account_has_deleted"
                            
                            AJAlertController.initialization().showAlertWithOkButton(aStrMessage: message, status: "", completion: { (index, title) in
                                
                                if #available(iOS 9.0, *) {
                                    let welcomeObj = WelcomePage()
                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                    appDelegate.setInitialViewController(initialView: welcomeObj)
                                }
                            })

                            

                        } else {
                            
                            if status.isEqual(to: STATUS_FALSE){
                                let message = "cant delete alert"
                                AJAlertController.initialization().showAlertWithOkButton(aStrMessage: message, status: "", completion: { (index, title) in
                                    
                                })
                            }else{
                                let message = "server_alert"
                                AJAlertController.initialization().showAlertWithOkButton(aStrMessage: message, status: "", completion: { (index, title) in
                                    
                                })
                            }
                            

                        }
                        
                    })

                   
                }
            
        //}
    }
    
    //MARK: profile pic edit button action
    @IBAction func profilePicEditBtnTapped(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: Utility.shared.getLanguage()?.value(forKey: "camera") as? String, style: .default) { (action) in
            if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                //already authorized
                self.moveToCamera()
            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    if granted {
                        //access allowed
                        self.moveToCamera()
                    } else {
                        //access denied
                        DispatchQueue.main.async {
                            self.cameraPermissionAlert()
                        }
                    }
                })
            }
        }
        let gallery = UIAlertAction(title: Utility.shared.getLanguage()?.value(forKey: "gallery") as? String, style: .default) { (action) in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.modalPresentationStyle = .fullScreen
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: Utility.shared.getLanguage()?.value(forKey: "cancel") as? String, style: .cancel)
        alertController.addAction(camera)
        alertController.addAction(gallery)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    //move to camera
    func moveToCamera()   {
        DispatchQueue.main.async {
                    self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            self.imagePicker.modalPresentationStyle = .fullScreen
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    //MARK:location restriction alert
    func cameraPermissionAlert(){
        AJAlertController.initialization().showAlert(aStrMessage: "camera_permission", aCancelBtnTitle: "cancel", aOtherBtnTitle: "settings", status: "1", completion: { (index, title) in
            print(index,title)
            if index == 1{
                //open settings page
                if let url = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        })
    }
    
    //    func _prepareLoginViewController(_ loginViewController: (UIViewController & AKFViewController)?) {
    //        // Optionally, you may set up backup verification methods.
    //        loginViewController?.isSendToFacebookEnabled = true
    //        loginViewController?.uiManager = SkinManager.init(skinType: .classic, primaryColor: PRIMARY_COLOR)
    //    }
    
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
    //                self.phone_no = (account?.phoneNumber?.phoneNumber)!
    //                self.country_code = (account?.phoneNumber?.countryCode)!
    //                self.updatePhoneNumber()
    //            }
    //        }
    //    }
    
    //    func viewController(_ viewController: (UIViewController & AKFViewController), didFailWithError error: Error) {
    //        print("failed \(error.localizedDescription) ")
    //    }
    
    // MARK: Get profile details
    func  getProfileDetails()  {
        userServiceObj.getProfileInfo(onSuccess: {response in
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
                HPLActivityHUD.dismiss()
                UserModel.shared.setUserModels(userDict: response)
                UserModel.shared.removeEmergencyContact()
                UserModel.shared.setProfilePic(URL: response.object(forKey: "user_image") as! NSString)
                UserModel.shared.setWalletAmt(wallet_amt: response.value(forKey: "walletmoney") as! NSNumber)
                if ((response["emergency_contact"]) != nil) {
                    UserModel.shared.setEmergencyContact(contactArray: response.object(forKey: "emergency_contact") as! NSArray)
                }
                self.setProfileDetails()
            }else{
                HPLActivityHUD.dismiss()
                Utility.shared.showAlert(msg: response.value(forKey: "message") as! String, status: "1")
            }
        })
    }
    
    //MARK: update phone number
    func updatePhoneNumber()  {
        userServiceObj.updatePhoneNumber(country_code: self.country_code, phone_no: self.phone_no, onSuccess: {response in
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
                self.getProfileDetails()
            }else{
                Utility.shared.showAlert(msg: "server_alert", status: "1")
            }
        })
    }
    
    //MARK: Upload profile picture
    func uploadProfilePicService(imageBase64:Data)  {
        let upoloadObj = UploadServices()
        upoloadObj.uploadProfilePic(profileimage:imageBase64 , onSuccess:{response in
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
                UserModel.shared.setProfilePic(URL: response.value(forKey: "user_image") as! NSString)
                self.setProfileDetails()
                HPLActivityHUD.dismiss()
                DispatchQueue.main.async{
                    self.view.makeToast(Utility.shared.getLanguage()?.value(forKey: "profile_pic_success") as? String, align: UserModel.shared.getAppLanguage() ?? "English")
                }
            }else{
                Utility.shared.showAlert(msg: "server_alert", status: "1")
            }
        })
    }
    
    
    //edit view delegate
    func didEditChangesCompleted(type: String) {
        if type == "password"{
            self.setProfileDetails()
        }else if type == "name"{
            self.getProfileDetails()
        }
    }
    
    //MARK:contact restriction alert
    func logoutAlert()  {
        AJAlertController.initialization().showAlert(aStrMessage: "logout_alert", aCancelBtnTitle: "cancel", aOtherBtnTitle: "okay", status: "1", completion: { (index, title) in
            print(index,title)
            if index == 1{
                //logout action
                UserModel.shared.logoutUser()
            }
        })
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profileImgView.image = pickedImage
            HPLActivityHUD.showActivity(with: .withMask)
            let imageData: NSData = UIImageJPEGRepresentation(pickedImage, 0)! as NSData
            self.uploadProfilePicService(imageBase64:imageData as Data)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension ProfilePage: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        print(error?.localizedDescription ?? "")
        if error == nil {
            let phoneNumberKit = PhoneNumberKit()
            do {
                let phoneNumbers = try phoneNumberKit.parse(authDataResult?.user.phoneNumber ?? "")
                self.phone_no = "\(phoneNumbers.nationalNumber)"
                self.country_code = "\(phoneNumbers.countryCode)"
                self.updatePhoneNumber()
                
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
extension ProfilePage: UITextFieldDelegate, languageDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        languageTextField.resignFirstResponder()
        if textField == languageTextField {
            let editObj = LanguagePage()
            editObj.modalPresentationStyle = .overCurrentContext
            editObj.modalTransitionStyle = .crossDissolve
            editObj.delegate = self
            self.present(editObj, animated: true, completion: nil)
            
        }
    }
    func selectedLanguage(language: String) {
        DispatchQueue.main.async {
            //setup language
            UserModel.shared.setAppLanguage(Language: language)
            Utility.shared.configureLanguage()
            Utility.shared.registerPushServices()
            self.languageTextField.text = Utility.shared.getLanguage()?.value(forKey: language) as? String ?? ""
            self.setupInitialDetails()
            self.changeToRTL()
        }
    }
}
//extension ProfilePage: GADBannerViewDelegate {
//    func bannerAds() {
//        if (BANNER_AD_ENABLED == true) {
//            self.bannerView.isHidden = true
//            self.configAds()
//        }
//        else {
//            self.bannerView.isHidden = true
//        }
//    }
//    func configAds()  {
//        bannerView.adUnitID = AD_UNIT_ID
//        bannerView.rootViewController = self
//        bannerView.load(GADRequest())
//        bannerView.delegate = self
//    }
//    //banner view delegate
//    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
//        bannerView.isHidden = false
//    }
//    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
//        print("BANNER ERROR \(error.localizedDescription)")
//    }
//}


extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
