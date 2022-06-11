//
//  EnterEmailViewController.swift
//  miniprojet
//
//  Created by iMac on 17/5/2022.
//

import UIKit

class EnterEmailViewController: UIViewController {
    let userViewModel = UserViewModel()
    let spinner = SpinnerViewController()

    @IBOutlet weak var confirmbtn: UIButton!
    @IBOutlet weak var emailtext: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmbtn.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
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

    @IBAction func confirmaction(_ sender: Any) {
        if (emailtext.text! .isEmpty) {
            alertMessage(message: "Please type your email")
            return
        }
         if (!isValidEmail(email: emailtext.text!)) {
            alertMessage(message: "Email not valid")
            return
        }
        else{
        startSpinner()
        userViewModel.changepass(email: emailtext.text!) { success, reponse in
            self.stopSpinner()
            if success {
                let code = reponse as? String
                if (code != nil) {
                    self.performSegue(withIdentifier: "mailcodeSegue", sender: code)
                }else{
                    self.alertMessage(message: "User don't exist")
                }
                
            } else {
                self.alertMessage(message: "Check your connection")
            }
        }
    }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! EnterCodeViewController
        destination.code = sender as? String
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
