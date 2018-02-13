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
        
        View.layer.masksToBounds = false
        View.layer.shadowColor = UIColor.black.cgColor
        View.layer.shadowOpacity = 0.5
        View.layer.shadowOffset = CGSize(width: -1, height: 1)
        View.layer.shadowRadius = 1
        
        View.layer.shadowPath = UIBezierPath(rect: View.bounds).cgPath
        View.layer.shouldRasterize = true
        View.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
