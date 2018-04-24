//
//  ReqTableViewCell.swift
//  GEA
//
//  Created by Wejdan Aziz on 02/04/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit

class ReqTableViewCell: UITableViewCell {
   
    @IBOutlet weak var EventName: UILabel!
    @IBOutlet weak var serviceP: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
