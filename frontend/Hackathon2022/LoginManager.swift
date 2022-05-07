//
//  LoginManager.swift
//  Hackathon2022
//
//  Created by Joanna Lin on 5/4/22.
//

import Foundation
import Alamofire

struct LoginManager {
    static let host = "http://34.130.154.75"

    static func getUser(email: String, password: String, completion: @escaping (Bool, TAStudent?) -> Void) {
                
        let endpoint = "\(host)/login/"
        let params: Parameters = [
            "email" : email,
            "password" : password,
//            "is_ta": true
        ]
        
        AF.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseData { response in
            //process the response
            switch (response.result){
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
           
                if let userResponse = try? jsonDecoder.decode(TAStudent.self, from: data){
                    completion(true, userResponse)
                }
                else{
                    print ("Failed to decode getUser")
                }
                
            case .failure(let error):
                print (error.localizedDescription)
                completion(false, nil)
                
            }
            
        }
}
    
    
}
