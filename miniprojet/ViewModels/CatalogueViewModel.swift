//
//  CatalogueViewModel.swift
//  miniprojet
//
//  Created by Apple Esprit on 18/4/2022.
//

import Foundation
import SwiftyJSON
import Alamofire
import UIKit.UIImage

public class CatalogueViewModel{

    func fetchdata(  completed: @escaping ( Bool, [Catalogue]?) -> Void )
    {
       

        AF.request(HOST_URL + "catalogues",
                   method: .get)
            
            .responseData { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.data!)
                    
                    var catalogues : [Catalogue]? = []
                    for singleJsonItem in jsonData {
                        catalogues!.append(self.makePublication(jsonItem: singleJsonItem.1))
                    }
                    completed(true, catalogues)
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    func fetchuserdata(user_id : String,  completed: @escaping ( Bool, [Catalogue]?) -> Void )
    {
       

        AF.request(HOST_URL + "catalogues/userpost",
                   method: .post,
                   parameters: ["user_id": user_id])
            
            .responseData { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.data!)
                    
                    var catalogues : [Catalogue]? = []
                    for singleJsonItem in jsonData {
                        catalogues!.append(self.makePublication(jsonItem: singleJsonItem.1))
                    }
                    completed(true, catalogues)
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    func changeCatalogueUsername(newusername: String, user_id: String, completed: @escaping (Bool, Any?) -> Void) {
        AF.request(HOST_URL + "catalogues/updatename/",
                   method: .patch,
                   parameters: ["username": newusername, "user_id": user_id])
            
            .responseData { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.data!)
                    let catalogue = self.makeItem(jsonItem: jsonData)
                    
                    //print(utilisateur)
                    completed(true,catalogue)
                case let .failure(error):
                    print(error)
                    completed(false,nil)
                }
            }
    }
    func addPost(user_id: String, category: String,description: String,username: String,picture: String,latitude: Double,longitude: Double, completed: @escaping (Bool, Any?) -> Void) {
        AF.request(HOST_URL + "catalogues/add/",
                   method: .post,
                   parameters: ["user_id": user_id,"category": category,"description": description,"username": username,"picture": picture,"latitude": latitude,"longitude": longitude])
            
            .responseData { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.data!)
                    let catalogue = self.makeItem(jsonItem: jsonData)
                    
                    print(catalogue)
                    completed(true,catalogue)
                case let .failure(error):
                    print(error)
                    completed(false,nil)
                }
            }
    }
    func updatePost( id: String,newOffer: String,newDesc: String,newPic: String,maplatitude: Double,maplongitude: Double, completed: @escaping (Bool, Any?) -> Void) {
        AF.request(HOST_URL + "catalogues/update/" + id,
                   method: .patch,
                   parameters: ["description": newDesc,"category": newOffer,"picture": newPic,"latitude": maplatitude,"longitude":maplongitude ])
            
            .responseData { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.data!)
                    let catalogues = self.makeItem(jsonItem: jsonData)
                 
                    //print(utilisateur)
                    completed(true,catalogues)
                case let .failure(error):
                    print(error)
                    completed(false,nil)
                }
            }
    }
    func deletePost( id: String, completed: @escaping (Bool, Any?) -> Void) {
        AF.request(HOST_URL + "catalogues/delete/" + id,
                   method: .delete)
            
            .responseData { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.data!)
                    let catalogues = self.makeItem(jsonItem: jsonData)
                 
                    //print(utilisateur)
                    completed(true,catalogues)
                case let .failure(error):
                    print(error)
                    completed(false,nil)
                }
            }
    }
    func fetchFavorite( id: String, completed: @escaping (Bool, [Catalogue]?) -> Void) {
        AF.request(HOST_URL + "catalogues/getfavorite/" + id,
                   method: .get)
            
            
            .responseData { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.data!)
                    
                    var catalogues : [Catalogue]? = []
                    for singleJsonItem in jsonData {
                        catalogues!.append(self.makePublication(jsonItem: singleJsonItem.1))
                    }
                    completed(true, catalogues)
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    
    func makeItem(jsonItem: JSON) -> Catalogue {
        
      
        
        return Catalogue(
            _id: jsonItem["_id"].stringValue,
            category: jsonItem["category"].stringValue,
            picture: jsonItem["picture"].stringValue,
            username: jsonItem["username"].stringValue,
            user_id: jsonItem["user_id"].stringValue,
            description: jsonItem["description"].stringValue,
            ownerpic: jsonItem["ownerpic"].stringValue,
            latitude: jsonItem["latitude"].doubleValue,
            longitude: jsonItem["longitude"].doubleValue
        )
    }

    func makePublication(jsonItem: JSON) -> Catalogue {
       
        return Catalogue(
            _id: jsonItem["_id"].stringValue,
            category: jsonItem["category"].stringValue,
            picture: jsonItem["picture"].stringValue,
            username: jsonItem["username"].stringValue,
            user_id: jsonItem["user_id"].stringValue,
            description: jsonItem["description"].stringValue,
            ownerpic: jsonItem["ownerpic"].stringValue,
            latitude: jsonItem["latitude"].doubleValue,
            longitude: jsonItem["longitude"].doubleValue
         
            
          
        )
    }
   /* func recupererToutPublication(  completed: @escaping (Bool, [Catalogue]?) -> Void ) {
        AF.request(HOST_URL + "catalogues",
                   method: .get)
            
            .responseData { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.data!)
                    
                    var publications : [Catalogue]? = []
                    for singleJsonItem in jsonData["catalogue"] {
                        publications!.append(self.makePublication(jsonItem: singleJsonItem.1))
                    }
                    completed(true, publications)
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }*/
    
    
}
