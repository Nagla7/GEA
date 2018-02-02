//
//  LoginViewController.swift
//  GEA
//
//  Created by user2 on ١٤ جما١، ١٤٣٩ هـ.
//  Copyright © ١٤٣٩ هـ com.GP.ET. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController , UITextFieldDelegate {
    
    
    var ref : DatabaseReference! = nil
//    let ref : DatabaseReference! = Database.database().reference()
    @IBOutlet weak var passwordTextField: DesignableTextField!
    @IBOutlet weak var usernameTextField: DesignableTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref =  Database.database().reference()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    ///////////////////////////Segment///////////////////////
  /*  @IBAction func SelectUserTybe(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("GEA")
        case 1:
            print("Admin")
        default:
            print("none")
        }
    }*/
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textfield:UITextField)->Bool{
        textfield.resignFirstResponder()
        return true
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        if self.usernameTextField.text == "" || self.passwordTextField.text == "" {
            
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields
            let alertController = UIAlertController(title: "Error", message: "Please enter an username and password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        }     else {

            // search database for the username ---> get the corresponding email
            ref.child("Users").queryOrdered(byChild: "username").queryEqual(toValue: self.usernameTextField.text!.lowercased()).observeSingleEvent(of: .value , with: { snapshot in
                      if snapshot.exists() {
                    
                    //getting the email to login
                    var email = ""
                    var type = ""
                    let data = snapshot.value as! [String: Any]
                    for (_,value) in data {
                        let user = value as? NSDictionary
                        email = user!["email"] as! String
                        type = user!["type"] as! String
                    }
                    
                    // login with email and password from firebase
                    Auth.auth().signIn(withEmail: email, password: self.passwordTextField.text!) { (user, error) in
                        if error == nil {
                            
                            //Go to the HomeViewController if the login is sucessful
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: type)
                            self.present(vc!, animated: true, completion: nil)
                            
                        } else {
                            //Tells the user that there is an error and then gets firebase to tell them the error
                            let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                } else {
                    //error message: username already exists
                    let alertController = UIAlertController(title: "Uh oh!", message: "Wrong username or password.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    }
