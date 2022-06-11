//
//  MyOfferDetailsViewController.swift
//  miniprojet
//
//  Created by Mac2021 on 12/4/2022.
//

import UIKit
import Alamofire
import FirebaseStorage
import CometChatPro

class MyOfferDetailsViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    var catalogues : Catalogue?
    let catalogueViewModel = CatalogueViewModel()
    let spinner = SpinnerViewController()
    var pictureName: String = ""
    var imagename:String = ""
    var imagePicker = UIImagePickerController()
    private let storage = Storage.storage().reference()

    @IBOutlet weak var updatebtn: UIButton!
    @IBOutlet weak var deletebtn: UIButton!
    @IBOutlet weak var offerTfiels: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descTview: UITextView!
    @IBOutlet weak var uodatelocationbtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mycolor = UIColor(red: 0.765, green: 0.553, blue: 0.580, alpha: 1.0)
        imagename = catalogues!.picture
        uodatelocationbtn.layer.cornerRadius = 20
        updatebtn.layer.cornerRadius = 20
        deletebtn.layer.cornerRadius = 20
        imageView.layer.borderWidth = 2
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = mycolor.cgColor
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        descTview.layer.borderColor = UIColor.gray.cgColor
        descTview.layer.borderWidth = 1
        setImage(from: "https://firebasestorage.googleapis.com/v0/b/soulmateios.appspot.com/o/catalogueImg%2F"+catalogues!.picture+"?alt=media")
        
        offerTfiels.text = catalogues?.category
        descTview.text = catalogues?.description
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        // create tap gesture recognizer
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.imageTapped(gesture:)))

                // add it to the image view;
        imageView.addGestureRecognizer(tapGesture)
                // make sure imageView can be interacted with by user
        imageView.isUserInteractionEnabled = true

    }
    
    @IBAction func updateLOcationAction(_ sender: Any) {
        performSegue(withIdentifier: "updateSegue", sender: sender)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updateSegue"{
            let destination = segue.destination as! mapViewController
            print(catalogues!.latitude)
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
                 self.imageView.image = image
             }
         }
     }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UIImageView) != nil {
            print("Image Tapped")
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                        imagePicker.delegate = self
                        imagePicker.sourceType = .photoLibrary
                        imagePicker.allowsEditing = false

                        present(imagePicker, animated: true, completion: nil)
                    }

           
        }
    }
   func randomString(length: Int) -> String {
     let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
     return String((0..<length).map{ _ in letters.randomElement()! })
   }
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           picker.dismiss(animated: true, completion: nil)
           if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
               imageView.image = image
           }
        guard let image2 = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else{
           return
           
       }
       guard let imageData = image2.pngData() else{
           return
       }
       imagename = randomString(length: 45)
       startSpinner()
       storage.child("catalogueImg/"+imagename).putData(imageData, metadata: nil, completion: { _, error in
           guard error == nil else {
               self.alertMessage(message: "Failed to upload")

               self.stopSpinner()
               return
           }
          
           self.storage.child("catalogueImg/"+self.imagename).downloadURL(completion: { url, error in
               guard let url = url, error == nil else {
                   return
               }
               let urlString = url.absoluteString
               self.stopSpinner()
               print("Download URL: \(urlString)")

           })
           
       })
       }
    @IBAction func updateAction(_ sender: Any) {
        if (descTview.text == "") {
            alertMessage(message: "Description must not be empty")
            return
        }
        else if (descTview.text!.count < 10) {
            alertMessage(message: "Description must contain at least 10 characters")
            return
        } else if (offerTfiels.text == "") {
            alertMessage(message: "Offer must not be empty")
            return
        }
        else if (offerTfiels.text!.count < 4) {
            alertMessage(message: "Offer must contain at least 4 characters")
            return
        }
        else {  startSpinner()
            print(latitude)
            catalogueViewModel.updatePost(id: catalogues!._id,newOffer: offerTfiels.text!,newDesc: descTview.text!,newPic: imagename,maplatitude: latitude, maplongitude: longitude) { success, reponse in
                self.stopSpinner()
                if success {
                    let catalogue = reponse as! Catalogue
                    if (catalogue._id != "") {
                        
                        self.alertMessageBack(message: "Post updated")

                       
                    }else{
                       
                        self.alertMessage(message: "Error")
                    }
                    
                } else {
                    self.alertMessage(message: "Connection error")

                }
            }
            
            
        }
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        startSpinner()
            catalogueViewModel.deletePost(id: catalogues!._id) { success, reponse in
                self.stopSpinner()
                if success {
                    let catalogue = reponse as! Catalogue
                    if (catalogue._id != "") {
                        
                        self.alertMessageBack(message: "Post deleted")

                       
                    }else{
                       
                        self.alertMessage(message: "Error")
                    }
                    
                } else {
                    self.alertMessage(message: "Connection error")

                }
            }
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
            self.dismiss(animated: true, completion: nil)
                                               
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
