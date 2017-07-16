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
import FirebaseStorage

class TasksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var userTasks : [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        nameLabel.text = "Complete setup in settings!"
        let currentUser = Auth.auth().currentUser!.uid
        
        Database.database().reference().child("Users").child(currentUser).child("Tasks").observe(DataEventType.childAdded) { (snapshot) in
            print(snapshot)
            let myTask = Task()
            let value = snapshot.value as? NSDictionary
            let name = value?["TaskName"] as? String ?? ""
            let desc = value?["TaskDescription"] as? String ?? ""
            
            myTask.taskName = name
            myTask.taskDescription = desc
            self.userTasks.append(myTask)
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let currentUser = Auth.auth().currentUser!.uid
        Database.database().reference().child("Users").child(currentUser).observeSingleEvent(of: DataEventType.value) { (snapshot) in
            // Get user name
            let value = snapshot.value as? NSDictionary
            let name = value?["name"] as? String ?? ""
            self.nameLabel.text = name
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let taskName = userTasks[indexPath.row]
        cell.textLabel?.text = taskName.taskName
        return cell 
    }
    
    @IBAction func addTaskTapped(_ sender: Any) {
        performSegue(withIdentifier: "taskSegue", sender: nil)
    }
}
