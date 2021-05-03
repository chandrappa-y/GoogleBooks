//
//  Services.swift
//  Google Books
//
//  Created by Yashaswini Ashrith on 4/21/21.
//

import Foundation
import Alamofire
import SwiftyJSON
import PromiseKit

func getAFResponseJSONArray(_ url : String) -> Promise<[JSON]>{
    
    return Promise<[JSON]> { seal -> Void in
        
        AF.request(url).responseJSON { response in
            
            if response.error != nil {
                seal.reject(response.error!)
            }
            
            let jsonArray: [JSON] = JSON(response.data).arrayValue
            seal.fulfill(jsonArray)
        }
        
    }
    
}

func getAFResponseJSON(_ url : String) -> Promise<JSON>{
    
    return Promise<JSON> { seal -> Void in
        
        AF.request(url).responseJSON { response in

            if response.error != nil {
                seal.reject(response.error!)
            }
            
            let json: JSON = JSON(response.data)
            seal.fulfill(json)
        }
    }
    
}
