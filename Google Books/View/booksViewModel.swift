//
//  booksViewModel.swift
//  Google Books
//
//  Created by Yashaswini Ashrith on 4/21/21.
//

import Foundation
import PromiseKit

class booksViewModel {
    
    func getAllBooks(_ url : String) -> Promise<[ModelBook]>{
        
        return Promise<[ModelBook]> { seal -> Void in
            
            getAFResponseJSON(url).done { json in
                
                var result = [ModelBook]()
                let allBooks = json["items"]
                
                for book in allBooks.arrayValue{
                    
                    let aBook = ModelBook()
                    
                    aBook.id = book["id"].stringValue
                    aBook.title = book["volumeInfo"]["title"].stringValue
                    if aBook.title.count == 0{
                        aBook.title = "No Title available"
                    }
                    
                    let authors = book["volumeInfo"]["authors"].array ?? []
                    
                    if authors.count == 0 {
                        aBook.authors = "Author details not available"
                    }else{
                        var author = ""
                        for a in authors{
                            author += "\(a.stringValue)"+", "
                        }
                        author.removeLast()
                        author.removeLast()
                        aBook.authors = author
                    }
                    aBook.publishedDate = book["volumeInfo"]["publishedDate"].stringValue
                    aBook.description = book["volumeInfo"]["description"].stringValue
                    if aBook.description.count == 0{
                        aBook.description = "No Description available"
                    }
                    
                    aBook.category = book["volumeInfo"]["categories"].stringValue
                    aBook.averageRating = book["volumeInfo"]["averageRating"].floatValue
                    aBook.imageURL = book["volumeInfo"]["imageLinks"]["thumbnail"].stringValue
                    aBook.language = book["volumeInfo"]["language"].stringValue
                    aBook.previewLink = book["volumeInfo"]["previewLink"].stringValue
                    aBook.saleability = book["saleInfo"]["saleability"].stringValue
                    aBook.buyLink = book["saleInfo"]["buyLink"].stringValue
                    aBook.webReaderLink = book["accessInfo"]["webReaderLink"].stringValue
                    
                    result.append(aBook)
                }
                seal.fulfill(result)
            }.catch{ error in
                seal.reject(error)
            }
        }
    }
}
