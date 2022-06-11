//
//  EmailViewController.swift
//  miniprojet
//
//  Created by iMac on 17/5/2022.
//

import UIKit

class EmailViewController: UIViewController {
    let userViewModel = UserViewModel()
    let spinner = SpinnerViewController()

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmbtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmbtn.layer.cornerRadius = 20

        // Do any additional setup after loading the view.
    }
    

    @IBAction func confirmAction(_ sender: Any) {
        if (emailTextField.text == "") {
            alertMessage(message: "Please type your email")
            return
        }
        if (!isValidEmail(email: emailTextField.text!)) {
           alertMessage(message: "Email not valid")
           return
       }
        else{
            startSpinner()
            userViewModel.changeEmail(email: emailTextField.text!.lowercased(),id: UserDefaults.standard.string(forKey: "idUser")!) { success, reponse in
                    self.stopSpinner()
                    if success {
                        let utilisateur = reponse as! UserModel
                        if (utilisateur._id != "") {
                            
                            self.alertMessageBackToProfile(message: "Email has been added")

                        }else{
                            self.alertMessage(message: "Er")

                        }
                        
                    } else {
                        self.alertMessage(message: "Error")

                    }
                }
        }
        
    }
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
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
