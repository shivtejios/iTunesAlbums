//
//  NetworkHandler.swift
//  iTunesAlbums
//
//  Created by Shiva Teja on 10/31/19.
//  Copyright © 2019 Verizon. All rights reserved.
//

import UIKit

class NetworkHandler: NSObject {

    static let shared = NetworkHandler()
    
    /**
     makeWebServiceCall method
     
     - important: This method makes the webservice call with provided parameters
     - returns: none
     - parameter url, completion and error
     */
    func makeWebServiceCall (url: String, completion: @escaping (_ response: [String: Any]?, _ error: Error?) -> ()) {
        let url = URL(string: url)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                do {
                    let data = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    if let responseData = data as? [String: Any] {
                        print(responseData)
                        let error:Error? = nil
                        completion(responseData, error)
                    }
                } catch let parsingError {
                    print("Error", parsingError)
                }
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }
}
