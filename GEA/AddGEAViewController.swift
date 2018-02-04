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


    @IBOutlet weak var fname: UITextField!
    @IBOutlet weak var lname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fname.delegate = self
        lname.delegate = self
        email.delegate = self
        username.delegate = self
        password.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textfield:UITextField)->Bool{
        textfield.resignFirstResponder()
        return true}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func createAccountAction(_ sender: Any) {
        
        // variable to reference our database from firebase
        let ref : DatabaseReference!
        ref = Database.database().reference()
        
        if self.fname.text == "" || self.lname.text! == "" || self.email.text! == "" || self.username.text! == "" || self.password.text! == "" {
            //error message: fields empty
            let alertController = UIAlertController(title: "Error", message: "All fields are required. Please enter all your info.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
        } else {
            ref.child("Users").queryOrdered(byChild: "username").queryEqual(toValue: username.text!.lowercased()).observeSingleEvent(of: .value , with: { snapshot in
                if !snapshot.exists() {
                    // Update database with a unique username.
                    
                    Auth.auth().createUser(withEmail: self.email.text!, password: self.password.text!) { (user, error) in
                        if error == nil {
                            print("You have successfully signed up")
                            // add user to the users tree
                            //and set value of email property to the value taken from textfield
                            //later on we will add more properties... e.g. username.. profile pic.. bio..
                            ref.child("Users").child(user!.uid).setValue(["firstname":self.fname.text!,"lastname":self.lname.text!,"email": self.email.text!,"username": self.username.text!.lowercased(),"type":"gea", "UID": user!.uid]
                            )
                            // redirect to admin main page
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "admin")
                            self.present(vc!, animated: true, completion: nil)
                        } else {
                            //error message: signup failed
                            let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                    
                }
                else {
                    //error message: username already exists
                    let alertController = UIAlertController(title: "Uh oh!", message: "\(self.username.text!) is not available. Try another username.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }) {error in print(error.localizedDescription)}
            
        }
        
        
    }
    

}
