//
//  FavoritesViewController.swift
//  miniprojet
//
//  Created by iMac on 7/4/2022.
//

import UIKit
import Alamofire
import CometChatPro

class FavoritesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    var data = ["music","wedding","music"]
    var catalogues : [Catalogue] = []
    var cataloguesSearch : [Catalogue] = []

    var catalogueViewModel = CatalogueViewModel()
    let userViewModel = UserViewModel()

   @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var TableView: UITableView!
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text: String = self.searchBar.text ?? ""
        self.catalogues = []
        for item in self.cataloguesSearch {
            if (item.category.lowercased().contains(text.lowercased())
                || item.username.lowercased().contains(text.lowercased())
            ) {
                self.catalogues.append(item)
                
            }
           
        }
            
     
       
        
        if (text.isEmpty){
            self.catalogues = self.cataloguesSearch
        }
        self.TableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catalogues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell")
        let contentView = cell?.contentView
        
       // let label = contentView?.viewWithTag(1) as! UILabel
        let imageView = contentView?.viewWithTag(1) as! UIImageView
        let offer = contentView?.viewWithTag(2) as! UILabel
        let owner = contentView?.viewWithTag(3) as! UILabel
        offer.text = catalogues[indexPath.row].category
        owner.text = catalogues[indexPath.row].username
        
        //label.text = favorites[indexPath.row]
        setImage(from: "https://firebasestorage.googleapis.com/v0/b/soulmateios.appspot.com/o/catalogueImg%2F"+catalogues[indexPath.row].picture+"?alt=media")
      
        let mycolor = UIColor(red: 0.765, green: 0.553, blue: 0.580, alpha: 1.0)

        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = mycolor.cgColor
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        
       func setImage(from url: String) -> Void {
            guard let imageURL = URL(string: url) else { return }

                // just not to cause a deadlock in UI!
            DispatchQueue.global().async {
                guard let imageData = try? Data(contentsOf: imageURL) else { return }

                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }

        return cell!
    }
    

   
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)

        fetchFavorite()
    }
    override func viewDidLoad() {
        navigationController?.setNavigationBarHidden(true, animated: false)

        super.viewDidLoad()

       
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailsFSegue", sender: indexPath)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailsFSegue"{
            let indexPath = sender as! IndexPath
            let destination = segue.destination as! DetailsFavoriteViewController
            destination.catalogues = catalogues[indexPath.row]
           
        }
        
       
    }
    
   
    
    
    
    func fetchFavorite ()  {
        catalogueViewModel.fetchFavorite(id: UserDefaults.standard.string(forKey: "idUser")!){success, cat in
            if success {
                self.catalogues = cat!
                self.cataloguesSearch = cat!

                self.TableView.reloadData()
            }else {
                self.alertMessage(message: "Error")
            }
        }
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
