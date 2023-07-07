//
//  WalletHistory.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 20/04/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit

class WalletHistory: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var navigationView: UIView!
    @IBOutlet var titleLbl: UILabel!
    
    @IBOutlet var no_resultView: UIView!
    @IBOutlet var historyTableView: UITableView!
    var historyArray = NSMutableArray()    
    @IBOutlet var noLbl: UILabel!
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
            self.noLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        else {
            self.view.transform = .identity
            self.titleLbl.transform = .identity
            self.titleLbl.textAlignment = .left
            self.noLbl.transform = .identity
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: set up intial details
    func setupInitialDetails()  {
        
        self.navigationView.elevationEffect()
        self.titleLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text: "wallet_history")
        self.noLbl.config(color: TEXT_TERTIARY_COLOR, size: 15, align: .center, text: "no_wallet")
        historyTableView.register(UINib(nibName: "WalletCell", bundle: nil), forCellReuseIdentifier: "WalletCell")
        HPLActivityHUD.showActivity(with: .withMask)
        self.getWalletHistory()

    }
    
    //get history of wallet transaction
    func getWalletHistory()  {
        let historyObj = PaymentServices()
        historyObj.getWalletHistory(onSuccess: {response in
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
                self.historyArray.addObjects(from: (response.value(forKey: "payment_list") as! NSArray) as! [Any])
            }else if status.isEqual(to: STATUS_FALSE){
            }
            self.checkAvailability()
        })
    }
    

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int{
            return historyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let historyCell = tableView.dequeueReusableCell(withIdentifier: "WalletCell", for: indexPath) as! WalletCell
            let historyDict:NSDictionary =  self.historyArray.object(at: indexPath.row) as! NSDictionary
            historyCell.config(walletDict: historyDict)
        return historyCell
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 70
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath){
    
    }

    
    //check view availablity
    func checkAvailability() {
        print("history array \(self.historyArray)")
            if self.historyArray.count == 0{
                self.historyTableView.isHidden = true
                self.no_resultView.isHidden = false
            }else{
                self.no_resultView.isHidden = true
                self.historyTableView.isHidden = false
                self.historyTableView.reloadData()
            }
        HPLActivityHUD.dismiss()

    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
