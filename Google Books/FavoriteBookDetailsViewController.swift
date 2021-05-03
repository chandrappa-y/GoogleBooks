//
//  FavoriteBookDetailsViewController.swift
//  Google Books
//
//  Created by Yashaswini Ashrith on 4/25/21.
//

import UIKit
import Cosmos
import TinyConstraints

class FavoriteBookDetailsViewController: UIViewController {
    
    var selectedFavBook : ModelBook = ModelBook()
    
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookDescription: UITextView!
    @IBOutlet weak var cosmosRating: CosmosView!
    @IBOutlet weak var downloadBtn: UIButton!
    @IBOutlet weak var readOnlineBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookTitle.text = selectedFavBook.title
        bookAuthor.text = selectedFavBook.authors
        bookDescription.text = "\t\(selectedFavBook.description)"
        
        let imgurl = selectedFavBook.imageURL
        
        if let url = NSURL(string: imgurl ?? "") {
            if let data = NSData(contentsOf: url as URL) {
                bookImage.image = UIImage(data: data as Data)
            }
        }
        
        cosmosRating.rating = Double(selectedFavBook.averageRating)
        downloadBtn.layer.cornerRadius = 10
        readOnlineBtn.layer.cornerRadius = 10
    }
    
    
    @IBAction func downloadAction(_ sender: Any) {
        if selectedFavBook.buyLink.isEmpty || selectedFavBook.buyLink == ""{
            let alert = UIAlertController(title: "Not Available", message: "Sorry, This book is not available to buy or download.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            UIApplication.shared.open(URL(string: selectedFavBook.buyLink)! as URL,options: [:],completionHandler: nil)
        }
    }
    
    @IBAction func readOnlineAction(_ sender: Any) {
        if selectedFavBook.webReaderLink.isEmpty || selectedFavBook.webReaderLink == ""{
            let alert = UIAlertController(title: "Not Available", message: "Sorry, No more Information is available", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else {
            UIApplication.shared.open(URL(string: selectedFavBook.webReaderLink)! as URL,options: [:],completionHandler: nil)
        }
    }
    
    
}
