//
//  FirstLoginViewController.swift
//  GEA
//
//  Created by Reem Al-Zahrani on 04/03/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class FirstLoginViewController: UIViewController {

    @IBOutlet weak var password: HoshiTextField!
    @IBOutlet weak var repassword: HoshiTextField!
    var ref : DatabaseReference! = nil
    var email = ""
    var currentTextField : UITextField?
    var valids = Array(repeating: true, count: 3)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }

    @IBAction func resetPasswordAction(_ sender: Any) {
        
        if let currentTextField = currentTextField {
            currentTextField.resignFirstResponder()
        }
        
        if(valids[0] && valids[1] && valids[2]){
            if !(self.password.text == "" && self.repassword.text == ""){
                Auth.auth().currentUser?.updatePassword(to: self.password.text!) { error in
                    if let error = error {
                        print(error)
                    } else {
                        print("Password Updated")
                        self.popUpMessage(title: "Success", message: "Password Updated Successfully")
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "gea")
                        self.present(vc!, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    // ================== POP UP MESSAGE ======================
    func popUpMessage(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }

    
    // ================== TEXT FIELD COLOR ======================
    func erroneousTextField(){
        (currentTextField as! HoshiTextField).borderThickness=(active: 2, inactive: 2)
        (currentTextField as! HoshiTextField).borderInactiveColor=UIColor.red
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // ================== TEXTFIELD VALIDATION ======================
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        
        if (textField == password)
        {
            let name_reg = "[A-Z0-9a-z._%@+-]{6,10}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if (name_test.evaluate(with: password.text) == false && (password.text != ""))
            {
                valids[0] = false
                erroneousTextField()
                popUpMessage(title: "Format Error", message: "Password has to be at least 6 characters long and can contain letters, numbers and special characters ( . _ % @ + - )")
            } else {
                valids[0] = true
            }
        }
        
        if (textField == repassword)
        {
            let name_reg = "[A-Z0-9a-z._%@+-]{6,10}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if (name_test.evaluate(with: repassword.text) == false && (repassword.text != ""))
            {
                valids[1] = false
                erroneousTextField()
                popUpMessage(title: "Format Error", message: "Password has to be at least 6 characters long and can contain letters, numbers and special characters ( . _ % @ + - )")
            } else {
                valids[1] = true
            }
            
            if !(repassword.text == password.text){
                valids[2] = false
                erroneousTextField()
                popUpMessage(title: "Uh oh!", message: "Passwords don't match! Please re-enter matching passwords.")
            } else {
                valids[2] = true
            }
        }
        
    }
}
