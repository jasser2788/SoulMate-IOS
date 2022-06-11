//
//  HomeViewController.swift
//  miniprojet
//
//  Created by iMac on 7/4/2022.
//

import UIKit
import Alamofire
import CometChatPro

class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    
  
    
    
    var options = ["Offer","Username"]
    var catalogues : [Catalogue] = []
    var cataloguesSearch : [Catalogue] = []
    var iscliked : Bool = false
    var images : [UIImage?] = []
    var catalogueViewModel = CatalogueViewModel()
    
    @IBOutlet weak var searchParamLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var tableView: UITableView!
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text: String = self.searchBar.text ?? ""
        self.catalogues = []
        if (searchParamLabel.text == "Offer"){
        for item in self.cataloguesSearch {
            if (item.category.lowercased().contains(text.lowercased())) {
                self.catalogues.append(item)
                
            }
           
        }
            
        }
        if (searchParamLabel.text == "Username"){
            for item in self.cataloguesSearch {
                if (item.username.lowercased().contains(text.lowercased())) {
                    self.catalogues.append(item)
                    
                }
               
            }
        }
        if (text.isEmpty){
            self.catalogues = self.cataloguesSearch
        }
        self.collectionView.reloadData()
    }
   
    @IBAction func btnAction(_ sender: Any) {
        
       
    }
    
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return catalogues.count    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath)

        let cv = cell.contentView
        let imageView = cv.viewWithTag(1) as! UIImageView
        let offer = cv.viewWithTag(2) as! UILabel
        let owner = cv.viewWithTag(3) as! UILabel

        offer.text = catalogues[indexPath.row].category
        owner.text = catalogues[indexPath.row].username
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
        //imageView.image = images[0]

       
        return cell    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailsSegue", sender: indexPath)

    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailsSegue"{
            let indexPath = sender as! IndexPath
            let destination = segue.destination as! DetailsViewController
            destination.catalogues = catalogues[indexPath.row]
           
        }
       
        
       
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return 2
     }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell")
        let contentView = cell?.contentView
        
       // let label = contentView?.viewWithTag(1) as! UILabel
        let label = contentView?.viewWithTag(1) as! UILabel
        label.text = options[indexPath.row]

        return cell!
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchParamLabel.text = options[indexPath.row]
        tableView.isHidden = true
    }
    @IBAction func searchParamAction(_ sender: Any) {
        tableView.isHidden = !tableView.isHidden
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        toHome = false
        navigationController?.setNavigationBarHidden(false, animated: false)


        tableView.isHidden = true

        fetchAllCatalogue()
      
    }
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        tableView.isHidden = true
        // create tap gesture recognizer
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.labelTapped(gesture:)))

                // add it to the image view;
        searchParamLabel.addGestureRecognizer(tapGesture)
                // make sure imageView can be interacted with by user
        searchParamLabel.isUserInteractionEnabled = true
    
        //fetchAllCatalogue()
        
    }
    @objc func addTapped(gesture: UIGestureRecognizer) {
        tableView.isHidden = !tableView.isHidden

    }
    @objc func labelTapped(gesture: UIGestureRecognizer) {
        tableView.isHidden = !tableView.isHidden

    }
    
    func fetchAllCatalogue ()  {
        catalogueViewModel.fetchdata{success, cat in
            if success {
                self.catalogues = cat!
                self.cataloguesSearch = cat!
                self.collectionView.reloadData()
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
