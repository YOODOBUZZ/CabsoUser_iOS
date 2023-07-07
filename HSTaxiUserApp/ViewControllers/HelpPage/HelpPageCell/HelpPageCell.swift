//
//  HelpPageCell.swift
//  HSLiveStream
//
//  Created by APPLE on 20/02/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit

class HelpPageCell: UITableViewCell {

    @IBOutlet weak var helpTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        helpTitle.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, text: EMPTY_STRING)
        self.changeToRTL()
    }
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.helpTitle.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.helpTitle.textAlignment = .right
        }
        else {
            self.helpTitle.transform = .identity
            self.helpTitle.textAlignment = .left
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
