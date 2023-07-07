//
//  LanguagePage.swift
//  HSTaxiUserApp
//
//  Created by Hitasoft on 04/12/19.
//  Copyright © 2019 APPLE. All rights reserved.
//

import UIKit
protocol languageDelegate {
    func selectedLanguage(language:String)
}
class LanguagePage: UIViewController {
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backBtnImage: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    var languageArr = ["English"]
    var languageCodeArr = ["en","iw"]
    var delegate:languageDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.initialSetup()
        self.changeToRTL()
    }
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLable.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLable.textAlignment = .right
        }
        else {
            self.view.transform = .identity
            self.titleLable.transform = .identity
            self.titleLable.textAlignment = .left
        }
    }
    func initialSetup() {
        self.tableView.register(UINib(nibName: "LanguageCell", bundle: nil), forCellReuseIdentifier: "LanguageCell")
        self.navigationView.elevationEffect()
        self.titleLable.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text: "language_title")

    }
    @IBAction func backButtonAct(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension LanguagePage: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell") as! LanguageCell
        
//        cell.textLabel?.text = self.languageArr[indexPath.row]
        let language = UserDefaults.standard.value(forKey: "language_name") as? String ?? ""
        cell.textLabel?.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, text: self.languageArr[indexPath.row])
        cell.accessoryType = . none
        if language == self.languageArr[indexPath.row] {
            let image = UIImage(named: "tick_icon")
            let checkmark  = UIImageView(frame:CGRect(x:0, y:0, width:20, height:20));
            checkmark.image = image
            cell.accessoryView = checkmark

        }
        else {
            cell.accessoryView = nil
        }

        if UserModel.shared.getAppLanguage() == "Arabic" {
            cell.textLabel?.transform = CGAffineTransform(scaleX: -1, y: 1)
            cell.textLabel?.textAlignment = .right
            cell.accessoryView?.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        else {
            cell.textLabel?.transform = .identity
            cell.textLabel?.textAlignment = .left
            cell.accessoryView?.transform = .identity
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! LanguageCell
        let language = UserDefaults.standard.value(forKey: "language_name") as? String ?? ""
        if language == self.languageArr[indexPath.row] {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        UserModel.shared.LANGUAGE_CODE = self.languageCodeArr[indexPath.row]
       self.delegate?.selectedLanguage(language: self.languageArr[indexPath.row])
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
//        Utility.shared.goToHomePage()
    }
    
}
