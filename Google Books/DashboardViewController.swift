//
//  DashboardViewController.swift
//  Google Books
//
//  Created by Yashaswini Ashrith on 4/20/21.
//

import UIKit
import Firebase
import SwiftSpinner

class DashboardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    
    let database = Firestore.firestore()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var MyFavsBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let viewModel = booksViewModel()

    var books : [ModelBook] = [ModelBook]()
    var selectedBook : ModelBook = ModelBook()
    var favBooks : [ModelBook] = [ModelBook]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        displayBooks(url: defaultUrl)
    }

    func displayBooks(url : String) {
        
        self.viewModel.getAllBooks(url).done { (allTheBooks) in
            SwiftSpinner.hide()
            self.books = [ModelBook]()

            for book in allTheBooks{
                self.books.append(book)
            }
            self.collectionView.reloadData()

        }.catch{ error in
            print ("Error in getting books data")
        }
        
    }
    

    @IBAction func logout(_ sender: Any) {
        do {
            
            try Auth.auth().signOut()
            KeychainService().keyChain.delete("uid")
            self.navigationController?.popViewController(animated: true)
            
        }catch{
            print(error)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCollectionViewCell", for: indexPath) as! BookCollectionViewCell
        let imgurl = books[indexPath.row].imageURL
        
        if let url = NSURL(string: imgurl ?? "") {
                if let data = NSData(contentsOf: url as URL) {
                    cell.bookImage.image = UIImage(data: data as Data)
                }
            }
            
        cell.titleLbl.text = books[indexPath.row].title
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedBook = books[indexPath.row]
        self.performSegue(withIdentifier: "bookDetailsSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "bookDetailsSegue"){
            let displayVC = segue.destination as! BookDetailsViewController
            displayVC.book = selectedBook
        }else if(segue.identifier == "favoritesSegue"){
            print("Preparing for fav segue")
            let displayVC = segue.destination as! FavoritesTableViewController
            displayVC.allFavBooks = favBooks
        }
    }
    @IBAction func viewFavs(_ sender: Any) {

        let keyChain = KeychainService().keyChain
        
        let userId = keyChain.get("uid")
        
        SwiftSpinner.show("Loading..")
        database.collection("\(userId)").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
            print("No documents")
            return
          }
            self.favBooks = [ModelBook]()
          var favBook = documents.map { queryDocumentSnapshot -> ModelBook in
            let data = queryDocumentSnapshot.data()
            let b : ModelBook = ModelBook()
            b.buyLink = data["buyLink"] as? String ?? ""
            b.authors = data["authors"] as? String ?? ""
            b.imageURL = data["imageURL"] as? String ?? ""
            b.webReaderLink = data["webReaderLink"] as? String ?? ""
            b.title = data["title"] as? String ?? ""
            b.description = data["description"] as? String ?? ""
            b.averageRating = data["averageRating"] as? Float ?? 0.0
            
            self.favBooks.append(b)
            return b
          }
            SwiftSpinner.hide()
            self.performSegue(withIdentifier: "favoritesSegue", sender: self)
            return
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        SwiftSpinner.show("Searching...")
        var searchText = searchBar.text
        searchText = searchText?.trimmingCharacters(in: .whitespacesAndNewlines)
        searchText = searchText?.replacingOccurrences(of: " ", with: "+")
        let newUrl = "\(searchUrl+searchText!+"&key="+apiKey)"
        
        if searchText == "" {
            SwiftSpinner.hide()
        }else{
            displayBooks(url: newUrl)
        }
        
    }
}
