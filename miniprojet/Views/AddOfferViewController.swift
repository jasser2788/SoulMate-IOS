//
//  AddOfferViewController.swift
//  miniprojet
//
//  Created by Mac2021 on 12/4/2022.
//

import UIKit
import Alamofire
import Firebase
class AddOfferViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate {
    let catalogueViewModel = CatalogueViewModel()
    var imagePicker = UIImagePickerController()
    let spinner = SpinnerViewController()

    var imagename:String = ""
    weak var delegate: mapViewController!

    private let storage = Storage.storage().reference()

    @IBOutlet weak var offerTextF: UITextField!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var descriptionTextF: UITextView!
    @IBOutlet weak var addbtn: UIButton!
  
    @IBOutlet weak var addlocationbtn: UIButton!
    @IBOutlet weak var addlbtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        descriptionTextF.delegate = self
        descriptionTextF.text = "Description"
        descriptionTextF.textColor = UIColor.lightGray
        let mycolor = UIColor(red: 0.765, green: 0.553, blue: 0.580, alpha: 1.0)

        addbtn.layer.cornerRadius = 20
        addlocationbtn.layer.cornerRadius = 20
        imageview.layer.borderWidth = 2
        imageview.layer.masksToBounds = false
        imageview.layer.borderColor = mycolor.cgColor
        imageview.layer.cornerRadius = 20
        imageview.clipsToBounds = true
        descriptionTextF.layer.borderColor = UIColor.gray.cgColor
        descriptionTextF.layer.borderWidth = 1
        // create tap gesture recognizer
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.imageTapped(gesture:)))

                // add it to the image view;
                imageview.addGestureRecognizer(tapGesture)
                // make sure imageView can be interacted with by user
                imageview.isUserInteractionEnabled = true

    }
  
    override func viewWillAppear(_ animated: Bool) {
        

       
        navigationController?.setNavigationBarHidden(false, animated: false)
  
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = UIColor.lightGray
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
                imageview.image = image
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
    
    @IBAction func addAction(_ sender: Any) {
 
        if (offerTextF.text == "") {
            alertMessage(message: "Offer must not be empty")
            return
        }
        else if (offerTextF.text!.count < 4) {
            alertMessage(message: "Offer must contain at least 4 characters")
            return
        }else if (descriptionTextF.text == "") {
            alertMessage(message: "Description must not be empty")
            return
        }else if (descriptionTextF.text!.count < 10) {
            alertMessage(message: "Description must contain at least 10 characters")
            return
        }
        else{
        startSpinner()
        catalogueViewModel.addPost(user_id: UserDefaults.standard.string(forKey: "idUser")!, category: offerTextF.text!, description: descriptionTextF.text!, username: UserDefaults.standard.string(forKey: "username")!, picture: imagename,latitude: latitude,longitude: longitude ) { success, reponse in
            self.stopSpinner()
            if success {
            let catalogue = reponse as! Catalogue
            if (catalogue._id != "") {
                
                self.alertMessageBackToMyOffer(message: "Catalogue Added")
                latitude = 0.0
                longitude = 0.0
               
            }else{
                self.alertMessage(message: "Error")

            }
            
        } else {
            self.alertMessage(message: "Error")

        }
        }
        }
    }
    func alertMessage(message: String) {
        
        
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    func alertMessageBackToMyOffer(message: String) {
        
        
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler:{
          actions in
          //  self.performSegue(withIdentifier: "backLoginSegue", sender: nil)
            //self.navigationController?.popViewController(animated: true)
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
