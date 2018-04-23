//
//  RegulationControllerTableViewCell.swift
//  GEA
//
//  Created by njoool  on 13/02/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit

class RegulationControllerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var RegulationText: UITextView!

    @IBOutlet weak var more_btn: UIButton!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func more_pressed(_ sender: UIButton) {
       
       adjustUITextViewHeight(arg: RegulationText)
        more_btn.isHidden=true
    }
    func adjustUITextViewHeight(arg : UITextView)
    {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
    }
}
