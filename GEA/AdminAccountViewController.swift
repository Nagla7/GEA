//
//  AdminAccountViewController.swift
//  GEA
//
//  Created by Reem Al-Zahrani on 17/02/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AdminAccountViewController: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var fname: HoshiTextField!
    @IBOutlet weak var lname: HoshiTextField!
    @IBOutlet weak var email: HoshiTextField!
    @IBOutlet weak var phone: HoshiTextField!
    @IBOutlet weak var username: HoshiTextField!
    @IBOutlet weak var newpass: HoshiTextField!
    @IBOutlet weak var newrepass: HoshiTextField!
    private var currentTextField: UITextField?
    var loggedInUser:AnyObject?
    var databaseRef : DatabaseReference!
    var firstname_ = ""
    var lastname_ = ""
    var email_ = ""
    var phonenumber_ = ""
    var username_ = ""
    var valids = Array(repeating: true, count: 9)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loggedInUser = Auth.auth().currentUser
        self.databaseRef = Database.database().reference()
        self.fname.delegate = self
        self.lname.delegate = self
        self.email.delegate = self
        self.phone.delegate = self
        self.username.delegate = self
        self.newpass.delegate = self
        self.newrepass.delegate = self
        
        self.databaseRef.child("Users").child(self.loggedInUser!.uid).observe(.value, with: { (snapshot) in
            let snapshot = snapshot.value as! [String: AnyObject]
            
            self.firstname_ = snapshot["firstname"] as! String
            self.lastname_ = snapshot["lastname"] as! String
            self.email_ = snapshot["email"] as! String
            self.phonenumber_ = snapshot["phonenumber"] as! String
            self.username_ = snapshot["username"] as! String
            
            self.fname.textColor = UIColor.lightGray
            self.lname.textColor = UIColor.lightGray
            self.email.textColor = UIColor.lightGray
            self.phone.textColor = UIColor.lightGray
            self.username.textColor = UIColor.lightGray
            
            self.fname.text = self.firstname_
            self.lname.text = self.lastname_
            self.email.text = self.email_
            self.phone.text = self.phonenumber_
            self.username.text = self.username_
            
            self.saveButton.isEnabled = false
        })
    }
    
    
    @IBAction func SaveAction(_ sender: Any) {
        
        if let currentTextField = currentTextField {
            currentTextField.resignFirstResponder()
        }
        
        // check if all fields are valid
        if(valids[0] && valids[1] && valids[2] && valids[3] && valids[4] && valids[5] && valids[6] && valids[7] && valids[8]){
            
            // if fields changed then update database
            if !(self.fname.text == self.firstname_){
                self.databaseRef.child("Users").child(self.loggedInUser!.uid).child("firstname").setValue(self.fname.text)
            }
            
            if !(self.lname.text == self.lastname_){
                self.databaseRef.child("Users").child(self.loggedInUser!.uid).child("lastname").setValue(self.lname.text)
            }
            
            if !(self.email.text == self.email_){
                Auth.auth().currentUser?.updateEmail(to: self.email.text!) { error in
                    if let error = error {
                        print(error)
                    } else {
                        self.databaseRef.child("Users").child(self.loggedInUser!.uid).child("email").setValue(self.email.text)
                    }
                }
            }
            
            if !(self.phone.text == self.phonenumber_){
                self.databaseRef.child("Users").child(self.loggedInUser!.uid).child("phonenumber").setValue(self.phone.text)
            }
            
            if !(self.username.text == self.username_){
                self.databaseRef.child("Users").child(self.loggedInUser!.uid).child("username").setValue(self.username.text)
            }
            
            if !(self.newpass.text == "" && self.newrepass.text == ""){
                Auth.auth().currentUser?.updatePassword(to: self.newpass.text!) { error in
                    if let error = error {
                        print(error)
                    } else {
                        print("Password Updated")
                        self.newpass.text = ""
                        self.newrepass.text = ""
                    }
                }
            }
            
        } else {
            popUpMessage(title: "Can't Save Changes!", message: "Make sure all fields are in correct format and not empty.")
        }
    }
    
    // ================== SAVE BUTTON COLOR ======================
    @IBAction func textFieldDidChange(_ sender: Any) {
        print("textField: \(String(describing: currentTextField?.text))")
        currentTextField?.resignFirstResponder()
        
        // change save button color if there was a change in valid text fieids
        let textFieldsValid = valids[0] && valids[1] && valids[2] && valids[3] && valids[4] && valids[5] && valids[6] && valids[7] && valids[8]
        let textFieldsChanged = ((self.fname.text != self.firstname_) || (self.lname.text != self.lastname_) || (self.email.text != self.email_) || (self.phone.text != self.phonenumber_) || (self.username.text != self.username_) || !(self.newpass.text == "" && self.newrepass.text == ""))
        
        currentTextField?.becomeFirstResponder()
        
        if (textFieldsValid && textFieldsChanged){
            saveButton.backgroundColor = UIColor(red:0.13, green:0.64, blue:0.62, alpha:1.0)
            saveButton.isEnabled = true
        } else {
            saveButton.backgroundColor = UIColor(red:0.77, green:0.91, blue:0.91, alpha:1.0)
            saveButton.isEnabled = false
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
        if (textField == fname)
        {
            let name_reg = "[A-Za-z ]{1,30}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if (name_test.evaluate(with: fname.text) == false) || (fname.text == "")
            {
                valids[0] = false
                erroneousTextField()
                popUpMessage(title: "Format Error", message: "First name can contain letters only.")
            } else {
                valids[0] = true
            }
        }
        
        if (textField == lname)
        {
            let name_reg = "[A-Za-z ]{1,30}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if (name_test.evaluate(with: lname.text) == false)  || (lname.text == "")
            {
                valids[1] = false
                erroneousTextField()
                popUpMessage(title: "Format Error", message: "Last name can contain letters only.")
            } else {
                valids[1] = true
            }
        }
        
        if (textField == username)
        {
            let name_reg = "[A-Za-z0-9]{5,20}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if (name_test.evaluate(with: username.text) == false)  || (username.text == "")
            {
                valids[2] = false
                erroneousTextField()
                popUpMessage(title: "Format Error", message: "Username has to be at least 5 characters long and can contain letters and numbers.")
            } else {
                valids[2] = true
            }
            
            //  check usernames excluding current user username!
            databaseRef.child("Users").queryOrdered(byChild: "username").queryEqual(toValue: username.text!.lowercased()).observeSingleEvent(of: .value , with: { snapshot in
                if (snapshot.exists() && !(self.username.text!.lowercased() == self.username_)){
                    self.valids[3] = false
                    self.erroneousTextField()
                    self.popUpMessage(title: "Uh oh!", message: "\(self.username.text!) is not available. Try another username.")
                } else {
                    self.valids[3] = true
                }
            })
        }
        
        if (textField == email)
        {
            let name_reg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if (name_test.evaluate(with: email.text) == false) || (email.text == "")
            {
                valids[4] = false
                erroneousTextField()
                popUpMessage(title: "Format Error", message: "Enter the E-mail in correct format. e.g. example@domain.com")
            } else {
                valids[4] = true
            }
        }
        
        if (textField == phone)
        {
            let name_reg = "[0-9]{10}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if (name_test.evaluate(with: phone.text) == false) || (phone.text == "")
            {
                valids[5] = false
                erroneousTextField()
                popUpMessage(title: "Format Error", message: "Phone number has to be 10 digits long.")
            } else {
                valids[5] = true
            }
        }
        
        if (textField == newpass)
        {
            let name_reg = "[A-Z0-9a-z._%@+-]{6,10}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if (name_test.evaluate(with: newpass.text) == false && (newpass.text != ""))
            {
                valids[6] = false
                erroneousTextField()
                popUpMessage(title: "Format Error", message: "Password has to be at least 6 characters long and can contain letters, numbers and special characters ( . _ % @ + - )")
            } else {
                valids[6] = true
            }
        }
        
        if (textField == newrepass)
        {
            let name_reg = "[A-Z0-9a-z._%@+-]{6,10}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if (name_test.evaluate(with: newrepass.text) == false && (newrepass.text != ""))
            {
                valids[7] = false
                erroneousTextField()
                popUpMessage(title: "Format Error", message: "Password has to be at least 6 characters long and can contain letters, numbers and special characters ( . _ % @ + - )")
            } else {
                valids[7] = true
            }
            
            if !(newrepass.text == newpass.text){
                valids[8] = false
                erroneousTextField()
                popUpMessage(title: "Uh oh!", message: "Passwords don't match! Please re-enter matching passwords.")
            } else {
                valids[8] = true
            }
        }
        
    }


}
