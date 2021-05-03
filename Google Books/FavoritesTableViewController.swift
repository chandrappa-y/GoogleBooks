//
//  FavoritesTableViewController.swift
//  Google Books
//
//  Created by Yashaswini Ashrith on 4/24/21.
//

import UIKit

class FavoritesTableViewController: UITableViewController {
    
    var allFavBooks : [ModelBook] = [ModelBook]()
    var selectedBook : ModelBook = ModelBook()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 200.0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allFavBooks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        
        let imgurl = allFavBooks[indexPath.row].imageURL
        
        if let url = NSURL(string: imgurl ?? "") {
                if let data = NSData(contentsOf: url as URL) {
                    cell.bookImage.image = UIImage(data: data as Data)
                    
                }
            }
        cell.bookTitle.text = allFavBooks[indexPath.row].title
        cell.bookAuthor.text = allFavBooks[indexPath.row].authors
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.selectedBook = allFavBooks[indexPath.row]
        self.performSegue(withIdentifier: "favBookDetailsSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "favBookDetailsSegue"){
            let displayVC = segue.destination as! FavoriteBookDetailsViewController
            displayVC.selectedFavBook = selectedBook
        }
    }
}
