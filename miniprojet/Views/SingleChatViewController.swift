//
//  SingleChatViewController.swift
//  miniprojet
//
//  Created by lou&mo on 14/5/2022.
//

import UIKit

class SingleChatViewController: CometChatMessageList {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
       // let mycolor = UIColor(red: 0.973, green: 0.976, blue: 0.957, alpha: 1.0)


        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 30, width: view.frame.size.width, height: 44))
        view.addSubview(navBar)

        let navItem = UINavigationItem(title: "")
        //navItem.titleView?.backgroundColor =
        
        //let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(addTapped))
        let backbutton = UIButton(type: .custom)
        backbutton.setImage(UIImage(named: "chats-back.png"), for: .normal)
        backbutton.tintColor = UIKitSettings.primaryColor
        // Image can be downloaded from here below link
           //backbutton.setTitle("Back", for: .normal)
           backbutton.setTitleColor(backbutton.tintColor, for: .normal) // You can change the TitleColor
        backbutton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        navItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
        
       //navItem.leftBarButtonItem = doneItem
        navBar.barTintColor = UIColor.white
        navBar.setItems([navItem], animated: false)
    }
    
    @objc func addTapped(){
        self.dismiss(animated: false, completion: nil)

    }
    override func viewDidAppear(_ animated: Bool) {
      /*  let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        view.addSubview(navBar)

        let navItem = UINavigationItem(title: "SomeTitle")
        //let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(selectorName:))
       // navItem.rightBarButtonItem = doneItem

        navBar.setItems([navItem], animated: false)*/
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
