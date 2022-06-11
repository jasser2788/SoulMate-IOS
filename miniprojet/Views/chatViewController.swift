//
//  chatViewController.swift
//  miniprojet
//
//  Created by iMac on 8/4/2022.
//

import UIKit
import Alamofire
import SwiftUI

class chatViewController: UIViewController {
   override func viewDidLoad() {
       super.viewDidLoad()
    }
   
    func openchat(){
        DispatchQueue.main.async {
        let cometChatUI = CometChatUI()
            cometChatUI.setup(withStyle: .fullScreen)
        self.present(cometChatUI, animated: false, completion: nil)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if (toHome)
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let controller = storyboard.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController else { print("error"); return }
             /*guard let navigationController = navigationController else { print("this vc is not embedded in navigationController"); return }
          navigationController.pushViewController(controller, animated: true)*/
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated:false, completion:nil)
        }
        else{
            openchat()
        }
        
    }
}
