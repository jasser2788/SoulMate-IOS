//
//  EnterCodeViewController.swift
//  miniprojet
//
//  Created by iMac on 17/5/2022.
//

import UIKit

class EnterCodeViewController: UIViewController {
    var code:String?
    @IBOutlet weak var confirmbtn: UIButton!
    @IBOutlet weak var codetext: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmbtn.layer.cornerRadius = 20

        // Do any additional setup after loading the view.
    }
    

    @IBAction func confirmAction(_ sender: Any) {
        if (codetext.text == "") {
            alertMessage(message: "Enter your code")
            return
        }
        else if( code! == codetext.text!) {
            alertMessageBackToLogin(message: "You can now login")

        }else {
            alertMessage(message: "Wrong code")

        }
    }
    func alertMessageBackToLogin(message: String) {
        
        
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler:{
          actions in
          //  self.performSegue(withIdentifier: "backLoginSegue", sender: nil)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let controller = storyboard.instantiateViewController(withIdentifier: "loginviewcontroller") as? UIViewController else { print("error"); return }
             /*guard let navigationController = navigationController else { print("this vc is not embedded in navigationController"); return }
          navigationController.pushViewController(controller, animated: true)*/
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated:true, completion:nil)
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
