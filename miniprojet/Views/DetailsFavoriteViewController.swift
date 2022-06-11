//
//  DetailsFavoriteViewController.swift
//  miniprojet
//
//  Created by iMac on 8/4/2022.
//

import UIKit
import Alamofire
import CometChatPro

class DetailsFavoriteViewController: UIViewController {
    var catalogues : Catalogue?
    let userViewModel = UserViewModel()
    let spinner = SpinnerViewController()

    
    @IBOutlet weak var showlocationbtn: UIButton!
    @IBOutlet weak var startChatBtn: UIButton!
    @IBOutlet weak var removebtn: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        let mycolor = UIColor(red: 0.765, green: 0.553, blue: 0.580, alpha: 1.0)
        showlocationbtn.layer.cornerRadius = 20
         image.layer.borderWidth = 2
         image.layer.masksToBounds = false
         image.layer.borderColor = mycolor.cgColor
         image.layer.cornerRadius = 20
         image.clipsToBounds = true
        startChatBtn.layer.cornerRadius = 20
         removebtn.layer.cornerRadius = 20
        if(catalogues!.latitude == 0.0 &&
           catalogues!.longitude == 0.0)
        {
            showlocationbtn.isHidden = true
        }else {
            showlocationbtn.isHidden = false

        }
       
     
    }
    override func viewWillAppear(_ animated: Bool) {
       
            navigationController?.setNavigationBarHidden(false, animated: false)
        
        offerLabel.text = catalogues?.category
        ownerLabel.text = catalogues?.username
        descLabel.text = catalogues?.description
        setImage(from: "https://firebasestorage.googleapis.com/v0/b/soulmateios.appspot.com/o/catalogueImg%2F"+catalogues!.picture+"?alt=media")
    }
    @IBAction func showlocationAction(_ sender: Any) {
        performSegue(withIdentifier: "mapDetailsFavSegue", sender: sender)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapDetailsFavSegue"{
            let destination = segue.destination as! MapDetailViewController
            destination.maplatitude = catalogues!.latitude
            destination.maplongitude = catalogues!.longitude

        }
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
   
    @IBAction func removeFavAction(_ sender: Any) {
        
  startSpinner()
            userViewModel.removeFavorite(idCatalogue: catalogues!._id, id: UserDefaults.standard.string(forKey: "idUser")!) { success, reponse in
                self.stopSpinner()
                if success {
                    let utilisateur = reponse as! UserModel
                    if (utilisateur._id != "") {
                        
                        self.alertMessageBack(message: "Removed from favorite")

                       
                    }else{
                       
                        self.alertMessage(message: "Error")
                    }
                    
                } else {
                    self.alertMessage(message: "connection error")

                }
            }
            
            
        }
    
    @IBAction func startChatBtn(_ sender: Any) {
        let messagelist = SingleChatViewController()
        let user = User(uid: self.catalogues!.user_id, name: self.catalogues!.username)

       messagelist.set(conversationWith: user, type: .user)
        messagelist.modalPresentationStyle = .fullScreen
        //self.navigationController?.pushViewController(messagelist, animated: true)
        self.present(messagelist, animated: false, completion: nil)
    }
  
   
    func alertMessage(message: String) {
        
        
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true)
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
