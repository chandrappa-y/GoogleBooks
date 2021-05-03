//
//  SignUpViewController.swift
//  Google Books
//
//  Created by Yashaswini Ashrith on 4/21/21.
//

import UIKit
import Firebase
import SwiftSpinner

class SignUpViewController: UIViewController {

    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblStatus.text = ""
        txtPassword.isSecureTextEntry = true
        imgLogo.layer.borderWidth = 0
        imgLogo.layer.masksToBounds = false
        imgLogo.layer.cornerRadius = imgLogo.frame.height/2
        imgLogo.clipsToBounds = true
        signUpBtn.layer.cornerRadius = 10
        txtEmail.layer.cornerRadius = 10
        txtPassword.layer.cornerRadius = 10
    }
    
    func addKeychainAfterLogin(_ uid : String){
        let keyChain = KeychainService().keyChain
        keyChain.set(uid, forKey: "uid")
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        
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
        
        SwiftSpinner.show("Creating account and logging in.." )
        Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPassword.text!) { (authResult, error) in
            SwiftSpinner.hide()
            guard let _ = authResult?.user, error == nil else{
                self.lblStatus.text = error?.localizedDescription
                return
            }
            
            let uid = Auth.auth().currentUser?.uid
            
            self.addKeychainAfterLogin(uid!)
            self.lblStatus.text = ""
            self.performSegue(withIdentifier: "signUpDashboardSegue", sender: self)
        }
        
    }
    
    @IBAction func haveAccountAction(_ sender: Any) {
        self.performSegue(withIdentifier: "loginSegue", sender: self)
    }

}
