//
//  SetTaskViewController.swift
//  ATodoList
//
//  Created by Thomas Houghton on 16/07/2017.
//  Copyright © 2017 Thomas Houghton. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SetTaskViewController: UIViewController {

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextField: UITextView!
    
    var text = "Hello world!"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        popUpView.layer.cornerRadius = 10 // Set the corner radius of the pop up view.
        taskDescriptionTextField.text! = text
    }
    
    @IBAction func setTaskBtnTapped(_ sender: Any) {
        let currentUser = Auth.auth().currentUser?.uid
        let newTask = ["TaskName":taskNameTextField.text!, "TaskDescription":taskDescriptionTextField.text!]
        _ = Database.database().reference().child("Users").child(currentUser!).child("Tasks").childByAutoId().setValue(newTask)
        print("New task added. Name: \(taskNameTextField.text!). Description: \(taskDescriptionTextField.text!).")
        dismiss(animated: true, completion: nil)
    }
}
