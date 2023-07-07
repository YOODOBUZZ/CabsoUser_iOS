//
//  SideMenuPage.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 15/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit

class SideMenuPage: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet var editdesLbl: UILabel!
    @IBOutlet var usernameLbl: UILabel!
    @IBOutlet var profileImgView: UIImageView!
    @IBOutlet var menuTableView: UITableView!
    var menuArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.editdesLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.editdesLbl.textAlignment = .right
            self.usernameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.usernameLbl.textAlignment = .right
            self.profileImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        else {
            self.view.transform = .identity
            self.editdesLbl.transform = .identity
            self.editdesLbl.textAlignment = .left
            self.usernameLbl.transform = .identity
            self.usernameLbl.textAlignment = .left
            self.profileImgView.transform = .identity
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupInitialDetails()
        self.changeToRTL()
        self.configureMenuDetails()
    }
    //MARK: intital details
    func setupInitialDetails()  {
        self.usernameLbl.config(color: TEXT_PRIMARY_COLOR, size: 26, align: .left, text: EMPTY_STRING)
        self.usernameLbl.text = UserModel.shared.getUserDetails().value(forKey: "full_name") as? String
        if (UserModel.shared.getProfilePic() != nil) {
            profileImgView.sd_setImage(with: URL(string: UserModel.shared.getProfilePic()! as String), placeholderImage: #imageLiteral(resourceName: "placeholder_image"))
        }
        self.editdesLbl.config(color: TEXT_TERTIARY_COLOR, size: 14, align: .left, text: "view_edit")
        self.profileImgView.makeItRound()
    }
    //go to profile page
    @IBAction func profileBtnTapped(_ sender: Any) {
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = false
        }
        let profileObj = ProfilePage()
        self.navigationController?.pushViewController(profileObj, animated: true)
    }
    
    //MARK: custom menu details
    func configureMenuDetails()  {
        let Amt:NSNumber = UserModel.shared.getWalletAmt()!
        var walletAmt = String()
        if Utility().currency() != nil {
            walletAmt = "\(Utility().currency()!) \(Amt)"
        }
        menuArray.removeAllObjects()
        menuTableView.register(UINib(nibName: "MenuTableCell", bundle: nil), forCellReuseIdentifier: "MenuTableCell")
        //     self.addMenu(menu_name: "payment", menu_icon: "menu_1", menu_wallet: EMPTY_STRING)
        self.addMenu(menu_name: "your_rides", menu_icon: "menu_2", menu_wallet: EMPTY_STRING)
        self.addMenu(menu_name: "wallet", menu_icon: "menu_3", menu_wallet: String(walletAmt))
        self.addMenu(menu_name: "invite_earn", menu_icon: "menu_4", menu_wallet: EMPTY_STRING)
        self.addMenu(menu_name: "help", menu_icon: "menu_5", menu_wallet: EMPTY_STRING)
        menuTableView.reloadData()
    }
    
    // adding menu objects to array
    func addMenu(menu_name:String,menu_icon:String,menu_wallet:String) {
        let menuDict  = NSMutableDictionary()
        menuDict.setValue(menu_name, forKey: "menu_name")
        menuDict.setValue(menu_icon, forKey: "menu_icon")
        menuDict.setValue(menu_wallet, forKey: "menu_wallet")
        menuArray.addObjects(from: [menuDict])
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int{
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profileCell = tableView.dequeueReusableCell(withIdentifier: "MenuTableCell", for: indexPath) as! MenuTableCell
        let menuDict:NSDictionary =  menuArray.object(at: indexPath.row) as! NSDictionary
        profileCell.configCell(menuDict: menuDict)
        return profileCell
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = false
        }
        if indexPath.row == 0{
            let historyObj = HistoryPage()
            historyObj.modalPresentationStyle = .fullScreen
            self.navigationController?.present(historyObj, animated: true, completion: nil)
        }else  if indexPath.row == 1{
            let walletObj = WalletPage()
            walletObj.modalPresentationStyle = .fullScreen
            self.navigationController?.present(walletObj, animated: true, completion: nil)
        }else  if indexPath.row == 2{
            let inviteObj = InvitePage()
            inviteObj.modalPresentationStyle = .fullScreen
            self.navigationController?.present(inviteObj, animated: true, completion: nil)
        }else  if indexPath.row == 3{
            let helpObj = HelpPage()
            helpObj.modalPresentationStyle = .fullScreen
            self.navigationController?.present(helpObj, animated: true, completion: nil)
        }
    }
}
