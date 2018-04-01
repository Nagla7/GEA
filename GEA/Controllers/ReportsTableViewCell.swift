//
//  ReportsTableViewCell.swift
//  GEA
//
//  Created by njoool  on 01/04/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit

class ReportsTableViewCell: UITableViewCell {

    @IBOutlet var ReportedUser: UILabel!
    
    @IBOutlet var view: UIView!
    @IBOutlet var reason: UILabel!
    @IBOutlet var Review: UITextView!
    @IBOutlet var DeleteBtn: UIButton!
    @IBOutlet var DismissBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
