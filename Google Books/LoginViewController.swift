//
//  ViewController.swift
//  Google Books
//
//  Created by Yashaswini Ashrith on 4/19/21.
//

import UIKit
import Firebase
import SwiftSpinner

class LoginViewController: UIViewController {
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblStatus.text = ""
        txtPassword.isSecureTextEntry = true
        imgLogo.layer.borderWidth = 0
        imgLogo.layer.masksToBounds = false
        imgLogo.layer.cornerRadius = imgLogo.frame.height/2
        imgLogo.clipsToBounds = true
        loginBtn.layer.cornerRadius = 10
        txtEmail.layer.cornerRadius = 10
        txtPassword.layer.cornerRadius = 10
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let keyChain = KeychainService().keyChain
        
        if keyChain.get("uid") != nil {
            performSegue(withIdentifier: "dashboardSegue", sender: self)
        }
        txtPassword.text = ""
    }
    
    func addKeychainAfterLogin(_ uid : String){
        let keyChain = KeychainService().keyChain
        keyChain.set(uid, forKey: "uid")
    }

    
    @IBAction func login(_ sender: Any) {
        let email = txtEmail.text!
        let password = txtPassword.text!
        
        if email == "" || password == "" || password.count < 6 {
            lblStatus.text = "Please enter valid email or password"
            return
        }
        
        if email.isEmail == false{
            lblStatus.text = "Please enter valid email"
            return
        }
        
        SwiftSpinner.show("Logging in...")
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            SwiftSpinner.hide()
            guard let self = self else { return }
            
            if error != nil{
                self.lblStatus.text = error?.localizedDescription
                return
            }
            
            let uid = Auth.auth().currentUser?.uid
            
            self.addKeychainAfterLogin(uid!)
            self.lblStatus.text = ""
            
            self.performSegue(withIdentifier: "dashboardSegue", sender: self)
        }
        
        
    }
    
    @IBAction func createAccountAction(_ sender: Any) {
        self.performSegue(withIdentifier: "createAccountSegue", sender: self)
    }
    
}

