//
//  AddGEAViewController.swift
//  GEA
//
//  Created by Reem Al-Zahrani on 04/02/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class AddGEAViewController: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var fname: HoshiTextField!
    @IBOutlet weak var lname: HoshiTextField!
    @IBOutlet weak var email: HoshiTextField!
    @IBOutlet weak var username: HoshiTextField!
    @IBOutlet weak var password: HoshiTextField!
    @IBOutlet weak var repassword: HoshiTextField!
    private var currentTextField: UITextField?
    var valids = Array(repeating: true, count: 9)
    var ref : DatabaseReference!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        fname.delegate = self
        lname.delegate = self
        email.delegate = self
        username.delegate = self
        password.delegate = self
        repassword.delegate = self
        
        ref = Database.database().reference()
    }
    
    func textFieldShouldReturn(_ textfield:UITextField)->Bool{
        textfield.resignFirstResponder()
        return true}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
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
    
    @IBAction func createAccountAction(_ sender: Any) {
        
        if let currentTextField = currentTextField {
            currentTextField.resignFirstResponder()
        }
        
        var textFieldsValid : Bool!
        textFieldsValid = valids[0] && valids[1] && valids[2] && valids[3] && valids[4] && valids[5] && valids[6] && valids[7] && valids[8]
        
        if(textFieldsValid){
                Auth.auth().createUser(withEmail: self.email.text!, password: self.password.text!) { (user, error) in
                    if error == nil {
                        self.ref.child("Users").child(user!.uid).setValue(["firstname":self.fname.text!,"lastname":self.lname.text!,"email": self.email.text!.lowercased(),"username": self.username.text!.lowercased(),"UID": user!.uid, "firstlogin":"true"])
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "admin")
                        self.present(vc!, animated: true, completion: nil)
                    } else {
                        self.popUpMessage(title: "Error", message: (error?.localizedDescription)!)
                    }
                }
            }
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated:true, completion: nil)
    }
    
    // ================== TEXTFIELD VALIDATION ======================
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        
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
            if (name_test.evaluate(with: lname.text) == false) || (lname.text == "")
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
                username.borderInactiveColor=UIColor.red
                erroneousTextField()
                popUpMessage(title: "Format Error", message: "Username has to be at least 5 characters long and can contain letters and numbers.")
            } else {
                valids[2] = true
            }
            
            //  check username uniqueness
            ref.child("Users").queryOrdered(byChild: "username").queryEqual(toValue: username.text!.lowercased()).observeSingleEvent(of: .value , with: { snapshot in
                if snapshot.exists() {
                    self.valids[3] = false
                    self.erroneousTextField()
                    self.popUpMessage(title: "Uh oh!", message: "\(self.username.text!) is not available. Try another username.")
                } else {
                    self.valids[3] = true
                }
            })
            
        }
        
        if (textField == password)
        {
            let name_reg = "[A-Z0-9a-z._%@+-]{6,10}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if (name_test.evaluate(with: password.text) == false) || (password.text == "")
            {
                valids[4] = false
                erroneousTextField()
                popUpMessage(title: "Format Error", message: "Password has to be at least 6 characters long and can contain letters, numbers and special characters ( . _ % @ + - )")
            } else {
                self.valids[4] = true
            }
        }
        
        if (textField == repassword)
        {
            let name_reg = "[A-Z0-9a-z._%@+-]{6,10}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if (name_test.evaluate(with: repassword.text) == false) || (repassword.text == "")
            {
                valids[5] = false
                erroneousTextField()
                popUpMessage(title: "Format Error", message: "Password has to be at least 6 characters long and can contain letters, numbers and special characters ( . _ % @ + - )")
            } else {
                self.valids[5] = true
            }
            
            
            if !(repassword.text == password.text){
                valids[6] = false
                erroneousTextField()
                popUpMessage(title: "Uh oh!", message: "Passwords don't match! Please re-enter matching passwords.")
            } else {
                self.valids[6] = true
            }
        }
        
        if (textField == email)
        {
            let name_reg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if (name_test.evaluate(with: email.text) == false) || (email.text == "")
            {
                valids[7] = false
                erroneousTextField()
                popUpMessage(title: "Format Error", message: "Enter the E-mail in correct format. e.g. example@domain.com")
            } else {
                self.valids[7] = true
            }
            
            //  check email uniqueness
            ref.child("Users").queryOrdered(byChild: "email").queryEqual(toValue: email.text!.lowercased()).observeSingleEvent(of: .value , with: { snapshot in
                if snapshot.exists() {
                    self.valids[8] = false
                    self.erroneousTextField()
                    self.popUpMessage(title: "Uh oh!", message: "\(self.email.text!.lowercased()) already exists. Try another email.")
                } else {
                    self.valids[8] = true
                }
            })
        }
    }

}
