//
//  ViewController.swift
//  miniprojet
//
//  Created by Mac-Mini-2021 on 07/04/2022.
//

import UIKit
import Alamofire
import CometChatPro
import GoogleSignIn

class LoginViewController: UIViewController {
    let userViewModel = UserViewModel()
    let spinner = SpinnerViewController()
    var email : String?
    var name : String?
   
 
    @IBOutlet weak var loginbtn: UIButton!
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var siginInBtn: UIButton!
    
    @IBOutlet weak var forgetpassLabel: UILabel!
    @IBOutlet weak var siginupbtn: UIButton!
    let signInConfig = GIDConfiguration.init(clientID: "345710833963-pid7ksbtkrgp4di7q0bhrlgk3qv5objo.apps.googleusercontent.com")
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        forgetpassLabel.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.labelTapped(gesture:)))

        // add it to the image view;
        forgetpassLabel.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        forgetpassLabel.isUserInteractionEnabled = true
        
        siginupbtn.layer.cornerRadius = 20
        siginInBtn.layer.cornerRadius = 20
        loginbtn.layer.cornerRadius = 20
        passwordLabel.isSecureTextEntry = true
    }
    @objc func labelTapped(gesture: UIGestureRecognizer) {

        performSegue(withIdentifier: "changepassSegue", sender: nil)
    }
    
    @IBAction func googlesigininBtn(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { [self] user, error in
          guard error == nil else { return }
            guard let user = user else { return }

                let emailAddress = user.profile?.email
               // let fullName = user.profile?.name
                let givenName = user.profile?.givenName
            self.email = emailAddress!
            self.name = givenName!
            print(self.email!  )
            print(self.name!)
            
            if(name != nil)
            {
                signinGoogle()
            
            }else{
                self.alertMessage(message: "Error")
            }
          // If sign in succeeded, display the app's main content View.
        }
    }
   
   
    
    func signinGoogle(){
        startSpinner()
    userViewModel.login(username: email!,password:"s*ec*re!tG0*0gL*Epa!s*s*wo*rd100A!zTTr3924FD!Sfs4!56") { success, reponse in
        self.stopSpinner()
        if success {
            let utilisateur = reponse as! UserModel
            print(utilisateur)
            if (utilisateur._id != "") {
                UserDefaults.standard.setValue(self.name!, forKey: "username")
               self.connectchat()
                self.performSegue(withIdentifier: "loginSegue", sender: nil)

            }else{
                self.alertMessage(message: "User don't exist")
            }
            
        } else {
            self.alertMessage(message: "Check your connection")
        }
        UserDefaults.standard.setValue(self.name!, forKey: "username")

    }
    }
    func startSpinner() {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    func stopSpinner() {
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
    }
    @IBAction func loginBtn(_ sender: UIButton) {
        sender.pulse()


        print("fghfghgfhfghfghgvbhnbvnbvnbvnbvnbvnbvnbvnbvnbvnbvnbvnbvnbvnbvnbvnbvnbvnbvnbvnbvn")
        if(usernameLabel.text! .isEmpty || passwordLabel.text!.isEmpty){
            self.alertMessage(message: "Credentials must not be empty")
        }
        startSpinner()
        userViewModel.login(username: usernameLabel.text!, password: passwordLabel.text!) { success, reponse in
            self.stopSpinner()
            if success {
                let utilisateur = reponse as! UserModel
                print(utilisateur)
                if (utilisateur._id != "") {
                   self.connectchat()
                    self.performSegue(withIdentifier: "loginSegue", sender: sender)
                }else{
                    self.alertMessage(message: "User don't exist")
                }
                
            } else {
                self.alertMessage(message: "Check your connection")
            }
        }
    }
   func connectchat(){
       CometChat.login(UID: UserDefaults.standard.string(forKey: "idUser")!, apiKey: authKey, onSuccess: { (user) in
          print("Login successful: " + user.stringValue())
        }) { (error) in
          print("Login failed with error: " + error.errorDescription);
        }
    }
    @IBAction func signUpBtn(_ sender: UIButton) {
        sender.shake()
        
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          guard let controller = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? UIViewController else { print("error"); return }
           /*guard let navigationController = navigationController else { print("this vc is not embedded in navigationController"); return }
        navigationController.pushViewController(controller, animated: true)*/
          controller.modalPresentationStyle = .fullScreen
          self.present(controller, animated:true, completion:nil)
    }
    
  
    func alertMessage(message: String) {
        
        
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true)
    }

}

