//
//  EmailViewController.swift
//  GEA
//
//  Created by Reem Al-Zahrani on 11/03/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit
import Mailgun_In_Swift
class EmailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func sendEmailAction(_ sender: Any) {
     
        let mailgun = MailgunAPI(apiKey: "key-f4097be782048132b3290a202bd3b3f5", clientDomain: "et.gp.com")
        
        mailgun.sendEmail(to: "reem-rock3@hotmail.com", from: "Test User <reem-rock3@hotmail.com>", subject: "This is a test", bodyHTML: "<b>test<b>") { mailgunResult in
            
            if mailgunResult.success{
                print("Email was sent")
            }
            
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
