//
//  ViewController.swift
//  ATodoList
//
//  Created by Thomas Houghton on 15/07/2017.
//  Copyright © 2017 Thomas Houghton. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {
    
    @IBOutlet weak var segementController: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var SignUpSignInBtn: UIButton!
    @IBOutlet weak var subView: UIView! // Subview behind the 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        subView.layer.cornerRadius = 10
        // subViewSetUp()
    }
    
    func subViewSetUp() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = subView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func indexChangedSegmentController(_ sender: Any) {
        switch segementController.selectedSegmentIndex
        {
        case 0:
            SignUpSignInBtn.setTitle("LOGIN", for: UIControlState.normal)
        case 1:
            SignUpSignInBtn.setTitle("SIGN UP", for: UIControlState.normal)
        default:
            break
        }
    }
    
    @IBAction func SignInSignUp(_ sender: Any) {
        switch segementController.selectedSegmentIndex {
        case 0:
            signIn()
        case 1:
            signUp()
        default:
            break
        }
    }
    
    func signIn() {
        print("Sign In")
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            print("We tried to sign in")
            if error != nil {
                print("We have an error: \(String(describing: error))")
                self.SignUpSignInBtn.setTitle("Sign in failed!", for: UIControlState.normal)
            }else {
                print("Sign in successful!")
                self.performSegue(withIdentifier: "tasksSegue", sender: nil)
            }
        }
    }
    
    func signUp() {
        print("Sign Up")
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print("we have an error: \(String(describing: error))")
            }else{
                print("Sign up successful!")
                self.SignUpSignInBtn.setTitle("Sign up failed!", for: UIControlState.normal)
                let users = Database.database().reference().child("Users").child(user!.uid).child("email").setValue(user!.email)
                self.performSegue(withIdentifier: "tasksSegue", sender: nil)
            }
        }
    }
}

