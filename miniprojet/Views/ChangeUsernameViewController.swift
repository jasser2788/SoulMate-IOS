//
//  ChangeUsernameViewController.swift
//  miniprojet
//
//  Created by Mac2021 on 12/4/2022.
//

import UIKit
import Alamofire
import CometChatPro

class ChangeUsernameViewController: UIViewController {
    let userViewModel = UserViewModel()
    let catalogueViewModel = CatalogueViewModel()

    let spinner = SpinnerViewController()

    @IBOutlet weak var newusernameLabel: UITextField!
    @IBOutlet weak var confirmbtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmbtn.layer.cornerRadius = 20
   }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)

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

    @IBAction func confirmAction(_ sender: Any) {
        if (newusernameLabel.text == "") {
            alertMessage(message: "Please type your username")
            return
        }
        else if (newusernameLabel.text!.count < 3) {
            alertMessage(message: "Username must contain at least 3 characters")
            return
        }
        else {  startSpinner()
        userViewModel.changeUsername(newusername: newusernameLabel.text!.lowercased(),id: UserDefaults.standard.string(forKey: "idUser")!) { success, reponse in
                self.stopSpinner()
                if success {
                    let utilisateur = reponse as! UserModel
                    if (utilisateur._id != "") {
                        
                        self.alertMessageBackToProfile(message: "Username Changed")

                        self.changeUsernameChat()
                    }else{
                        self.alertMessage(message: "Username Already exist")

                    }
                    
                } else {
                    self.alertMessage(message: "Error")

                }
            }
            catalogueViewModel.changeCatalogueUsername(newusername: newusernameLabel.text!.lowercased(),user_id: UserDefaults.standard.string(forKey: "idUser")!) { success, reponse in
                    self.stopSpinner()
                    if success {
                        let catalogue = reponse as! Catalogue
                        if (catalogue._id != "") {
                            
                          print("catalogue username changed")
                           
                        }else{
                            print("Error")

                        }
                        
                    } else {
                        print("Error")

                    }
                }
            
        }
    }
    func  changeUsernameChat()
      {
          let updateUser : User = User(uid: UserDefaults.standard.string(forKey: "idUser")!, name: UserDefaults.standard.string(forKey: "username")!) // Replace with your uid and the name for the user to be created.
          
          updateUser.avatar = "https://firebasestorage.googleapis.com/v0/b/soulmateios.appspot.com/o/images%2F"+UserDefaults.standard.string(forKey: "picture")!+"?alt=media"

          CometChat.updateUser(user: updateUser, apiKey: authKey, onSuccess: { (User) in
               print("User updated successfully. \(User.stringValue())")
           }) { (error) in
               print("The error is \(String(describing: error?.description))")
           }
      }
    func alertMessage(message: String) {
        
        
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    func alertMessageBackToProfile(message: String) {
        
        
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler:{
          actions in
          //  self.performSegue(withIdentifier: "backLoginSegue", sender: nil)
        //    self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: false, completion: nil)

                                               
        }
        )
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
