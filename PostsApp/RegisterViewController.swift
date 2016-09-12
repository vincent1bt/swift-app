//
//  RegisterViewController.swift
//  PostsApp
//
//  Created by vicente rodriguez on 8/20/16.
//  Copyright © 2016 vicente rodriguez. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, APIAuthProtocol {

    @IBOutlet weak var passwordConfirmationField: UITextField!
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
    
    @IBAction func signUp(sender: UIButton) {
        resignFirstResponder()
        guard emailField.text != nil && passwordField.text != nil && passwordConfirmationField.text != nil else {
            return
        }
        
        if !emailField.text!.isEmpty && !passwordField.text!.isEmpty && !passwordConfirmationField.text!.isEmpty {
            authAPI.createUser(emailField.text!, password: passwordField.text!, passwordConfirmation: passwordConfirmationField.text!)
        }
    }
    
    func didCreateUser() {
        self.performSegueWithIdentifier("unwindToLogin", sender: self)
    }
    
    func didLogin() {
        //
    }
    
    func errorInRequest(error: String) {
        print(error)
    }
}
