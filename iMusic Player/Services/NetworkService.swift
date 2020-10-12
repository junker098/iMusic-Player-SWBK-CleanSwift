//
//  NetworkService.swift
//  iMusic Player
//
//  Created by Юрий Могорита on 01.10.2020.
//  Copyright © 2020 Yuri Mogorita. All rights reserved.
//

import Foundation
import Alamofire

class NetworkService {
    
    func fetchTracks(searchText: String, completion: @escaping (SearchResponse?) -> Void) {
        let url = "https://itunes.apple.com/search"
        let parametrs = ["term":"\(searchText)",
                         "limit":"10",
                         "media":"music"]
        AF.request(url, method: .get, parameters: parametrs, encoding: URLEncoding.default, headers: nil).responseData { (responseData) in
            if let error = responseData.error {
                print("Error to read data \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = responseData.data else { return }
            let decoder = JSONDecoder()
            do {
                let objects = try decoder.decode(SearchResponse.self, from: data)
                completion(objects)
                print("Objects in", objects)
                
            } catch {
                completion(nil)
                print("Error JSON decode data is pass \(error.localizedDescription)")
            }
        }
    }
}
