//
//  CustomButton.swift
//  GEA
//
//  Created by user2 on ١٩ جما١، ١٤٣٩ هـ.
//  Copyright © ١٤٣٩ هـ com.GP.ET. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    var button = UIButton()
    
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            layer.cornerRadius = cornerRadius
        }
    }
    
    func updateView(){
        
        button.layer.cornerRadius = frame.height/2
        
        
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}

