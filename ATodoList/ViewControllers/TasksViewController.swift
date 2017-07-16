//
//  TasksViewController.swift
//  ATodoList
//
//  Created by Thomas Houghton on 16/07/2017.
//  Copyright © 2017 Thomas Houghton. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class TasksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    
    let tasks = ["Task01", "Tasks02"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        nameLabel.text = "Complete setup in settings!"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let currentUser = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("Users").child(currentUser!).observeSingleEvent(of: DataEventType.value) { (snapshot) in
            // Get user name
            let value = snapshot.value as? NSDictionary
            let name = value?["name"] as? String ?? ""
            self.nameLabel.text = name
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = tasks[indexPath.row]
        return cell
    }
}
