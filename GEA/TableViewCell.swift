//
//  TableViewCell.swift
//  GEA
//
//  Created by njoool  on 12/02/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var View: UIView!
    @IBOutlet weak var RegulationText: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
