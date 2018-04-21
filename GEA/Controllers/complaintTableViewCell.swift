//
//  complaintTableViewCell.swift
//  GEA
//
//  Created by Wejdan Aziz on 01/04/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit

class complaintTableViewCell: UITableViewCell {
    @IBOutlet weak var Discription: UITextView!
    @IBOutlet weak var EventName: UILabel!
    @IBOutlet weak var Contact: UIButton!
    @IBOutlet weak var CV: UIView!

    override func awakeFromNib() {
       // Discription.layer.cornerRadius = 20
    CV.layer.cornerRadius = 20
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
