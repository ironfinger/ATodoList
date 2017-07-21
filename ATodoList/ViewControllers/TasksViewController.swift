//
//  TasksViewController.swift
//  ATodoList
//
//  Created by Thomas Houghton on 16/07/2017.
//  Copyright © 2017 Thomas Houghton. All rights reserved.
//
//
// Things to do: - Look at JTAppleCalender: https://cocoapods.org/pods/JTAppleCalendar
//


import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class TasksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewTaskSubView: UIView! // This sub view is is used to display the task that the user selected.
    @IBOutlet weak var taskTitleLabel: UILabel! // This is in the view task sub view.
    
    
    var userTasks : [Task] = []
    var taskSubVCVisible = false // This is used to track the viewTaskSubView to see if it is in view.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        nameLabel.text = "Complete setup in settings!"
        self.viewTaskSubView.alpha = 0
        viewTaskSubView.layer.cornerRadius = 10
        tableView.layer.cornerRadius = 10
        
        pullTasks() // Fetch the tasks.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
    
    func pullTasks() { // Pulls tasks from the database.
        let currentUser = Auth.auth().currentUser!.uid // Fetches the current userUUID from the firebase server.
        Database.database().reference().child("Users").child(currentUser).child("Tasks").observe(DataEventType.childAdded) { (snapshot) in // Gets the tasks stored in the database.
            print(snapshot)
            let myTask = Task()
            let value = snapshot.value as? NSDictionary
            // Fetch the necessary information about the tasks.
            let name = value?["TaskName"] as? String ?? ""
            let desc = value?["TaskDescription"] as? String ?? ""
            // You may need to get the UUID of the tasks for viewing the task.
            
            myTask.taskName = name
            myTask.taskDescription = desc
            
            self.userTasks.append(myTask)
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.clear
        let taskName = userTasks[indexPath.row]
        cell.textLabel?.text = taskName.taskName
        return cell 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // performSegue(withIdentifier: "viewTaskSegue", sender: nil)
        taskTitleLabel.text = userTasks[indexPath.row].taskName
        if taskSubVCVisible == false {
            UIView.animate(withDuration: 0.25, animations: {
                self.viewTaskSubView.alpha = 1
                // target location: X = 566 Y = 489.
                // current location: X = 573  Y = 873
                // self.viewTaskSubView.frame.origin.y -= 384
            }, completion: nil)
        }
        taskSubVCVisible = true
    }
    
    @IBAction func taskViewDismissBtnTapped(_ sender: Any) {
        if taskSubVCVisible == true {
            UIView.animate(withDuration: 0.25, animations: {
                self.viewTaskSubView.alpha = 0
                // self.viewTaskSubView.frame.origin.y += 384
            }, completion: nil)
            taskSubVCVisible = false
        }
    }
    
    @IBAction func addTaskTapped(_ sender: Any) {
        performSegue(withIdentifier: "taskSegue", sender: nil)
    }
}
