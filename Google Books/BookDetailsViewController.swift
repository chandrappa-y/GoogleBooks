//
//  BookDetailsViewController.swift
//  Google Books
//
//  Created by Yashaswini Ashrith on 4/21/21.
//

import UIKit
import Cosmos
import TinyConstraints
import Firebase


class BookDetailsViewController: UIViewController {
    
    @IBOutlet weak var FavBtn: UIButton!
    let database = Firestore.firestore()
    
    var  book : ModelBook = ModelBook()
    
    var dataEx : Any?
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var imgBook: UIImageView!
    
    @IBOutlet weak var lblAuthors: UILabel!
    
    @IBOutlet weak var downloadBtn: UIButton!
    
    @IBOutlet weak var readOnlineBtn: UIButton!
    
    @IBOutlet weak var lblBookDescription: UITextView!
    
    
    @IBOutlet weak var cosmosRating: CosmosView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initalizeData()
        downloadBtn.layer.cornerRadius = 10
        readOnlineBtn.layer.cornerRadius = 10
    }
    
    func initalizeData() {
        lblTitle.text = book.title
        lblAuthors.text = "\(book.authors)"
        cosmosRating.rating = Double(book.averageRating)
        lblBookDescription.text = "\t\(book.description)"
        
        
        let imgurl = book.imageURL
        
        if let url = NSURL(string: imgurl ?? "") {
                if let data = NSData(contentsOf: url as URL) {
                    imgBook.image = UIImage(data: data as Data)
                }
            }
    }

    @IBAction func downloadBtnAction(_ sender: Any) {
        if book.buyLink.isEmpty || book.buyLink == ""{
            let alert = UIAlertController(title: "Not Available", message: "Sorry, This book is not available to buy or download.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            UIApplication.shared.open(URL(string: book.buyLink)! as URL,options: [:],completionHandler: nil)
        }
    }
    
    @IBAction func webReadBtnAction(_ sender: Any) {
        if book.webReaderLink.isEmpty || book.webReaderLink == ""{
            let alert = UIAlertController(title: "Not Available", message: "Sorry, No more Information is available", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else {
            UIApplication.shared.open(URL(string: book.webReaderLink)! as URL,options: [:],completionHandler: nil)
        }
    }
    
    @IBAction func wantToReadAction(_ sender: Any) {
        
        let keyChain = KeychainService().keyChain
        
        let userId = keyChain.get("uid")
        
        let docData: [String : Any] = [
            "authors" : book.authors,
            "title":book.title,
            "buyLink":book.buyLink,
            "webReaderLink": book.webReaderLink,
            "description":book.description,
            "averageRating":book.averageRating,
            "imageURL":book.imageURL]

        database.collection("\(userId)").document("\(book.id)").setData(docData){ error in
            if let err = error {
                print("Error in writing -- \(err)")
            }else {
                print("Successfully added")
                self.FavBtn.setTitle("Added", for: .normal)
            }
        }
    }
    
}

        
        

