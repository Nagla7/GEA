//
//  Popup.swift
//  GEA
//
//  Created by leena hassan on 22/05/1439 AH.
//  Copyright © 1439 com.GP.ET. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class Popup: UIViewController {

    @IBOutlet weak var text: UITextField!
    var ref : DatabaseReference!
    @IBOutlet weak var AddView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view != AddView{self.dismiss(animated:true, completion:nil)}
    }
    
    @IBAction func Publish(_ sender: UIButton) {
         ref=Database.database().reference()
        var reference  = ref.child("Regulations").childByAutoId()
        reference.child("Description").setValue(text.text)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Regulation")
        self.present(vc!, animated: true, completion: nil)
    }
    
}

