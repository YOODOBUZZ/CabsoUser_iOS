//
//  EditView.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 24/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
protocol editViewDelegate {
    func didEditChangesCompleted(type:String)
}

class EditView: UIViewController ,UITextFieldDelegate{

    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var oldPasswordTF: FloatLabelTextField!
    @IBOutlet var newPasswordTF: FloatLabelTextField!
    @IBOutlet var confirmPasswordTF: FloatLabelTextField!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet var fullnameTF: FloatLabelTextField!
    @IBOutlet var oldBorderLbl: UILabel!
    @IBOutlet var newBorderLbl: UILabel!
    @IBOutlet var confirmBorderLbl: UILabel!
    @IBOutlet var showBtn: UIButton!
    @IBOutlet var containerView: UIView!
    @IBOutlet var nameSendBtn: UIButton!
    @IBOutlet var nameCancelBtn: UIButton!

    @IBOutlet var nameTitleLbl: UILabel!
    @IBOutlet var nameEditView: UIView!
    var viewType = String()
    var fullName = String()
    var showEnable = Bool()
    var delegate : editViewDelegate?
    var editTag = 0
    
    @IBOutlet var fullnameBorderLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupInitialDetails()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.changeToRTL()
    }
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
//            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.nameTitleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.newPasswordTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.newPasswordTF.textAlignment = .right
            self.oldPasswordTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.oldPasswordTF.textAlignment = .right
            self.confirmPasswordTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.confirmPasswordTF.textAlignment = .right
            self.fullnameTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.fullnameTF.textAlignment = .right
            self.showBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.showBtn.contentHorizontalAlignment = .left

            self.nameCancelBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.nameSendBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.cancelBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.sendBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        else {
            self.view.transform = .identity
            self.titleLbl.transform = .identity
            self.nameTitleLbl.transform = .identity
            self.newPasswordTF.transform = .identity
            self.newPasswordTF.textAlignment = .left
            self.oldPasswordTF.transform = .identity
            self.oldPasswordTF.textAlignment = .left
            self.confirmPasswordTF.transform = .identity
            self.confirmPasswordTF.textAlignment = .left
            self.fullnameTF.transform = .identity
            self.fullnameTF.textAlignment = .left
            self.showBtn.transform = .identity
            self.showBtn.contentHorizontalAlignment = .right
            self.nameCancelBtn.transform = .identity
            self.nameSendBtn.transform = .identity
            self.cancelBtn.transform = .identity
            self.sendBtn.transform = .identity
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: set up intial details
    func setupInitialDetails()  {
        self.titleLbl.config(color: TEXT_PRIMARY_COLOR, size: 25, align: .center, text: "password")
        self.oldPasswordTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "old_password")
        self.newPasswordTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "new_password")
        self.confirmPasswordTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "repassword")
        self.fullnameTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "name")
        self.sendBtn.config(color: .white, size: 17, align: .center, title: "save")
        self.cancelBtn.config(color: TEXT_TERTIARY_COLOR, size: 17, align: .center, title: "cancel")
        self.nameSendBtn.config(color: .white, size: 17, align: .center, title: "save")
        self.nameCancelBtn.config(color: TEXT_TERTIARY_COLOR, size: 17, align: .center, title: "cancel")
        self.nameTitleLbl.config(color: TEXT_PRIMARY_COLOR, size: 25, align: .center, text: "full_name")
        self.sendBtn.cornerMiniumRadius()
        self.sendBtn.backgroundColor = PRIMARY_COLOR
        self.nameSendBtn.cornerMiniumRadius()
        self.nameSendBtn.backgroundColor = PRIMARY_COLOR
        self.showEnable =  false
        self.showBtn.config(color: TEXT_PRIMARY_COLOR, size: 14,
                            align: .right, title: "show")
        if viewType == "password" {
            self.nameEditView.isHidden = true
            self.containerView.isHidden =  false
        }else if viewType == "name"{
            self.nameEditView.isHidden = false
            self.fullnameTF.text = self.fullName
            self.containerView.isHidden =  true
        }
    }

    @IBAction func cancelBtnTapped(_ sender: Any) {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
//        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendBtnTapped(_ sender: Any) {
        if isValidationSuccess() {
            HPLActivityHUD.showActivity(with: .withMask)
            let passwordObj = UserServices()
            passwordObj.changePassword(new_password: self.confirmPasswordTF.text!, onSuccess: {response in
                let status:NSString = response.value(forKey: "status") as! NSString
                if status.isEqual(to: STATUS_TRUE){
                    UserModel.shared.setPassword(password: self.confirmPasswordTF.text! as NSString)
                    self.delegate?.didEditChangesCompleted(type: self.viewType)
                    self.view.removeFromSuperview()
                    self.removeFromParentViewController()

//                    self.dismiss(animated: true, completion: nil)
                }else{
                    Utility.shared.showAlert(msg: "server_alert", status: "")
                }
                HPLActivityHUD.dismiss()
            })
        }
    }
    
    @IBAction func nameUpdateTapped(_ sender: Any) {
        if self.fullnameTF.isEmptyValue(){
            self.fullnameBorderLbl.backgroundColor = RED_COLOR
            self.fullnameTF.setAsInvalidTF("enter_name", in: self.nameEditView)
        }else if (self.fullnameTF.text?.count)!<3{
            self.fullnameBorderLbl.backgroundColor = RED_COLOR
            self.fullnameTF.setAsInvalidTF("name_limit", in: self.view)
        }else{
            let nameObj = UserServices()
            nameObj.updateName(name: self.fullnameTF.text!, onSuccess: {response in
                let status:NSString = response.value(forKey: "status") as! NSString
                if status.isEqual(to: STATUS_TRUE){
                    self.delegate?.didEditChangesCompleted(type: self.viewType)
                    self.view.removeFromSuperview()
                    self.removeFromParentViewController()

//                    self.dismiss(animated: true, completion: nil)
                }else{
                    Utility.shared.showAlert(msg: "server_alert", status: "")
                }
                HPLActivityHUD.dismiss()
            })
        }
    }
    
    @IBAction func showBtnTapped(_ sender: Any) {
        if self.showEnable {
            self.showBtn.config(color: TEXT_PRIMARY_COLOR, size: 14, align: .right, title: "show")
            self.newPasswordTF.isSecureTextEntry = true
            self.showEnable = false
        }else{
            self.showBtn.config(color: TEXT_PRIMARY_COLOR, size: 14, align: .right, title: "hide")
            self.showEnable = true
            self.newPasswordTF.isSecureTextEntry = false
        }
    }
    
    //MARK: Check text field validation
    func isValidationSuccess() -> Bool {
        var status:Bool = false
        if self.oldPasswordTF.isEmptyValue(){
            self.oldBorderLbl.backgroundColor = RED_COLOR
            self.oldPasswordTF.setAsInvalidTF("enter_oldpassword", in: self.containerView)
        }else if self.oldPasswordTF.text != UserModel.shared.getPassword()! as String{
            self.oldBorderLbl.backgroundColor = RED_COLOR
            self.oldPasswordTF.setAsInvalidTF("oldpassword_wrong", in: self.containerView)
        }else if self.newPasswordTF.isEmptyValue() {
            self.newBorderLbl.backgroundColor = RED_COLOR
            self.newPasswordTF.setAsInvalidTF("enter_newpassword", in: self.containerView)
        }else if (self.newPasswordTF.text?.count)!<6{
            self.newBorderLbl.backgroundColor = RED_COLOR
            self.newPasswordTF.setAsInvalidTF("password_limit", in: self.view)
        }else if self.confirmPasswordTF.isEmptyValue(){
            self.confirmBorderLbl.backgroundColor = RED_COLOR
            self.confirmPasswordTF.setAsInvalidTF("enter_repassword", in: self.containerView)
        }else if self.newPasswordTF.text != self.confirmPasswordTF.text{
            self.confirmBorderLbl.backgroundColor = RED_COLOR
            self.confirmPasswordTF.setAsInvalidTF("password_not_match", in: self.containerView)
        }else{
            status = true
            self.clearValidation()
        }
        return status
    }
    //MARK: Clear text field validation
    func clearValidation()  {
        self.oldPasswordTF.setAsValidTF()
        self.newPasswordTF.setAsValidTF()
        self.confirmPasswordTF.setAsValidTF()
        
        self.oldBorderLbl.backgroundColor = SEPARTOR_COLOR
        self.newBorderLbl.backgroundColor = SEPARTOR_COLOR
        self.confirmBorderLbl.backgroundColor = SEPARTOR_COLOR

    }
    
    //MARK: Textfield delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.clearValidation()
        let full_string = textField.text!+string
        
        if textField.tag == 4 {
            let set = NSCharacterSet.init(charactersIn:ALPHA_PREDICT)
            let characterSet = CharacterSet(charactersIn: string)
            if full_string.count>30{
                return false
            }
            return true //set.isSuperset(of: characterSet)
        }
        return true
    }
    
  
}
