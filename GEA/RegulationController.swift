//
//  RegulationController.swift
//  GEA
//
//  Created by njoool  on 13/02/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class RegulationController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  
    //    @IBOutlet weak var Blure: UIVisualEffectView!
        @IBOutlet weak var tableView: UITableView!
        @IBOutlet weak var Text: UITextField!
        @IBOutlet var AddView: UIView!
        var ref : DatabaseReference!
        var dbHandle:DatabaseHandle?
        var Regulations = [NSDictionary?]()
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            //Blure.isHidden = true
            tableView.delegate=self
            tableView.dataSource=self
            AddView.layer.shadowColor = UIColor.black.cgColor
            AddView.layer.shadowOpacity = 0.5
            AddView.layer.shadowOffset = CGSize(width: -2, height: 2)
            AddView.layer.shadowRadius = 1
            ref=Database.database().reference()
            dbHandle = ref?.child("Regulations").observe(.value, with: { (snapshot) in
                let deta=snapshot.value as! [String:Any]
                print(deta)
                for (_,value) in deta{
                    let Regulation=value as! NSDictionary
                    self.Regulations.append(Regulation)
                }
                
                self.tableView.reloadData()})
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
        func numberOfSections(in tableView: UITableView) -> Int {
            
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return Regulations.count
        }
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RegulationControllerTableViewCell
            
            let Regulation : NSDictionary?
            
            Regulation = Regulations[indexPath.row]
            
            cell.RegulationText.text = Regulation?["Description"] as! String
            
            return(cell)
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            if touches.first?.view != AddView{
                AddView.removeFromSuperview()}
        }
        
        @IBAction func OpenAdd(_ sender: Any) {
 //           Blure.isHidden = false
            self.view.addSubview(AddView)
            AddView.center = self.view.center
            
        }
        
        @IBAction func Publish(_ sender: UIButton) {
            if (Text.text == nil){
                AddView.removeFromSuperview()
//                Blure.isHidden = true
            }
                
            else{
                ref=Database.database().reference()
                var reference  = ref.child("Regulations").childByAutoId()
                reference.child("Description").setValue(Text.text)
                AddView.removeFromSuperview()
  //              Blure.isHidden = true
                
            }
        }
        
        /*
         // Override to support conditional editing of the table view.
         override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         // Return false if you do not want the specified item to be editable.
         return true
         }
         */
        
        /*
         // Override to support editing the table view.
         override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
         // Delete the row from the data source
         tableView.deleteRows(at: [indexPath], with: .fade)
         } else if editingStyle == .insert {
         // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
         }
         }
         */
        
        /*
         // Override to support rearranging the table view.
         override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
         
         }
         */
        
        /*
         // Override to support conditional rearranging of the table view.
         override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
         // Return false if you do not want the item to be re-orderable.
         return true
         }
         */
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destinationViewController.
         // Pass the selected object to the new view controller.
         }
         */
        
}


