//
//  SettingsViewController.swift
//  ATodoList
//
//  Created by Thomas Houghton on 16/07/2017.
//  Copyright © 2017 Thomas Houghton. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var setNameLabel: UILabel!
    @IBOutlet weak var setNameTextField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    var options = ["Set Name"]
    let setNameActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setNameItems(active: true)
    }
    
    func setNameItems(active:Bool) {
        setNameLabel.isHidden = active
        setNameTextField.isHidden = active
        saveBtn.isHidden = active
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if options[indexPath.row] == "Set Name" {
            setNameItems(active: setNameActive)
        }
    }
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        let currentUserUID = Auth.auth().currentUser?.uid
        let newName = setNameTextField.text!
        Database.database().reference().child("Users").child(currentUserUID!).child("name").setValue(newName)
        print("Set new name: \(newName)")
    }
}
