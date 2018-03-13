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

class RegulationController: UIViewController, UITableViewDelegate, UITableViewDataSource,RegulationDelegate {
    

    

  
    //    @IBOutlet weak var Blure: UIVisualEffectView!
    @IBOutlet weak var noRegulation: UILabel!
    @IBOutlet weak var tableView: UITableView!
        @IBOutlet weak var Text: UITextField!
        @IBOutlet var AddView: UIView!
        var ref : DatabaseReference!
        var dbHandle:DatabaseHandle?
        var Regulations = [NSDictionary]()
        var model=Model()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            //Blure.isHidden = true
            tableView.delegate=self
            tableView.dataSource=self
             
            AddView.layer.shadowColor = UIColor.black.cgColor
            AddView.layer.shadowOpacity = 0.5
            AddView.layer.shadowOffset = CGSize(width: -2, height: 2)
            AddView.layer.shadowRadius = 1
            model.delegate=self
            model.getRegulation()

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
            cell.RegulationText.layer.masksToBounds=true
            cell.RegulationText.layer.cornerRadius=10
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
    
    func receiveRegulation(data: [NSDictionary]) {
        if data.count != 0{
        self.Regulations=data
            self.tableView.reloadData()
            self.noRegulation.isHidden=true
            self.tableView.isHidden=false}else{
            self.noRegulation.isHidden=false
            self.tableView.isHidden=true}
    }
}


