//
//  UserViewModel.swift
//  miniprojet
//
//  Created by Apple Esprit on 18/4/2022.
//

import Foundation
import SwiftyJSON
import Alamofire
import UIKit.UIImage
import CometChatPro

public class UserViewModel{
    func changepass(email: String, completed: @escaping (Bool, Any?) -> Void) {
        AF.request(HOST_URL + "users/changepass/" + email,
                   method: .get)
            
            .responseData { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.data!)

                    let code = jsonData["code"].stringValue
            print(code)
                    completed(true, code)
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    func login(username: String, password: String, completed: @escaping (Bool, Any?) -> Void) {
        AF.request(HOST_URL + "users/login",
                   method: .post,
                   parameters: ["username": username, "password": password])
           
            .responseData { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.data!)
                    let utilisateur = self.makeItem(jsonItem: jsonData)
            
                    UserDefaults.standard.setValue(utilisateur._id, forKey: "idUser")
                    UserDefaults.standard.setValue(utilisateur.username, forKey: "username")
                    UserDefaults.standard.setValue(utilisateur.password, forKey: "password")
                    UserDefaults.standard.setValue(utilisateur.picture, forKey: "picture")
                    completed(true, utilisateur)
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
   
    func signup(username: String, password: String, completed: @escaping (Bool, Any?) -> Void) {
        AF.request(HOST_URL + "users/signup",
                   method: .post,
                   parameters: ["username": username, "password": password])
            
            .responseData { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.data!)
                    let utilisateur = self.makeItem(jsonItem: jsonData)
                    print(utilisateur)
                    UserDefaults.standard.setValue(utilisateur._id, forKey: "idUser")
                    UserDefaults.standard.setValue(utilisateur.username, forKey: "username")
                    UserDefaults.standard.setValue(utilisateur.password, forKey: "password")
                    UserDefaults.standard.setValue(utilisateur.picture, forKey: "picture")
                    completed(true,utilisateur)

                case let .failure(error):
                    print(error)
                    completed(false,nil)
                }
            }
    
  
    }
    func changeUsername(newusername: String, id: String, completed: @escaping (Bool, Any?) -> Void) {
        AF.request(HOST_URL + "users/update/" + id,
                   method: .patch,
                   parameters: ["username": newusername])
            
            .responseData { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.data!)
                    let utilisateur = self.makeItem(jsonItem: jsonData)
                    if (utilisateur._id != "")
                    {
                        UserDefaults.standard.setValue(utilisateur.username, forKey: "username")
                    }
                    //print(utilisateur)
                    completed(true,utilisateur)
                case let .failure(error):
                    print(error)
                    completed(false,nil)
                }
            }
    }
    func changePicture(newpicture: String, id: String, completed: @escaping (Bool, Any?) -> Void) {
        AF.request(HOST_URL + "users/update/" + id,
                   method: .patch,
                   parameters: ["picture": newpicture])
            
            .responseData { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.data!)
                    let utilisateur = self.makeItem(jsonItem: jsonData)
                    if (utilisateur._id != "")
                    {
                        UserDefaults.standard.setValue(utilisateur.picture, forKey: "picture")
                    }
                    //print(utilisateur)
                    completed(true,utilisateur)
                case let .failure(error):
                    print(error)
                    completed(false,nil)
                }
            }
    }
    func changeEmail(email: String, id: String, completed: @escaping (Bool, Any?) -> Void) {
        AF.request(HOST_URL + "users/update/" + id,
                   method: .patch,
                   parameters: ["email": email])
            
            .responseData { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.data!)
                    let utilisateur = self.makeItem(jsonItem: jsonData)
                    if (utilisateur._id != "")
                    {
                        UserDefaults.standard.setValue(utilisateur.username, forKey: "username")
                    }
                    //print(utilisateur)
                    completed(true,utilisateur)
                case let .failure(error):
                    print(error)
                    completed(false,nil)
                }
            }
    }
    func changePassword(newpassword: String, id: String, completed: @escaping (Bool, Any?) -> Void) {
        AF.request(HOST_URL + "users/update/" + id,
                   method: .patch,
                   parameters: ["password": newpassword])
            
            .responseData { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.data!)
                    let utilisateur = self.makeItem(jsonItem: jsonData)
                    if (utilisateur._id != "")
                    {
                        UserDefaults.standard.setValue(utilisateur.picture, forKey: "picture")
                    }
                    //print(utilisateur)
                    completed(true,utilisateur)
                case let .failure(error):
                    print(error)
                    completed(false,nil)
                }
            }
    }
    func addFavorite(idCatalogue : String, id: String, completed: @escaping (Bool, Any?) -> Void) {
        AF.request(HOST_URL + "users/addfavorite/" + id,
                   method: .patch,
                   parameters: ["favorite": idCatalogue])
            
            .responseData { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.data!)
                    let utilisateur = self.makeItem(jsonItem: jsonData)
                    completed(true,utilisateur)
                case let .failure(error):
                    print(error)
                    completed(false,nil)
                }
            }
    }
    func removeFavorite(idCatalogue : String, id: String, completed: @escaping (Bool, Any?) -> Void) {
        AF.request(HOST_URL + "users/removefavorite/" + id + "/" + idCatalogue,
                   method: .patch)
            
            .responseData { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.data!)
                    let utilisateur = self.makeItem(jsonItem: jsonData)
                    completed(true,utilisateur)
                case let .failure(error):
                    print(error)
                    completed(false,nil)
                }
            }
    }
    func makeItem(jsonItem: JSON) -> UserModel {
        
        var favoriteArray : [String] = []
        for singleJsonItem in jsonItem["favorite"]   {
            favoriteArray.append(singleJsonItem.1.stringValue)
        }
        
        return UserModel(
            _id: jsonItem["_id"].stringValue,
            username: jsonItem["username"].stringValue,
            password: jsonItem["password"].stringValue,
            picture: jsonItem["picture"].stringValue,
            email: jsonItem["email"].stringValue,
            favorite: favoriteArray
            

        )
    }

}
