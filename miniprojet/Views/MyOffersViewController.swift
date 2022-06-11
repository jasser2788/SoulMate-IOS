//
//  MyOffersViewController.swift
//  miniprojet
//
//  Created by iMac on 7/4/2022.
//

import UIKit
import Alamofire

class MyOffersViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate {
    var catalogues : [Catalogue] = []
    var cataloguesSearch : [Catalogue] = []
    var catalogueViewModel = CatalogueViewModel()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var AddBtn: UIButton!
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
        let text: String = self.searchBar.text ?? ""
        self.catalogues = []
        for item in self.cataloguesSearch {
            if (item.category.lowercased().contains(text.lowercased())
            ) {
                self.catalogues.append(item)
                
            }
           
        }
            
    
       
        
        if (text.isEmpty){
            self.catalogues = self.cataloguesSearch
        }
        self.collectionview.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return catalogues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OfferCell", for: indexPath)

        let cv = cell.contentView
        let imageView = cv.viewWithTag(1) as! UIImageView
        let offer = cv.viewWithTag(2) as! UILabel

        offer.text = catalogues[indexPath.row].category
       // print( catalogues[indexPath.row].picture)
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

       
        return cell
       


    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailsOSegue", sender: indexPath)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailsOSegue"{
            let indexPath = sender as! IndexPath
            let destination = segue.destination as! MyOfferDetailsViewController
            destination.catalogues = catalogues[indexPath.row]
           
        }
        
       
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)

        AddBtn.layer.cornerRadius = AddBtn.frame.size.width/2
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)

        fetchAllCatalogue()
      
    }
    

  
    
    func fetchAllCatalogue ()  {
        catalogueViewModel.fetchuserdata(user_id: UserDefaults.standard.string(forKey: "idUser")!){success, cat in
            if success {
                self.catalogues = cat!
                self.cataloguesSearch = cat!

                
                self.collectionview.reloadData()
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
