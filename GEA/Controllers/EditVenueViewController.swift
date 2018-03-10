//
//  EditVenueViewController.swift
//  GEA
//
//  Created by Wejdan Aziz on 16/02/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class EditVenueViewController: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var VName: HoshiTextField!
    @IBOutlet weak var cost: HoshiTextField!
    @IBOutlet weak var capacity: HoshiTextField!
    @IBOutlet weak var Email: HoshiTextField!
    @IBOutlet weak var Website: HoshiTextField!
    @IBOutlet weak var PhoneNum: HoshiTextField!
    @IBOutlet weak var location: HoshiTextField!
    private var currentTextField: UITextField?
    var ref: DatabaseReference!
    var VID = ""
    var vname_ = ""
    var cost_ = ""
    var capacity_ = ""
    var email_ = ""
    var website_ = ""
    var phone_ = ""
    var location_ = ""
    var valids = Array(repeating: true, count: 7)
    var venue : NSDictionary?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VName.delegate = self
        self.cost.delegate = self
        self.capacity.delegate = self
        self.Email.delegate = self
        self.Website.delegate = self
        self.PhoneNum.delegate = self
        self.location.delegate = self
        
        ref = Database.database().reference()
        VID = venue!["VID"] as! String
        vname_ = venue!["VenueName"] as! String
        cost_ = venue!["Cost"] as! String
        capacity_ = venue!["Capacity"] as! String
        email_ = venue!["Email"] as! String
        website_ = venue!["website"] as! String
        phone_ = venue!["phoneNum"] as! String
        location_ = venue!["Location"] as! String
        
        VName.textColor = UIColor.lightGray
        cost.textColor = UIColor.lightGray
        capacity.textColor = UIColor.lightGray
        Email.textColor = UIColor.lightGray
        Website.textColor = UIColor.lightGray
        PhoneNum.textColor = UIColor.lightGray
        location.textColor = UIColor.lightGray
        
        VName.text = vname_
        cost.text = cost_
        capacity.text = capacity_
        Email.text = email_
        Website.text = website_
        PhoneNum.text = phone_
        location.text = location_
    }
    
    
    @IBAction func DeleteVenueAction(_ sender: Any) {
        self.ref.child("Venues").child(VID).removeValue()
        _ = navigationController?.popViewController(animated: true)
    }
    

    @IBAction func EditVenueAction(_ sender: UIButton) {

        if let currentTextField = currentTextField {
            currentTextField.resignFirstResponder()
            _ = navigationController?.popViewController(animated: true)
        }
        
        // check if all fields are valid
        if(valids[0] && valids[1] && valids[2] && valids[3] && valids[4] && valids[5] && valids[6]){
            
            // if fields changed then update database
            if !(self.VName.text == self.vname_){
                self.ref.child("Venues").child(VID).child("VenueName").setValue(self.VName.text)
            }
            
            if !(self.cost.text == self.cost_){
                self.ref.child("Venues").child(VID).child("Cost").setValue(self.cost.text)
            }
            
            if !(self.capacity.text == self.capacity_){
                self.ref.child("Venues").child(VID).child("Capacity").setValue(self.capacity.text)
            }
            
            if !(self.Email.text == self.email_){
                self.ref.child("Venues").child(VID).child("Email").setValue(self.Email.text)
            }
            
            if !(self.Website.text == self.website_){
                self.ref.child("Venues").child(VID).child("website").setValue(self.Website.text)
            }
            
            if !(self.PhoneNum.text == self.phone_){
                self.ref.child("Venues").child(VID).child("phoneNum").setValue(self.PhoneNum.text)
            }
            
            if !(self.location.text == self.location_){
                self.ref.child("Venues").child(VID).child("Location").setValue(self.location.text)
            }
            
        } else {
            popUpMessage(title: "Can't Save Changes!", message: "Make sure all fields are in correct format and not empty.")
        }
    }

    // ================== TEXT FIELD COLOR ======================
    func erroneousTextField(){
        (currentTextField as! HoshiTextField).borderThickness=(active: 2, inactive: 2)
        (currentTextField as! HoshiTextField).borderInactiveColor=UIColor.red
        
    }
    
    // ================== POP UP MESSAGE ======================
    func popUpMessage(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = UIColor.black
        currentTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // ================== TEXTFIELD VALIDATION ======================
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        textField.textColor = UIColor.lightGray
        if (textField == VName)
        {
            let name_reg = "[A-Za-z ]{1,50}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if (name_test.evaluate(with: VName.text) == false) || (VName.text == "")
            {
                valids[0] = false
                erroneousTextField()
                popUpMessage(title: "Format Error", message: "Venue name can contain letters only.")
            } else {
                valids[0] = true
            }
        }
        
        if (textField == cost)
        {
            let name_reg = "[0-9,. ]{1,20}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if (name_test.evaluate(with: cost.text) == false) || (cost.text == "")
            {
                valids[1] = false
                erroneousTextField()
                popUpMessage(title: "Format Error", message: "Venue cost can contain numbers only.")
            } else {
                valids[1] = true
            }
        }
        
        //capacity
        if (textField == capacity)
        {
            let name_reg = "[0-9,. ]{1,20}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if (name_test.evaluate(with: capacity.text) == false) || (capacity.text == "")
            {
                valids[2] = false
                erroneousTextField()
                popUpMessage(title: "Format Error", message: "Venue capacity can contain numbers only.")
            } else {
                valids[2] = true
            }
        }
        
        if (textField == Email)
        {
            let name_reg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if (name_test.evaluate(with: Email.text) == false) || (Email.text == "")
            {
                valids[3] = false
                erroneousTextField()
                popUpMessage(title: "Format Error", message: "Enter the E-mail in correct format. e.g. example@domain.com")
            } else {
                valids[3] = true
            }
        }
        
        if (textField == Website)
        {
            let name_reg = "[A-Z0-9a-z._%+-]+.[A-Za-z0-9.-]+\\.[A-Za-z]{1,}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if (name_test.evaluate(with: Website.text) == false)  || (Website.text == "")
            {
                valids[4] = false
                erroneousTextField()
                popUpMessage(title: "Format Error", message: "Enter the website in correct format. e.g. example.domain.com")
            } else {
                valids[4] = true
            }
        }
        
        if (textField == PhoneNum)
        {
            let name_reg = "[0-9]{10}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if (name_test.evaluate(with: PhoneNum.text) == false) || (PhoneNum.text == "")
            {
                valids[5] = false
                erroneousTextField()
                popUpMessage(title: "Format Error", message: "Phone number has to be 10 digits long.")
            } else {
                valids[5] = true
            }
        }
        
        if (textField == location)
        {
            let name_reg = "[A-Z0-9a-z.-]{1,50}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if (name_test.evaluate(with: location.text) == false) || (location.text == "")
            {
                valids[6] = false
                erroneousTextField()
                popUpMessage(title: "Format Error", message: "Venue location can contain letters and numbers only.")
            } else {
                valids[6] = true
            }
        }
        

        
    }
}

