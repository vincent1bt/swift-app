//
//  LoginViewController.swift
//  PostsApp
//
//  Created by vicente rodriguez on 8/8/16.
//  Copyright © 2016 vicente rodriguez. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, APIAuthProtocol {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    var authAPI: AuthAPI = AuthAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authAPI.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func login(sender: UIButton) {
        resignFirstResponder()
        guard emailField.text != nil && passwordField.text != nil else {
            return
        }
        
        if !emailField.text!.isEmpty && !passwordField.text!.isEmpty {
            authAPI.login(emailField.text!, password: passwordField.text!)
        }
    }
    
    func didCreateUser() {
    }
    
    func didLogin() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func errorInRequest(error: String) {
        print(error)
    }
    
    @IBAction func unwindForSegue(unwindSegue: UIStoryboardSegue) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
