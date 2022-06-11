//
//  DetailsViewController.swift
//  miniprojet
//
//  Created by iMac on 8/4/2022.
//

import UIKit
import Alamofire
import CometChatPro

class DetailsViewController: UIViewController {
    var catalogues : Catalogue?
    let userViewModel = UserViewModel()
    let spinner = SpinnerViewController()


    
    @IBOutlet weak var showlocationbtn: UIButton!
    @IBOutlet weak var startchatbtn: UIButton!
    @IBOutlet weak var addfavoritebtn: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(catalogues?.username == UserDefaults.standard.string(forKey: "username")!)
        {
            startchatbtn.isHidden = true
            addfavoritebtn.isHidden = true
        }
        
        if(catalogues!.latitude == 0.0 &&
           catalogues!.longitude == 0.0)
        {
            showlocationbtn.isHidden = true
        }else {
            showlocationbtn.isHidden = false

        }
       
        offerLabel.text = catalogues?.category
        ownerLabel.text = catalogues?.username
        descriptionLabel.text = catalogues?.description
        let mycolor = UIColor(red: 0.765, green: 0.553, blue: 0.580, alpha: 1.0)

        //image.image = UIImage(named: imagename!)
           image.layer.borderWidth = 2
            image.layer.masksToBounds = false
            image.layer.borderColor = mycolor.cgColor
            image.layer.cornerRadius = 20
            image.clipsToBounds = true
        startchatbtn.layer.cornerRadius = 20
        addfavoritebtn.layer.cornerRadius = 20
        showlocationbtn.layer.cornerRadius = 20
        setImage(from: "https://firebasestorage.googleapis.com/v0/b/soulmateios.appspot.com/o/catalogueImg%2F"+catalogues!.picture+"?alt=media")
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
       
    }
   
    func setImage(from url: String) -> Void {
         guard let imageURL = URL(string: url) else { return }

             // just not to cause a deadlock in UI!
         DispatchQueue.global().async {
             guard let imageData = try? Data(contentsOf: imageURL) else { return }

             let image = UIImage(data: imageData)
             DispatchQueue.main.async {
                 self.image.image = image
             }
         }
     }
   
    
    @IBAction func showLocationAction(_ sender: Any) {
        performSegue(withIdentifier: "mapDetailsSegue", sender: sender)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapDetailsSegue"{
            let destination = segue.destination as! MapDetailViewController
            destination.maplatitude = catalogues!.latitude
            destination.maplongitude = catalogues!.longitude

        }
    }
    @IBAction func startChatAction(_ sender: Any) {
   
       
        //DispatchQueue.main.async {
            let messagelist = SingleChatViewController()
            let user = User(uid: self.catalogues!.user_id, name: self.catalogues!.username)

           messagelist.set(conversationWith: user, type: .user)
            messagelist.modalPresentationStyle = .fullScreen
            //self.navigationController?.pushViewController(messagelist, animated: true)
            self.present(messagelist, animated: false, completion: nil)
            
       // }
      
       
    }
    @IBAction func addFavoritebtn(_ sender: UIButton) {
        sender.shake()
        startSpinner()
        userViewModel.addFavorite(idCatalogue: catalogues!._id, id: UserDefaults.standard.string(forKey: "idUser")!) { success, reponse in
                self.stopSpinner()
                if success {
                    let utilisateur = reponse as! UserModel
                    if (utilisateur._id != "") {
                        
                        self.alertMessageBack(message: "Added to favorite")

                       
                    }else{
                       
                        self.alertMessage(message: "Already in favorite")
                    }
                    
                } else {
                    self.alertMessage(message: "connection error")

                }
            }
    }
    func alertMessageBack(message: String) {
        
        
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler:{
          actions in
          //  self.performSegue(withIdentifier: "backLoginSegue", sender: nil)
            self.navigationController?.popViewController(animated: true)

                                               
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
