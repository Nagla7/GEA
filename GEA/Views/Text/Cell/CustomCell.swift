//
//  CustomCell.swift
//  GEA
//
//  Created by leena hassan on 30/05/1439 AH.
//  Copyright © 1439 com.GP.ET. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func customInit(text:String){
        self.titleLabel.text=text
        self.titleLabel.textColor = UIColor.white
        self.contentView.backgroundColor = UIColor.darkGray
}
}
