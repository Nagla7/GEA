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

        @IBInspectable var borderWidth: CGFloat = 0 {
            didSet {
                layer.borderWidth = borderWidth
            }
        }
        //Normal state bg and border
   
        

    
    func updateView(){
        
        button.layer.cornerRadius = frame.height/2
      
        button.layer.borderWidth = borderWidth
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}

