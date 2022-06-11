//
//  ProfileViewController.swift
//  miniprojet
//
//  Created by Mac2021 on 12/4/2022.
//

import UIKit
import Alamofire
import FirebaseStorage
import CometChatPro

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
class ProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    let userViewModel = UserViewModel()
    var pictureName: String = ""
    var imagename:String = ""
    var imagePicker = UIImagePickerController()
    let spinner = SpinnerViewController()
   
    private let storage = Storage.storage().reference()
    @IBOutlet weak var changeusername: UIButton!
    @IBOutlet weak var changepasswordbtn: UIButton!
    @IBOutlet weak var logoutbtn: UIButton!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var addemailbtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        let mycolor = UIColor(red: 0.765, green: 0.553, blue: 0.580, alpha: 1.0)

        imageview.layer.borderWidth = 2
        imageview.layer.masksToBounds = false
        imageview.layer.borderColor = mycolor.cgColor
        imageview.layer.cornerRadius = imageview.frame.height/2
        imageview.clipsToBounds = true
        
        addemailbtn.layer.cornerRadius = 20
        changeusername.layer.cornerRadius = 20
        changepasswordbtn.layer.cornerRadius = 20
        logoutbtn.layer.cornerRadius = 20
        
        
        // create tap gesture recognizer
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.imageTapped(gesture:)))

                // add it to the image view;
                imageview.addGestureRecognizer(tapGesture)
                // make sure imageView can be interacted with by user
                imageview.isUserInteractionEnabled = true
        
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        username.text = UserDefaults.standard.string(forKey: "username")!.capitalizingFirstLetter()
        setImage(from:"https://firebasestorage.googleapis.com/v0/b/soulmateios.appspot.com/o/images%2F"+UserDefaults.standard.string(forKey: "picture")!+"?alt=media")
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        username.text = UserDefaults.standard.string(forKey: "username")!.capitalizingFirstLetter()
        setImage(from:"https://firebasestorage.googleapis.com/v0/b/soulmateios.appspot.com/o/images%2F"+UserDefaults.standard.string(forKey: "picture")!+"?alt=media")
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
        storage.child("images/"+imagename).putData(imageData, metadata: nil, completion: { _, error in
            guard error == nil else {
                self.alertMessage(message: "Failed to upload")

                self.stopSpinner()
                return
            }
           
            self.storage.child("images/"+self.imagename).downloadURL(completion: { url, error in
                guard let url = url, error == nil else {
                    return
                }
                let urlString = url.absoluteString
                self.stopSpinner()
                self.changePicture()
                print("Download URL: \(urlString)")

            })
            
        })
        }
    func changePicture () {
    userViewModel.changePicture(newpicture: imagename,id: UserDefaults.standard.string(forKey: "idUser")!) { success, reponse in
            self.stopSpinner()
            if success {
                let utilisateur = reponse as! UserModel
                if (utilisateur._id != "") {
                    self.changePictureChat()

                    self.alertMessage(message: "Picture Changed")
                }else{
                    self.alertMessage(message: "Error")

                }
                
            } else {
                self.alertMessage(message: "Error")

            }
        }
    }
  func  changePictureChat()
    {
        let updateUser : User = User(uid: UserDefaults.standard.string(forKey: "idUser")!, name: UserDefaults.standard.string(forKey: "username")!) // Replace with your uid and the name for the user to be created.
        
        updateUser.avatar = "https://firebasestorage.googleapis.com/v0/b/soulmateios.appspot.com/o/images%2F"+UserDefaults.standard.string(forKey: "picture")!+"?alt=media"

        CometChat.updateUser(user: updateUser, apiKey: authKey, onSuccess: { (User) in
             print("User updated successfully. \(User.stringValue())")
         }) { (error) in
             print("The error is \(String(describing: error?.description))")
         }
    }
    @IBAction func logoutAction(_ sender: Any) {
        if let appDomain = Bundle.main.bundleIdentifier {
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
         }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "loginviewcontroller") as? UIViewController else { print("error"); return }
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated:true, completion:nil)
    }
    
    
    func setImage(from url: String) -> Void {
        guard let imageURL = URL(string: url) else { return }

            // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.imageview.image = image
            }
        }
    }
    
    @IBAction func switchDark(_ sender: UISwitch) {
        guard (UIApplication.shared.connectedScenes.first as? UIWindowScene) != nil else { return }
        
        let appDelegate = UIApplication.shared.windows.first
        if(sender.isOn)
        {
            appDelegate?.overrideUserInterfaceStyle = .dark
        }else{
            appDelegate?.overrideUserInterfaceStyle = .light
        }
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
