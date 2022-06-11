//
//  SignUpViewController.swift
//  miniprojet
//
//  Created by Mac2021 on 12/4/2022.
//

import UIKit
import Alamofire
import AuthenticationServices
import CometChatPro
import GoogleSignIn

class SignUpViewController: UIViewController {
    let userViewModel = UserViewModel()
    let spinner = SpinnerViewController()
    var email : String?
    var name : String?
    
    let signInConfig = GIDConfiguration.init(clientID: "345710833963-pid7ksbtkrgp4di7q0bhrlgk3qv5objo.apps.googleusercontent.com")
    


    
    
    @IBOutlet weak var signupgoogle: UIButton!
    @IBOutlet weak var loginbtn: UIButton!
    @IBOutlet weak var signupbtn: UIButton!
    @IBOutlet weak var usernameTfield: UITextField!
    @IBOutlet weak var passwordTfield: UITextField!
    @IBOutlet weak var confirmpasswordTfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signupgoogle.layer.cornerRadius = 20
        loginbtn.layer.cornerRadius = 20
        signupbtn.layer.cornerRadius = 20
        
        passwordTfield.isSecureTextEntry = true
        confirmpasswordTfield.isSecureTextEntry = true

    }
    
  
    @IBAction func signupgoole(_ sender: UIButton) {
        sender.pulse()
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
                signupGoogle()
            }else {
            }
          
            }
         
          // If sign in succeeded, display the app's main content View.
        }
        
    
    
func signupGoogle()
    {
        startSpinner()
        userViewModel.signup(username: email!,password:"s*ec*re!tG0*0gL*Epa!s*s*wo*rd100A!zTTr3924FD!Sfs4!56") { success, reponse in
            self.stopSpinner()
            if success {
                let utilisateur = reponse as! UserModel
                if (utilisateur._id != "") {
                    UserDefaults.standard.setValue(self.name!, forKey: "username")

                    self.createuser()
                    self.alertMessageBackToLogin(message: "\nAccount created \n\n you can now login")

                }else{
                    self.alertMessage(message: "User Already exist")
                }
                
            } else {
                self.alertMessage(message: "Check your connection")
            }
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
    
    @IBAction func signupBtn(_ sender: Any) {
        if (usernameTfield.text == "") {
            alertMessage(message: "Please type your username")
            return
        }
        else if (passwordTfield.text == "") {
            alertMessage(message: "Please type your password")
            return
        }
       else if (passwordTfield.text!.count < 8) {
            alertMessage(message: "Password must contain at least 8 characters")
            return
        }
       else if (passwordTfield.text !=  confirmpasswordTfield.text) {
            alertMessage(message: "Password is not the same")
            return
        }
        else {
            startSpinner()
            userViewModel.signup(username: usernameTfield.text!, password: passwordTfield.text!) { success, reponse in
                self.stopSpinner()
                if success {
                    let utilisateur = reponse as! UserModel
                    if (utilisateur._id != "") {
                        self.createuser()
                        self.alertMessageBackToLogin(message: "\nAccount created \n\n you can now login")

                    }else{
                        self.alertMessage(message: "Username Already exist")
                    }
                    
                } else {
                    self.alertMessage(message: "Check your connection")
                }
            }
            
        }
    }
    
    func createuser(){
        let newUser : User = User(uid: UserDefaults.standard.string(forKey: "idUser")!, name: UserDefaults.standard.string(forKey: "username")!)
        
    CometChat.createUser(user: newUser, apiKey: authKey, onSuccess: { (User) in
          print("User created successfully. \(User.stringValue())")
      }) { (error) in
         print("The error is \(String(describing: error?.description))")
    }
    }
    @IBAction func loginBtn(_ sender: UIButton) {
        sender.shake()
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          guard let controller = storyboard.instantiateViewController(withIdentifier: "loginviewcontroller") as? UIViewController else { print("error"); return }
           /*guard let navigationController = navigationController else { print("this vc is not embedded in navigationController"); return }
        navigationController.pushViewController(controller, animated: true)*/
          controller.modalPresentationStyle = .fullScreen
          self.present(controller, animated:true, completion:nil)
    }
    
   
    func alertMessageBackToLogin(message: String) {
        
        
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler:{
          actions in
          //  self.performSegue(withIdentifier: "backLoginSegue", sender: nil)
            self.dismiss(animated: true, completion: nil)
        }
        )
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    func alertMessage(message: String) {
        
        
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}


