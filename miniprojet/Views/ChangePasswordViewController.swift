//
//  ChangePasswordViewController.swift
//  miniprojet
//
//  Created by Mac2021 on 12/4/2022.
//

import UIKit
import Alamofire
class ChangePasswordViewController: UIViewController {
    let userViewModel = UserViewModel()
    let catalogueViewModel = CatalogueViewModel()

    let spinner = SpinnerViewController()
    @IBOutlet weak var confirmbtn: UIButton!
    @IBOutlet weak var newpasswordLabel: UITextField!
    @IBOutlet weak var confirmnewpasswordLabel: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        confirmbtn.layer.cornerRadius = 20
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        if (newpasswordLabel.text == "") {
            alertMessage(message: "Please type your password")
            return
        }
        else if (newpasswordLabel.text!.count < 8) {
            alertMessage(message: "Password must contain at least 8 characters")
            return
        } else if (newpasswordLabel.text != confirmnewpasswordLabel.text) {
            alertMessage(message: "Password is not the same")
            return
        }
        else {  startSpinner()
            userViewModel.changePassword(newpassword: newpasswordLabel.text!,id: UserDefaults.standard.string(forKey: "idUser")!) { success, reponse in
                self.stopSpinner()
                if success {
                    let utilisateur = reponse as! UserModel
                    if (utilisateur._id != "") {
                        
                        self.alertMessageBackToProfile(message: "Password Changed")

                       
                    }else{
                       
                        self.alertMessage(message: "Error")
                    }
                    
                } else {
                    self.alertMessage(message: "Error")

                }
            }
            
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
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
         //   self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: false, completion: nil)

                                               
        }
        )
        alert.addAction(action)
        self.present(alert, animated: true)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
