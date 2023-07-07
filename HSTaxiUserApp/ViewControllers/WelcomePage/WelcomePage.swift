//
//  WelcomePage.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 09/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit

class WelcomePage: UIViewController {
    
    @IBOutlet weak var sloganLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupInitialDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: set up intial details
    func setupInitialDetails()  {
        self.navigationController?.isNavigationBarHidden = true
        
        self.containerView.backgroundColor = PRIMARY_COLOR
        self.sloganLbl.config(color: .white, size: 17, align: .center, text: "slogan")
        self.loginBtn.config(color: .white, size: 17, align: .center, title: "login")
        self.signupBtn.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .center, title: "signup")
        self.signupBtn.cornerMiniumRadius()
        self.loginBtn.cornerMiniumRadius()
        self.loginBtn.setBorder(color:.white)
        self.signupBtn.setBorder(color:.white)
        
     
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func signInBtnTapped(_ sender: Any) {
        let signInObj = SignInPage()
        self.navigationController?.pushViewController(signInObj, animated: true)
    }
    
    @IBAction func signUpBtnTapped(_ sender: Any) {
        DispatchQueue.main.async{
        let signUpObj = SignUpPage()
        self.navigationController?.pushViewController(signUpObj, animated: true)
        }
    }
    
}
