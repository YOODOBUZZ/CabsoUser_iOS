//
//  ForgotPasswordPage.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 27/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit

class ForgotPasswordPage: UIViewController,UITextFieldDelegate {
    @IBOutlet var emailBorderLbl: UILabel!
    @IBOutlet var resetBtn: UIButton!
    @IBOutlet var emailTF: FloatLabelTextField!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var navigationView: UIView!
    
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
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.textAlignment = .right
            self.resetBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.emailTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.emailTF.textAlignment = .right
        }
        else {
            self.view.transform = .identity
            self.titleLbl.transform = .identity
            self.titleLbl.textAlignment = .left
            self.emailTF.transform = .identity
            self.emailTF.textAlignment = .left
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: set up intial details
    func setupInitialDetails()  {
        self.navigationView.elevationEffect()
        self.titleLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text: "fogotpassword")
        self.resetBtn.config(color: .white, size: 17, align: .center, title: "reset")
        self.resetBtn.cornerMiniumRadius()
        self.resetBtn.backgroundColor = PRIMARY_COLOR
        self.emailTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "email")
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetBtnTapped(_ sender: Any) {
        if isValidationSuccess() {
            self.emailTF.resignFirstResponder()
            HPLActivityHUD.showActivity(with: .withMask)
            self.resetPasswordService()
        }
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
        }else{
            self.clearValidation()
            status = true
        }
        return status
    }
    //MARK: Clear text field validation
    func clearValidation()  {
        self.emailTF.setAsValidTF()
        self.emailBorderLbl.backgroundColor = .lightGray
        self.emailBorderLbl.backgroundColor?.withAlphaComponent(0.5)
    }
    //MARK: Textfield delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       self.clearValidation()
        return true
    }
    //MARK: Reset password web service
    func resetPasswordService()  {
        let userObj = UserServices()
        userObj.resetPassword(email: self.emailTF.text!, onSuccess: {response in
            HPLActivityHUD.dismiss()
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
                
                AJAlertController.initialization().showAlertWithOkButton(aStrMessage: response.value(forKey: "message") as! String, status: "", completion: { (index, title) in
                    self.dismiss(animated: true, completion: nil)
                })
                
            }else if status.isEqual(to: STATUS_FALSE){
                Utility.shared.showAlert(msg:response.value(forKey: "message") as! String, status: "")
            }
        })
    }
   
}
