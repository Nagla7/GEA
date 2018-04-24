//
//  AddVenuesController.swift
//  GEA
//
//  Created by Wejdan Aziz on 13/02/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage



class AddVenuesController: UIViewController, UITextFieldDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var databaseRef = Database.database().reference()
    var storageRef = Storage.storage().reference()
    @IBOutlet weak var vImg: UIImageView!
    @IBOutlet weak var VenueName: HoshiTextField!
    @IBOutlet weak var Cost: HoshiTextField!
    @IBOutlet weak var capacity: HoshiTextField!
    @IBOutlet weak var PhoneNum: HoshiTextField!
    @IBOutlet weak var Email: HoshiTextField!
    @IBOutlet weak var website: HoshiTextField!
    
    @IBOutlet weak var location: HoshiTextField!
    var randomID : String = ""
    var venueImgurl : URL!
    // var imagePicker : UIImagePickerController!
    var ref : DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        VenueName.delegate = self
        Cost.delegate = self
        capacity.delegate = self
        PhoneNum.delegate = self
        website.delegate = self
        Email.delegate = self
        location.delegate = self
        
        ref = Database.database().reference()
        randomID = ref.childByAutoId().key
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // _______ Databasse_______________
    @IBAction func addVenueAction(_ sender: Any) {
        
        var flag =  Bool()
        flag = self.VenueName.text == "" || self.Cost.text! == "" || self.capacity.text! == "" || self.PhoneNum.text! == "" || self.website.text! == "" || self.Email.text! == ""
        
        
        
        if flag {
            print("************")
            let alertController = UIAlertController(title: "Error", message: "All fields are required. Please enter all the informations.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)}
            
        else {
            
            ref.child("Venues").child(self.randomID).setValue(["VenueName": self.VenueName.text!, "VID": randomID , "Cost": self.Cost.text! , "Capacity": self.capacity.text! , "phoneNum": self.PhoneNum.text! , "website": self.website.text! , "Email": self.Email.text! , "Location": self.location.text!])
            
            
            if let imageData: Data = UIImagePNGRepresentation(self.vImg.image!)!
            {
                let VPicStorageRef = self.storageRef.child("Venue/\(self.VenueName.text)/Pic")
                let uploadTask = VPicStorageRef.putData(imageData, metadata: nil)
                {metadata,error in
                    if(error == nil)
                    {
                        let downloadUrl = metadata!.downloadURL()
                        self.databaseRef.child("Venues").child(self.randomID).child("pic").setValue(String(describing:downloadUrl!))
                        _ = self.navigationController?.popViewController(animated: true)
                        
                        let SP = UIStoryboard(name: "Main" , bundle: nil)
                        let RInfo = SP.instantiateViewController(withIdentifier: "venue") as! VenuesTable1ViewController
                        self.dismiss(animated: true, completion: nil)
                    }
                    else {print(error!.localizedDescription)}
                }
            }
            
        }
        
    }
    //___________Fields_______________
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == VenueName)
        {
            let name_reg = "[A-Za-z ]{1,50}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if name_test.evaluate(with: VenueName.text) == false
            {
                let alert = UIAlertController(title: "Format Error", message: "Venue name can contain letters only.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        
        
        if (textField == Email)
        {
            let name_reg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if name_test.evaluate(with: Email.text) == false
            {
                let alert = UIAlertController(title: "Format Error", message: "Enter the E-mail in correct format. e.g. example@domain.com ", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        if (textField == PhoneNum)
        {
            let name_reg = "[0-9]{10}"
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            if name_test.evaluate(with: PhoneNum.text) == false
            {
                let alert = UIAlertController(title: "Format Error", message: "Phone number has to be 10 digits long.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    //__________________Add picture acction_______________
    
    @IBAction func AddNewImg(_ sender: Any){
        let image = UIImagePickerController()
        image.delegate = self
        
        let imgSource = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        imgSource.addAction(UIAlertAction(title: "Camera", style: .default, handler: { ( ACTION: UIAlertAction) in image.sourceType = .camera
            self.present(image, animated: true , completion: nil)
        }))
        
        
        imgSource.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { ( ACTION: UIAlertAction) in image.sourceType = .photoLibrary
            self.present(image, animated: true , completion: nil)
        }))
        
        
        imgSource.addAction(UIAlertAction(title: "Cancel", style: .default, handler:nil ))
        self.present(imgSource , animated: true , completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            vImg.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

